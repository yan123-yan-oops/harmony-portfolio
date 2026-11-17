import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { BusinessError } from '@kit.BasicServicesKit'
import { Task } from '../model/AIResponse'

const TABLE_NAME: string = 'tasks'

function toValues(task: Task): ValuesBucket {
  return {
    id: task.id,
    name: task.name,
    description: task.description,
    estimated_minutes: task.estimatedMinutes,
    priority: task.priority,
    deadline: task.deadline,
    category: task.category,
    is_completed: task.isCompleted ? 1 : 0,
    created_at: task.createdAt
  }
}

function fromRow(row: relationalStore.ResultSet): Task {
  return new Task({
    id: row.getString(row.getColumnIndex('id')),
    name: row.getString(row.getColumnIndex('name')),
    description: row.getString(row.getColumnIndex('description')),
    estimatedMinutes: row.getLong(row.getColumnIndex('estimated_minutes')),
    priority: row.getString(row.getColumnIndex('priority')) as 'high' | 'medium' | 'low',
    deadline: row.getString(row.getColumnIndex('deadline')),
    category: row.getString(row.getColumnIndex('category')),
    isCompleted: row.getLong(row.getColumnIndex('is_completed')) === 1,
    createdAt: row.getString(row.getColumnIndex('created_at'))
  })
}

export class TaskDao {
  private store: relationalStore.RdbStore

  constructor(store: relationalStore.RdbStore) {
    this.store = store
  }

  async insert(task: Task): Promise<number> {
    try {
      const values: ValuesBucket = toValues(task)
      const rowId: number = await this.store.insert(TABLE_NAME, values)
      return rowId
    } catch (error) {
      const err: BusinessError = error as BusinessError
      throw new Error(`TaskDao.insert failed: ${err.message}`)
    }
  }

  async queryById(id: string): Promise<Task> {
    try {
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME)
      predicates.equalTo('id', id)
      const resultSet: relationalStore.ResultSet = await this.store.query(predicates, [])
      if (resultSet.rowCount === 0) {
        resultSet.close()
        return null
      }
      resultSet.goToFirstRow()
      const task: Task = fromRow(resultSet)
      resultSet.close()
      return task
    } catch (error) {
      const err: BusinessError = error as BusinessError
      throw new Error(`TaskDao.queryById failed: ${err.message}`)
    }
  }

  async queryAll(): Promise<Task[]> {
    try {
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME)
      predicates.orderByDesc('created_at')
      const resultSet: relationalStore.ResultSet = await this.store.query(predicates, [])
      const tasks: Task[] = []
      while (resultSet.goToNextRow()) {
        tasks.push(fromRow(resultSet))
      }
      resultSet.close()
      return tasks
    } catch (error) {
      const err: BusinessError = error as BusinessError
      throw new Error(`TaskDao.queryAll failed: ${err.message}`)
    }
  }

  async queryByDate(date: string): Promise<Task[]> {
    try {
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME)
      predicates.equalTo('date', date)
      predicates.orderByDesc('created_at')
      const resultSet: relationalStore.ResultSet = await this.store.query(predicates, [])
      const tasks: Task[] = []
      while (resultSet.goToNextRow()) {
        tasks.push(fromRow(resultSet))
      }
      resultSet.close()
      return tasks
    } catch (error) {
      const err: BusinessError = error as BusinessError
      throw new Error(`TaskDao.queryByDate failed: ${err.message}`)
    }
  }

  async updateCompleted(id: string, isCompleted: boolean): Promise<void> {
    try {
      const values: ValuesBucket = {
        is_completed: isCompleted ? 1 : 0
      }
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME)
      predicates.equalTo('id', id)
      await this.store.update(values, predicates)
    } catch (error) {
      const err: BusinessError = error as BusinessError
      throw new Error(`TaskDao.updateCompleted failed: ${err.message}`)
    }
  }

  async deleteById(id: string): Promise<void> {
    try {
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME)
      predicates.equalTo('id', id)
      await this.store.delete(predicates)
    } catch (error) {
      const err: BusinessError = error as BusinessError
      throw new Error(`TaskDao.deleteById failed: ${err.message}`)
    }
  }
}
