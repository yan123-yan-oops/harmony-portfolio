import { Task, Schedule } from './AIResponse'

export interface RawTaskData {
  id: string
  name: string
  description?: string
  estimated_minutes: number
  priority: string
  deadline?: string
  category?: string
  isCompleted?: number
}

export interface RawScheduleData {
  task_id: string
  start_time: string
  end_time: string
  pomodoro_count: number
  priority?: string
}

export interface RawApiResponse {
  tasks: RawTaskData[]
  schedule: RawScheduleData[]
  motivation: string
}

export interface CloudFunctionResult {
  code: number
  message: string
  data?: Object
}

export interface HuaweiLoginResult {
  unionId: string
  jwtToken: string
}

export interface UserPreferencesData {
  work_start: string
  work_end: string
}

export interface GeneratePlanBody {
  input: string
  date: string
  user_preferences: UserPreferencesData
}

export interface HuaweiLoginBody {
  authorizationCode: string
}

export interface MappedPlanResult {
  tasks: Task[]
  schedule: Schedule[]
  motivation: string
}

function mapPriority(priority: string): 'high' | 'medium' | 'low' {
  if (priority === 'high') {
    return 'high'
  }
  if (priority === 'low') {
    return 'low'
  }
  return 'medium'
}

function mapTask(raw: RawTaskData): Task {
  return new Task({
    id: raw.id,
    name: raw.name,
    description: raw.description ?? '',
    estimatedMinutes: raw.estimated_minutes,
    priority: mapPriority(raw.priority),
    deadline: raw.deadline ?? '',
    category: raw.category ?? 'work'
  })
}

function mapSchedule(raw: RawScheduleData, date: string): Schedule {
  const priority: 'high' | 'medium' | 'low' = mapPriority(raw.priority ?? 'medium')
  return new Schedule({
    taskId: raw.task_id,
    date: date,
    startTime: raw.start_time,
    endTime: raw.end_time,
    pomodoroCount: raw.pomodoro_count
  })
}

export function mapApiResponse(rawData: RawApiResponse, date: string): MappedPlanResult {
  const tasks: Task[] = []
  const schedules: Schedule[] = []
  for (let i: number = 0; i < rawData.tasks.length; i++) {
    tasks.push(mapTask(rawData.tasks[i]))
  }
  for (let i: number = 0; i < rawData.schedule.length; i++) {
    schedules.push(mapSchedule(rawData.schedule[i], date))
  }
  const result: MappedPlanResult = {
    tasks: tasks,
    schedule: schedules,
    motivation: rawData.motivation
  }
  return result
}
