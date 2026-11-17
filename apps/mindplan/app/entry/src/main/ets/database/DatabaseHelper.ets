import { relationalStore } from '@kit.ArkData'
import { BusinessError } from '@kit.BasicServicesKit'

const DB_NAME: string = 'mindplan.db'

const SQL_CREATE_TABLES: string = `
  CREATE TABLE IF NOT EXISTS user_profile (
    union_id TEXT PRIMARY KEY,
    nickname TEXT NOT NULL DEFAULT '',
    phone TEXT NOT NULL DEFAULT '',
    jwt_token TEXT NOT NULL DEFAULT '',
    time_preference TEXT NOT NULL DEFAULT '09:00-18:00',
    pomodoro_duration INTEGER NOT NULL DEFAULT 25,
    created_at TEXT NOT NULL DEFAULT ''
  );

  CREATE TABLE IF NOT EXISTS tasks (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    estimated_minutes INTEGER NOT NULL DEFAULT 0,
    priority TEXT NOT NULL DEFAULT 'medium',
    deadline TEXT NOT NULL DEFAULT '',
    category TEXT NOT NULL DEFAULT 'work',
    is_completed INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL DEFAULT ''
  );

  CREATE TABLE IF NOT EXISTS schedules (
    id TEXT PRIMARY KEY,
    task_id TEXT NOT NULL,
    date TEXT NOT NULL DEFAULT '',
    start_time TEXT NOT NULL DEFAULT '',
    end_time TEXT NOT NULL DEFAULT '',
    pomodoro_count INTEGER NOT NULL DEFAULT 1,
    is_synced_to_calendar INTEGER NOT NULL DEFAULT 0,
    calendar_event_id TEXT NOT NULL DEFAULT ''
  );

  CREATE TABLE IF NOT EXISTS pomodoro_records (
    id TEXT PRIMARY KEY,
    task_id TEXT NOT NULL,
    start_time TEXT NOT NULL DEFAULT '',
    duration INTEGER NOT NULL DEFAULT 25,
    type TEXT NOT NULL DEFAULT 'focus',
    status TEXT NOT NULL DEFAULT 'running'
  );

  CREATE TABLE IF NOT EXISTS daily_stats (
    date TEXT PRIMARY KEY,
    total_tasks INTEGER NOT NULL DEFAULT 0,
    completed_tasks INTEGER NOT NULL DEFAULT 0,
    total_pomodoros INTEGER NOT NULL DEFAULT 0,
    completion_rate REAL NOT NULL DEFAULT 0.0
  );
`

export class DatabaseHelper {
  private store: relationalStore.RdbStore

  async init(context: Context): Promise<void> {
    const config: relationalStore.StoreConfig = {
      name: DB_NAME,
      securityLevel: relationalStore.SecurityLevel.S1
    }
    try {
      this.store = await relationalStore.getRdbStore(context, config)
      await this.store.executeSql(SQL_CREATE_TABLES)
    } catch (error) {
      const err: BusinessError = error as BusinessError
      console.error(`DatabaseHelper.init failed: ${err.message}`)
      throw new Error(err.message)
    }
  }

  getStore(): relationalStore.RdbStore {
    return this.store
  }

  async clearAll(): Promise<void> {
    await this.store.executeSql('DELETE FROM tasks')
    await this.store.executeSql('DELETE FROM schedules')
    await this.store.executeSql('DELETE FROM pomodoro_records')
    await this.store.executeSql('DELETE FROM daily_stats')
  }

  async deleteDb(): Promise<void> {
    try {
      await relationalStore.deleteRdbStore(getContext(), DB_NAME)
    } catch (error) {
      const err: BusinessError = error as BusinessError
      console.error(`DatabaseHelper.deleteDb failed: ${err.message}`)
    }
  }
}
