import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { DatabaseHelper } from '../../../../main/ets/database/DatabaseHelper';
import { TaskDao } from '../../../../main/ets/database/TaskDao';
import { ScheduleDao } from '../../../../main/ets/database/ScheduleDao';
import { StatsDao } from '../../../../main/ets/database/StatsDao';
import { Task, Schedule } from '../../../../main/ets/model/AIResponse';

export default function databaseTest() {
  describe('DatabaseHelperTest', () => {
    let dbHelper: DatabaseHelper;
    let taskDao: TaskDao;
    let scheduleDao: ScheduleDao;
    let statsDao: StatsDao;

    beforeAll(async () => {
      dbHelper = new DatabaseHelper()
      await dbHelper.init(getContext())
      taskDao = new TaskDao(dbHelper.getStore())
      scheduleDao = new ScheduleDao(dbHelper.getStore())
      statsDao = new StatsDao(dbHelper.getStore())
    })

    beforeEach(async () => {
      await dbHelper.clearAll()
    })

    afterAll(async () => {
      await dbHelper.deleteDb()
    })

    it('init_creates_all_tables', 0, async () => {
      const store = dbHelper.getStore()
      expect(store).not().undefined()
    })

    it('taskDao_insertTask_returns_rowId', 0, async () => {
      const task = new Task({ id: 'task_test_1', name: '写周报', estimatedMinutes: 45, priority: 'high', deadline: '', category: 'work' })
      const rowId: number = await taskDao.insert(task)
      expect(rowId).assertGreater(0)
    })

    it('taskDao_queryById_returns_correct_task', 0, async () => {
      const task = new Task({ id: 'task_test_2', name: '健身', estimatedMinutes: 60, priority: 'medium', category: 'health' })
      await taskDao.insert(task)
      const result: Task = await taskDao.queryById('task_test_2')
      expect(result.name).assertEqual('健身')
      expect(result.estimatedMinutes).assertEqual(60)
      expect(result.priority).assertEqual('medium')
      expect(result.category).assertEqual('health')
    })

    it('taskDao_queryAll_returns_all_tasks', 0, async () => {
      await taskDao.insert(new Task({ id: 't1', name: '任务一', estimatedMinutes: 30, priority: 'high' }))
      await taskDao.insert(new Task({ id: 't2', name: '任务二', estimatedMinutes: 20, priority: 'low' }))
      const all: Task[] = await taskDao.queryAll()
      expect(all.length).assertEqual(2)
    })

    it('taskDao_update_completed_status', 0, async () => {
      const task = new Task({ id: 'task_test_3', name: '写周报', estimatedMinutes: 45, priority: 'high', isCompleted: false })
      await taskDao.insert(task)
      await taskDao.updateCompleted('task_test_3', true)
      const updated: Task = await taskDao.queryById('task_test_3')
      expect(updated.isCompleted).assertTrue()
    })

    it('taskDao_delete_removes_task', 0, async () => {
      await taskDao.insert(new Task({ id: 'task_test_4', name: '删除测试', estimatedMinutes: 10, priority: 'low' }))
      await taskDao.deleteById('task_test_4')
      const result: Task = await taskDao.queryById('task_test_4')
      expect(result).assertNull()
    })

    it('scheduleDao_insertSchedule_returns_rowId', 0, async () => {
      const schedule = new Schedule({ id: 'sch_1', taskId: 'task_test_1', date: '2026-05-01', startTime: '09:00', endTime: '09:45', pomodoroCount: 1 })
      const rowId: number = await scheduleDao.insert(schedule)
      expect(rowId).assertGreater(0)
    })

    it('scheduleDao_queryByDate_returns_correct_schedules', 0, async () => {
      await scheduleDao.insert(new Schedule({ id: 'sch_2', taskId: 't1', date: '2026-05-01', startTime: '09:00', endTime: '09:45', pomodoroCount: 1 }))
      await scheduleDao.insert(new Schedule({ id: 'sch_3', taskId: 't2', date: '2026-05-01', startTime: '10:00', endTime: '11:00', pomodoroCount: 2 }))
      await scheduleDao.insert(new Schedule({ id: 'sch_4', taskId: 't3', date: '2026-05-02', startTime: '09:00', endTime: '09:30', pomodoroCount: 1 }))
      const todays: Schedule[] = await scheduleDao.queryByDate('2026-05-01')
      expect(todays.length).assertEqual(2)
    })

    it('scheduleDao_queryUnsynced_returns_only_unsynced', 0, async () => {
      await scheduleDao.insert(new Schedule({ id: 'sch_5', taskId: 't1', date: '2026-05-01', startTime: '09:00', endTime: '09:45', pomodoroCount: 1, isSyncedToCalendar: false }))
      await scheduleDao.insert(new Schedule({ id: 'sch_6', taskId: 't2', date: '2026-05-01', startTime: '10:00', endTime: '11:00', pomodoroCount: 2, isSyncedToCalendar: true }))
      const unsynced: Schedule[] = await scheduleDao.queryUnsynced()
      expect(unsynced.length).assertEqual(1)
      expect(unsynced[0].id).assertEqual('sch_5')
    })

    it('statsDao_getOrCreate_returns_stats', 0, async () => {
      const stats = await statsDao.getOrCreate('2026-05-01')
      expect(stats.date).assertEqual('2026-05-01')
      expect(stats.totalTasks).assertEqual(0)
    })

    it('statsDao_update_completion_rate_updates_correctly', 0, async () => {
      await statsDao.getOrCreate('2026-05-01')
      await statsDao.updateCompletion('2026-05-01', 5, 3)
      const updated = await statsDao.getOrCreate('2026-05-01')
      expect(updated.totalTasks).assertEqual(5)
      expect(updated.completedTasks).assertEqual(3)
      expect(updated.completionRate).assertEqual(0.6)
    })

    it('scheduleDao_deleteByDate_removes_schedules', 0, async () => {
      await scheduleDao.insert(new Schedule({ id: 'sch_7', taskId: 't1', date: '2026-05-01', startTime: '09:00', endTime: '09:45', pomodoroCount: 1 }))
      await scheduleDao.deleteByDate('2026-05-01')
      const remaining: Schedule[] = await scheduleDao.queryByDate('2026-05-01')
      expect(remaining.length).assertEqual(0)
    })

    it('scheduleDao_markSynced_updates_flag', 0, async () => {
      await scheduleDao.insert(new Schedule({ id: 'sch_8', taskId: 't1', date: '2026-05-01', startTime: '09:00', endTime: '09:45', pomodoroCount: 1, isSyncedToCalendar: false }))
      await scheduleDao.markSynced('sch_8', 'cal_event_001')
      const updated: Schedule = await scheduleDao.queryById('sch_8')
      expect(updated.isSyncedToCalendar).assertTrue()
      expect(updated.calendarEventId).assertEqual('cal_event_001')
    })
  })
}
