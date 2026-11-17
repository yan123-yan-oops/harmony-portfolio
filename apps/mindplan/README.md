# MindPlan —— AI 日程规划

个人项目 · HarmonyOS NEXT / API 22 · ArkTS

> 源码仓库：https://github.com/yan123-yan-oops/MindPlan （main 分支）
> 状态：开发中（页面骨架 + 云函数 + 数据层已完成，AI 编排与番茄钟联动仍在完善）。

## 截图

| 任务输入 | 时间轴 | 专注计时 | 我的 |
| --- | --- | --- | --- |
| _待补_ | _待补_ | _待补_ | _待补_ |

## 一句话

输入一段任务描述，调用 AGC 云函数让大模型生成可执行的时间安排，落到本地时间轴与番茄钟。

## 架构

```
UI（Tabs）
├── InputPage      输入任务 → 调云函数 → 展示结果
├── TimelinePage   按时间轴展示安排
├── PomodoroPage   专注计时
└── ProfilePage    统计与设置
        │
services/AGCClient      云函数调用单例，统一错误处理
model/AIResponse        领域模型（Task / Schedule / AIResponse）
model/AGCResponse       云端契约（snake_case）+ mapApiResponse 映射
database/DatabaseHelper 建表 + DAO（Task / Schedule / Stats）
        │
AGC 云函数 generate-plan（Node.js：axios 调 DeepSeek + ajv 校验 + 重试）
```

## 技术要点

**1. 云函数调用与契约隔离**
云端返回 snake_case（`estimated_minutes`、`start_time`），客户端用 camelCase；
转换只在 `mapApiResponse()` 一处做，页面永远拿领域模型。

**2. ArkTS 严格类型下的写法**
- 无 `any`，所有对象字面量先定义 `interface`；
- 不用工具类型（`Partial/Pick`），需要可选字段就手写；
- `catch` 不能标类型：`const err = error as BusinessError` 后再包装抛出；
- 类字段必须在声明或构造中初始化。

**3. 本地持久化**
`relationalStore`（RDB），5 张表：`user_profile`、`tasks`、`schedules`、`pomodoro_records`、`daily_stats`；
主键 TEXT（UUID），布尔用 INTEGER 0/1，时间存 TEXT；SQL 只出现在 DAO 内部。

**4. 页面组织**
`Index.ets` 是 Tabs 壳，四个子页是 `@Component` 组件（无需登记路由）；
`main_pages.json` 只登记真正的 `@Entry` 页面。

## 目录

```
app/
├── entry/src/main/ets/
│   ├── pages/        Index / InputPage / TimelinePage / PomodoroPage / ProfilePage
│   ├── services/     AGCClient
│   ├── model/        AIResponse、AGCResponse
│   └── database/     DatabaseHelper、TaskDao、ScheduleDao、StatsDao
├── entry/src/main/module.json5
├── build-profile.json5
└── cloudfunctions/generate-plan/   index.js、prompt.js、schema.js
```

## 怎么跑

1. DevEco Studio 打开 `apps/mindplan/app`；
2. 首次会自动 ohpm 同步；
3. 云函数需要在 AGC 控制台部署 `generate-plan`，函数名必须一致；
4. `build-profile.json5` 未配置签名，产出的是未签名 HAP，真机安装需要先配签名。
