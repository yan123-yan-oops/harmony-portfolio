import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { BusinessError } from '@kit.BasicServicesKit'
import { Schedule } from '../model/AIResponse'

const TABLE_NAME: string = 'schedules'

function toValues(schedule: Schedule): ValuesBucket {
  return {
    id: schedule.id,
    task_id: schedule.taskId,
    date: schedule.date,
    start_time: schedule.startTime,
    end_time: schedule.endTime,
    pomodoro_count: schedule.pomodoroCount,
    is_synced_to_calendar: schedule.isSyncedToCalendar ? 1 : 0,
    calendar_event_id: schedule.calendarEventId
  }
}

function fromRow(row: relationalStore.ResultSet): Schedule {
  return new Schedule({
    id: row.getString(row.getColumnIndex('id')),
    taskId: row.getString(row.getColumnIndex('task_id')),
    date: row.getString(row.getColumnIndex('date')),
    startTime: row.getString(row.getColumnIndex('start_time')),
    endTime: row.getString(row.getColumnIndex('end_time')),
    pomodoroCount: row.getLong(row.getColumnIndex('pomodoro_count')),
    isSyncedToCalendar: row.getLong(row.getColumnIndex('is_synced_to_calendar')) === 1,
    calendarEventId: row.getString(row.getColumnIndex('calendar_event_id'))
  })
}

export class ScheduleDao {
  private store: relationalStore.RdbStore

  constructor(store: relationalStore.RdbStore) {
    this.store = store
  }

  async insert(schedule: Schedule): Promise<number> {
    try {
      const values: ValuesBucket = toValues(schedule)
      const rowId: number = await this.store.insert(TABLE_NAME, values)
      return rowId
    } catch (error) {
      const err: BusinessError = error as BusinessError
      throw new Error(`ScheduleDao.insert failed: ${err.message}`)
    }
  }

  async queryById(id: string): Promise<Schedule> {
    try {
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME)
      predicates.equalTo('id', id)
      const resultSet: relationalStore.ResultSet = await this.store.query(predicates, [])
      if (resultSet.rowCount === 0) {
        resultSet.close()
        return null
      }
      resultSet.goToFirstRow()
      const schedule: Schedule = fromRow(resultSet)
      resultSet.close()
      return schedule
    } catch (error) {
      const err: BusinessError = error as BusinessError
      throw new Error(`ScheduleDao.queryById failed: ${err.message}`)
    }
  }

  async queryByDate(date: string): Promise<Schedule[]> {
    try {
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME)
      predicates.equalTo('date', date)
      predicates.orderByAsc('start_time')
      const resultSet: relationalStore.ResultSet = await this.store.query(predicates, [])
      const schedules: Schedule[] = []
      while (resultSet.goToNextRow()) {
        schedules.push(fromRow(resultSet))
      }
      resultSet.close()
      return schedules
    } catch (error) {
      const err: BusinessError = error as BusinessError
      throw new Error(`ScheduleDao.queryByDate failed: ${err.message}`)
    }
  }

  async queryUnsynced(): Promise<Schedule[]> {
    try {
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME)
      predicates.equalTo('is_synced_to_calendar', 0)
      const resultSet: relationalStore.ResultSet = await this.store.query(predicates, [])
      const schedules: Schedule[] = []
      while (resultSet.goToNextRow()) {
        schedules.push(fromRow(resultSet))
      }
      resultSet.close()
      return schedules
    } catch (error) {
      const err: BusinessError = error as BusinessError
      throw new Error(`ScheduleDao.queryUnsynced failed: ${err.message}`)
    }
  }

  async markSynced(id: string, calendarEventId: string): Promise<void> {
    try {
      const values: ValuesBucket = {
        is_synced_to_calendar: 1,
        calendar_event_id: calendarEventId
      }
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME)
      predicates.equalTo('id', id)
      await this.store.update(values, predicates)
    } catch (error) {
      const err: BusinessError = error as BusinessError
      throw new Error(`ScheduleDao.markSynced failed: ${err.message}`)
    }
  }

  async deleteByDate(date: string): Promise<void> {
    try {
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME)
      predicates.equalTo('date', date)
      await this.store.delete(predicates)
    } catch (error) {
      const err: BusinessError = error as BusinessError
      throw new Error(`ScheduleDao.deleteByDate failed: ${err.message}`)
    }
  }

  async deleteById(id: string): Promise<void> {
    try {
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME)
      predicates.equalTo('id', id)
      await this.store.delete(predicates)
    } catch (error) {
      const err: BusinessError = error as BusinessError
      throw new Error(`ScheduleDao.deleteById failed: ${err.message}`)
    }
  }
}
