# 简历条目 → 仓库证据

面试官可以按这张表核对简历里的每一条。

## 面试通（AI 面试题库）

| 简历表述 | 证据位置 |
| --- | --- |
| 四层网络请求架构（请求/拦截/业务/模型） | [QuestionBank/master](https://github.com/yan123-yan-oops/QuestionBank) + 本仓库 `apps/interview-quiz/README.md` 第 1 节 |
| Token 自动注入、401 全局跳转 | 同上，拦截层职责 |
| AI 问答独立 axios 实例、多轮上下文 | 同上，第 2 节 |
| 录音生命周期封装（AVRecorder/AVPlayer） | 同上，第 4 节 |
| 列表分页与懒加载 | 同上，复盘"没做好"部分 |

> 源码在另一台设备，未随仓库公开；面试可结合录屏演示。

## MusicPlayer（鸿蒙在线音乐播放器）

| 简历表述 | 证据位置 |
| --- | --- |
| AVPlayer 单例与状态机 | `apps/music-player/src/entry/src/main/ets/utils/MusicPlayUtil.ets` |
| 防止重复注册监听 | 同上，`isListenRegistered` |
| Emitter 跨页面状态同步 | `constant/EventConstants.ets`（eventId 1001）+ `MusicPlayUtil.emitState()` |
| 三种播放模式 | `MusicPlayUtil.ets`，`playMode: 'auto' \| 'repeat' \| 'random'` |
| 组件化多页面 | `pages/` 8 个页面 + `components/` 7 个组件 |

## MindPlan（AI 日程规划）

| 简历表述 | 证据位置 |
| --- | --- |
| AGC 云函数调用 | `apps/mindplan/app/entry/src/main/ets/services/AGCClient.ets` |
| 云端字段映射（snake_case → camelCase） | `model/AGCResponse.ets` 的 `mapApiResponse` |
| 关系型数据库（RDB） | `database/DatabaseHelper.ets`、`TaskDao` / `ScheduleDao` / `StatsDao` |
| ArkTS 严格类型写法 | 全部 `.ets`：无 `any`、字面量先定义 interface、`catch` 不标类型 |

## 嵌入式方向（备用）

| 简历表述 | 证据位置 |
| --- | --- |
| NMEA 解析器 32/32、0 丢包 | `embedded-portfolio` 仓库 `nmea-parser/` |
| 内存池 768B/568B/26% | `embedded-portfolio` 仓库 `memory-pool/` |
| 抗干扰 +22.79 dB | `embedded-portfolio` 仓库 `anti-jamming/` |
