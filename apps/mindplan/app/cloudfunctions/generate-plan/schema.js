const AI_RESPONSE_SCHEMA = {
  type: 'object',
  required: ['tasks', 'schedule', 'motivation'],
  additionalProperties: false,
  properties: {
    tasks: {
      type: 'array',
      minItems: 1,
      items: {
        type: 'object',
        required: ['name', 'estimated_minutes', 'priority'],
        additionalProperties: false,
        properties: {
          id: { type: 'string' },
          name: { type: 'string', minLength: 1 },
          description: { type: 'string' },
          estimated_minutes: { type: 'integer', minimum: 1 },
          priority: { enum: ['high', 'medium', 'low'] },
          deadline: { type: 'string' },
          category: { type: 'string' }
        }
      }
    },
    schedule: {
      type: 'array',
      minItems: 1,
      items: {
        type: 'object',
        required: ['task_id', 'start_time', 'end_time', 'pomodoro_count'],
        additionalProperties: false,
        properties: {
          task_id: { type: 'string' },
          start_time: {
            type: 'string',
            pattern: '^\\d{2}:\\d{2}$'
          },
          end_time: {
            type: 'string',
            pattern: '^\\d{2}:\\d{2}$'
          },
          pomodoro_count: { type: 'integer', minimum: 1 },
          priority: { enum: ['high', 'medium', 'low'] }
        }
      }
    },
    motivation: { type: 'string', minLength: 1 }
  }
};

module.exports = { AI_RESPONSE_SCHEMA };
