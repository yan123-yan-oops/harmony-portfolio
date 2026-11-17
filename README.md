# HarmonyOS 应用作品集

三个基于 HarmonyOS NEXT / ArkTS 的应用，覆盖 AI 问答、音频播放、日程规划三类场景。

> 截图待补：每个应用目录下的 `screenshots/` 放 3 张（首页 / 核心功能 / 结果页）。

| 应用 | 一句话 | 技术亮点 | 源码 |
| --- | --- | --- | --- |
| [MusicPlayer](apps/music-player/) | 在线音乐播放，歌单管理与多页面状态同步 | AVPlayer 单例状态机、Emitter 跨页广播、三种播放模式、组件化 | ✅ 本仓库 |
| [MindPlan](apps/mindplan/) | AI 日程规划，输入任务自动编排时间轴 | AGC 云函数、关系型数据库（RDB）、Tab 导航、ArkTS 严格类型 | ✅ 本仓库 |
| [面试通](apps/interview-quiz/) | AI 面试题库，分类浏览 / 搜索 / AI 问答 / 录音练习 | 四层网络封装、Token/401 全局跳转、大模型多轮对话 | ⚠️ 未公开（仓库暂空） |

## 技术栈

- 语言/框架：ArkTS、ArkUI 声明式、Stage 应用模型、Navigation 路由
- 状态管理：@State / @ObservedV2 / @Link / AppStorage
- 数据：关系型数据库（RDB）、AppStorage 持久化
- 网络：@ohos/axios 分层封装、拦截器、Token 鉴权
- 多媒体：AVPlayer、AVRecorder
- 云：AGC 云函数（Node.js + DeepSeek API）
- 工具：DevEco Studio、Git

## 共同的设计取舍

| 问题 | 做法 | 为什么 |
| --- | --- | --- |
| 网络请求重复代码多 | 四层封装（请求/拦截/业务/模型） | 接入新接口只写业务函数，Token 与错误处理统一 |
| 跨页面状态难同步 | AppStorage + Emitter 全局事件 | 避免 props 层层传递 |
| 列表卡顿 | List + LazyForEach 懒加载 + 组件复用 | 首屏只渲染可视区域 |
| 播放器状态散落 | 单例 + 状态机封装 | 对外只暴露 play/pause/seek，内部管资源释放 |

## 目录

```
├── apps/
│   ├── interview-quiz/   项目卡（源码待补）
│   ├── music-player/     项目卡（源码待补）
│   └── mindplan/         完整源码（ArkTS + 云函数）
├── docs/
│   └── architecture.md   分层架构与状态管理说明
└── README.md
```

## 怎么跑

- 安装 DevEco Studio（API 12+，本项目基于 HarmonyOS NEXT / API 22 验证）
- 打开对应应用目录，等待 ohpm 同步
- 连接真机或模拟器，Run

云函数相关（MindPlan）需要 AGC 侧部署，说明见 `apps/mindplan/README.md`。
