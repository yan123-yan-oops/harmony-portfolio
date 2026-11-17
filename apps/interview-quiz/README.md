# 面试通 —— AI 面试题库（源码未公开）

个人项目 · 2025.09–2025.10 · HarmonyOS NEXT / ArkTS

> 状态：GitHub 上的 `QuestionBank` 仓库目前只有一个 LICENSE（初始提交），源码未上传。
> 需要时可以提供屏幕录像与代码讲解，或从旧机器找回源码后补进本目录。

## 截图

| 题库首页 | AI 问答 | 录音练习 |
| --- | --- | --- |
| _待补_ | _待补_ | _待补_ |

## 一句话

按岗位分类浏览面试题，支持搜索、收藏，内置 AI 答题助手与录音练习。

## 技术栈

ArkTS · ArkUI · HarmonyOS NEXT · @ohos/axios · AppStorage · NavPathStack · AVRecorder · AVPlayer · 大模型 API

## 技术要点

**网络层四层封装**
请求层（axios 实例）/ 拦截层（Token 注入、统一剥壳、401 跳登录）/ 业务层（API 函数）/ 模型层（类型）。
新增接口只写一个业务函数，鉴权与错误处理只改一处。

**登录态持久化**
Token 存 AppStorage，统一登录状态工具类，启动时恢复；跨页面无需各自判断。

**AI 智能问答**
AI 请求单独建 axios 实例（60s 超时），与业务网络隔离，避免拦截器互相干扰；
用 OpenAI 兼容格式拼多轮上下文。

**录音练习**
封装 AVRecord 工具类统一管理录音生命周期（启动/录制/保存/回放），回调驱动 UI，页面退出自动释放。

**列表性能**
List + LazyForEach 分页加载与组件复用，配合分类筛选与权重排序。

## 架构（按代码分层）

```
pages/        页面与组件
viewmodel/    状态与业务编排
services/     网络、AI、录音
model/        类型与映射
utils/        登录态、格式化
```
