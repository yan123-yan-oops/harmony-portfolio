import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { BusinessError } from '@kit.BasicServicesKit'
import { DailyStats } from '../model/AIResponse'

const TABLE_NAME: string = 'daily_stats'

function fromRow(row: relationalStore.ResultSet): DailyStats {
  return new DailyStats({
    date: row.getString(row.getColumnIndex('date')),
    totalTasks: row.getLong(row.getColumnIndex('total_tasks')),
    completedTasks: row.getLong(row.getColumnIndex('completed_tasks')),
    totalPomodoros: row.getLong(row.getColumnIndex('total_pomodoros')),
    completionRate: row.getDouble(row.getColumnIndex('completion_rate'))
  })
}

export class StatsDao {
  private store: relationalStore.RdbStore

  constructor(store: relationalStore.RdbStore) {
    this.store = store
  }

  async getOrCreate(date: string): Promise<DailyStats> {
    try {
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME)
      predicates.equalTo('date', date)
      const resultSet: relationalStore.ResultSet = await this.store.query(predicates, [])
      if (resultSet.rowCount > 0) {
        resultSet.goToFirstRow()
        const stats: DailyStats = fromRow(resultSet)
        resultSet.close()
        return stats
      }
      resultSet.close()
      const values: ValuesBucket = {
        date: date,
        total_tasks: 0,
        completed_tasks: 0,
        total_pomodoros: 0,
        completion_rate: 0.0
      }
      await this.store.insert(TABLE_NAME, values)
      return new DailyStats({
        date: date,
        totalTasks: 0,
        completedTasks: 0,
        totalPomodoros: 0,
        completionRate: 0.0
      })
    } catch (error) {
      const err: BusinessError = error as BusinessError
      throw new Error(`StatsDao.getOrCreate failed: ${err.message}`)
    }
  }

  async updateCompletion(date: string, totalTasks: number, completedTasks: number): Promise<void> {
    try {
      const rate: number = totalTasks > 0 ? completedTasks / totalTasks : 0.0
      const values: ValuesBucket = {
        total_tasks: totalTasks,
        completed_tasks: completedTasks,
        completion_rate: rate
      }
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME)
      predicates.equalTo('date', date)
      await this.store.update(values, predicates)
    } catch (error) {
      const err: BusinessError = error as BusinessError
      throw new Error(`StatsDao.updateCompletion failed: ${err.message}`)
    }
  }
}
