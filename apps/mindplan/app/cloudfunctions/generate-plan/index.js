const axios = require('axios');
const Ajv = require('ajv');
const addFormats = require('ajv-formats');
const { buildPrompt, buildStrictPrompt } = require('./prompt');
const { AI_RESPONSE_SCHEMA } = require('./schema');

const ajv = new Ajv();
addFormats(ajv);
const validate = ajv.compile(AI_RESPONSE_SCHEMA);

const DEEPSEEK_API_URL = 'https://api.bailian.aliyun.com/v1/chat/completions';
const DEEPSEEK_API_KEY = process.env.DEEPSEEK_API_KEY;

let responseCache = null;
let cacheKey = null;
let cacheTimestamp = 0;
const CACHE_TTL_MS = 5 * 60 * 1000;

function generateId(prefix) {
  const timestamp = Date.now().toString(36);
  const random = Math.random().toString(36).substring(2, 6);
  return `${prefix}_${timestamp}${random}`;
}

function assignTaskIds(parsed) {
  const idMap = {};
  parsed.tasks = parsed.tasks.map((task, index) => {
    const id = generateId('task');
    idMap[index] = id;
    return { ...task, id };
  });
  parsed.schedule = parsed.schedule.map((item) => {
    const taskIndex = parsed.tasks.findIndex(
      (t) => t.name === item.task_id || t.id === item.task_id
    );
    const actualId = taskIndex >= 0 ? parsed.tasks[taskIndex].id : item.task_id;
    return { ...item, task_id: actualId };
  });
  return parsed;
}

async function callDeepSeek(promptText) {
  const response = await axios.post(
    DEEPSEEK_API_URL,
    {
      model: 'deepseek-v4-flash',
      messages: [
        { role: 'system', content: promptText }
      ],
      temperature: 0.3,
      max_tokens: 2048
    },
    {
      headers: {
        'Authorization': `Bearer ${DEEPSEEK_API_KEY}`,
        'Content-Type': 'application/json'
      },
      timeout: 30000
    }
  );

  if (!response.data || !response.data.choices || !response.data.choices[0]) {
    throw new Error('DeepSeek API returned unexpected response structure');
  }

  const content = response.data.choices[0].message.content;
  const jsonMatch = content.match(/\{[\s\S]*\}/);
  if (!jsonMatch) {
    throw new Error('No JSON found in DeepSeek response');
  }

  return JSON.parse(jsonMatch[0]);
}

async function generatePlanWithRetry(userInput, userPreferences, dateStr) {
  const primaryPrompt = buildPrompt(userInput, userPreferences, dateStr);
  let parsed = await callDeepSeek(primaryPrompt);
  parsed = assignTaskIds(parsed);

  if (validate(parsed)) {
    return parsed;
  }

  console.warn('Schema validation failed on first attempt, retrying with strict prompt...');
  console.warn('Validation errors:', validate.errors);

  const strictPrompt = buildStrictPrompt(userInput, userPreferences, dateStr);
  let retryParsed = await callDeepSeek(strictPrompt);
  retryParsed = assignTaskIds(retryParsed);

  if (validate(retryParsed)) {
    return retryParsed;
  }

  console.error('Schema validation failed after retry');
  console.error('Validation errors:', validate.errors);
  throw new Error('AI response failed schema validation after retry');
}

function getFromCache(input) {
  const now = Date.now();
  if (cacheKey === input && (now - cacheTimestamp) < CACHE_TTL_MS) {
    console.log('Cache hit for input:', input);
    return responseCache;
  }
  return null;
}

function setCache(input, data) {
  cacheKey = input;
  responseCache = data;
  cacheTimestamp = Date.now();
}

exports.handler = async (event, context) => {
  try {
    if (!DEEPSEEK_API_KEY) {
      return {
        code: 500,
        message: 'DeepSeek API key not configured'
      };
    }

    const body = typeof event.body === 'string' ? JSON.parse(event.body) : event.body;

    if (!body || !body.input || typeof body.input !== 'string' || body.input.trim().length === 0) {
      return {
        code: 400,
        message: 'Invalid input: input text is required'
      };
    }

    const userInput = body.input.trim();
    const userPreferences = body.user_preferences || null;
    const dateStr = body.date || new Date().toISOString().split('T')[0];

    const cached = getFromCache(userInput);
    if (cached) {
      return {
        code: 0,
        message: 'success (cached)',
        data: cached
      };
    }

    const result = await generatePlanWithRetry(userInput, userPreferences, dateStr);

    setCache(userInput, result);

    return {
      code: 0,
      message: 'success',
      data: result
    };
  } catch (error) {
    console.error('generate-plan error:', error.message);

    if (error.response) {
      console.error('API response status:', error.response.status);
      console.error('API response data:', error.response.data);
    }

    return {
      code: 500,
      message: `Internal error: ${error.message}`
    };
  }
};
