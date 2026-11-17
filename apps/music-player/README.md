# MusicPlayer —— 鸿蒙在线音乐播放器

个人项目 · HarmonyOS API 16 · ArkTS

> 源码仓库：https://github.com/yan123-yan-oops/MusicPlayer （main 分支）

## 截图

| 首页 | 播放页 | 歌单 |
| --- | --- | --- |
| _待补_ | _待补_ | _待补_ |

## 一句话

在线音乐播放器：推荐、歌单、播放、动态、我的五个 Tab，播放状态跨页面实时同步。

## 技术栈

ArkTS · ArkUI · @kit.MediaKit（AVPlayer）· Emitter · Navigation · 网络请求封装

## 页面与组件

| 层级 | 文件 |
| --- | --- |
| 页面（8） | `Start`、`Index`、`Find`、`Recommend`、`Moment`、`Mine`、`Play`、`SongList` |
| 组件（7） | `FindComponent`、`RecommendComponent`、`MomentComponent`、`MineComponent`、`PlayComponentShare`、`PlayComponentSongList`、`SongListComponent` |
| 工具 | `MusicPlayUtil`（播放器封装）、`SongListUtil`（歌单处理） |
| 常量/模型 | `EventConstants`、`MusicConstants`、`models/myMusicModel` |

## 技术亮点

**1. AVPlayer 封装成静态单例**
问题：AVPlayer 实例散落各处，容易重复创建、重复注册监听。
做法：`MusicPlayer` 用一个 `private static instance` 持有播放器，`getPlayer()` 惰性创建、复用；
`registerStateListen()` 用 `isListenRegistered` 防止重复注册。
结果：全应用只有一个播放器实例、一份监听。

**2. 用状态机驱动播放流程**
`stateChange` 回调里按状态推进：`initialized → prepare()`、`prepared → play()`、`playing/paused → 更新 UI`；
`timeUpdate` 回调同步进度。业务层不直接碰底层 API。

**3. Emitter 跨页面同步**
定义 `PlayStateEvent`（eventId 1001，IMMEDIATE 优先级），播放状态变化时 `emit`，
各页面订阅刷新。避免 props 层层传递。

**4. 三种播放模式**
`playMode: 'auto' | 'repeat' | 'random'` 用联合类型约束，切歌逻辑按模式分支，随机模式避免连续重复。

**5. 组件化拆分**
播放条拆成 `PlayComponentShare`（分享）与 `PlayComponentSongList`（歌单内播放）两种形态，
页面只负责组装。

## 目录

```
src/
├── entry/src/main/ets/
│   ├── pages/       8 个页面
│   ├── components/  7 个业务组件
│   ├── utils/       MusicPlayUtil、SongListUtil
│   ├── constant/    EventConstants、MusicConstants
│   └── models/      歌曲与歌单类型
├── entry/src/main/resources/
├── build-profile.json5
└── oh-package.json5
```

## 怎么跑

1. DevEco Studio 打开 `src/`；
2. ohpm 同步依赖；
3. 配置签名后可上真机（`build-profile.json5` 默认未配置签名）。
