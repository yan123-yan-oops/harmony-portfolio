interface TaskConstructorData {
  id?: string
  name?: string
  description?: string
  estimatedMinutes?: number
  priority?: 'high' | 'medium' | 'low'
  deadline?: string
  category?: string
  isCompleted?: boolean
  createdAt?: string
}

interface ScheduleConstructorData {
  id?: string
  taskId?: string
  date?: string
  startTime?: string
  endTime?: string
  pomodoroCount?: number
  isSyncedToCalendar?: boolean
  calendarEventId?: string
}

interface AIResponseConstructorData {
  tasks?: Task[]
  schedule?: Schedule[]
  motivation?: string
}

interface UserProfileConstructorData {
  unionId?: string
  nickname?: string
  phone?: string
  jwtToken?: string
  timePreference?: string
  pomodoroDuration?: number
  createdAt?: string
}

interface DailyStatsConstructorData {
  date?: string
  totalTasks?: number
  completedTasks?: number
  totalPomodoros?: number
  completionRate?: number
}

export class Task {
  id: string
  name: string
  description: string
  estimatedMinutes: number
  priority: 'high' | 'medium' | 'low'
  deadline: string
  category: string
  isCompleted: boolean
  createdAt: string

  constructor(data?: TaskConstructorData) {
    this.id = data?.id ?? ''
    this.name = data?.name ?? ''
    this.description = data?.description ?? ''
    this.estimatedMinutes = data?.estimatedMinutes ?? 0
    this.priority = data?.priority ?? 'medium'
    this.deadline = data?.deadline ?? ''
    this.category = data?.category ?? 'work'
    this.isCompleted = data?.isCompleted ?? false
    this.createdAt = data?.createdAt ?? new Date().toISOString()
  }
}

export class Schedule {
  id: string
  taskId: string
  date: string
  startTime: string
  endTime: string
  pomodoroCount: number
  isSyncedToCalendar: boolean
  calendarEventId: string

  constructor(data?: ScheduleConstructorData) {
    this.id = data?.id ?? ''
    this.taskId = data?.taskId ?? ''
    this.date = data?.date ?? ''
    this.startTime = data?.startTime ?? ''
    this.endTime = data?.endTime ?? ''
    this.pomodoroCount = data?.pomodoroCount ?? 1
    this.isSyncedToCalendar = data?.isSyncedToCalendar ?? false
    this.calendarEventId = data?.calendarEventId ?? ''
  }
}

export class AIResponse {
  tasks: Task[]
  schedule: Schedule[]
  motivation: string

  constructor(data?: AIResponseConstructorData) {
    this.tasks = data?.tasks ?? []
    this.schedule = data?.schedule ?? []
    this.motivation = data?.motivation ?? ''
  }
}

export class UserProfile {
  unionId: string
  nickname: string
  phone: string
  jwtToken: string
  timePreference: string
  pomodoroDuration: number
  createdAt: string

  constructor(data?: UserProfileConstructorData) {
    this.unionId = data?.unionId ?? ''
    this.nickname = data?.nickname ?? ''
    this.phone = data?.phone ?? ''
    this.jwtToken = data?.jwtToken ?? ''
    this.timePreference = data?.timePreference ?? '09:00-18:00'
    this.pomodoroDuration = data?.pomodoroDuration ?? 25
    this.createdAt = data?.createdAt ?? new Date().toISOString()
  }
}

export class DailyStats {
  date: string
  totalTasks: number
  completedTasks: number
  totalPomodoros: number
  completionRate: number

  constructor(data?: DailyStatsConstructorData) {
    this.date = data?.date ?? ''
    this.totalTasks = data?.totalTasks ?? 0
    this.completedTasks = data?.completedTasks ?? 0
    this.totalPomodoros = data?.totalPomodoros ?? 0
    this.completionRate = data?.completionRate ?? 0
  }
}
