# Boat Player（个人使用 / 非商业）

Boat Player 是一款基于 Flutter 开发的 Bilibili 音频播放器，主打海洋主题的沉浸式 UI 与轻量播放体验。当前实现以指定 UP 主投稿为核心数据源，包含音频播放、后台播放、离线下载、播放队列、翻唱清单等功能 (ง •̀_•́)ง

本项目为个人兴趣开发，仅供学习与个人使用，不以商业目的使用。

---

## ✨ 功能特性

- 登录与 Cookie 自动维护（内置 WebView 登录，持久化 `SESSDATA` 等关键 Cookie）
- 音频播放（播放/暂停、上一首/下一首、进度拖拽、全局底部播放栏）
- 后台播放（音频会话配置）
- 播放队列（底部弹窗展示与快速切歌）
- 离线下载（下载到本地、播放前优先命中本地缓存、下载进度反馈）
- 翻唱清单（指定 UP 主聚合、离线缓存、透明 UI 融入海洋背景）
- 海洋主题 UI（深蓝渐变、强调色、欢迎页摇晃小船 + 波浪动效、Tab 图标摇晃）

---

## 🧭 使用说明（简要）

1. 首次启动：无 Cookie 时进入欢迎/登录流程
2. 登录：在内置 WebView 完成 B 站登录后自动读取 `bilibili.com` Cookie
3. 播放：在投稿列表点击即可播放；底部播放栏可进入播放页/打开队列
4. 下载：播放页可下载当前音频；下载列表可管理与直接播放

---

## 🧱 技术栈

- Flutter / Dart（推荐开发环境：Flutter 3.38.3、Dart 3.10.1）
- 状态管理：Riverpod（注解生成）
- 网络：Dio
- 播放：just_audio + audio_session（含 audio_service）
- 登录：flutter_inappwebview
- 持久化：shared_preferences + path_provider
- 全局弹窗：flutter_smart_dialog

---

## 📁 目录结构（简化）

```text
lib/
├── api/             # Bilibili API 客户端及 Wbi 签名
├── components/      # 可复用组件 (PlayerBar, AnimatedBoatIcon, PlaylistBottomSheet)
│   └── backgrounds/ # 海洋主题背景
├── models/          # 数据模型
├── pages/           # 页面 (Welcome/Home/Login/Player/Downloads/...)
├── providers/       # 状态管理
├── utils/           # 工具类 (CookieStore, DownloadManager)
└── main.dart        # 应用入口
```

---

## 🔐 隐私政策（重要）

Boat Player 为本地播放器应用，不提供账号注册体系，不搭建自有服务端；应用的大部分数据仅存储在你的设备本地。

### 1) 我们会处理哪些数据

- Bilibili 登录 Cookie：用于访问 B 站接口与获取音频播放资源；由应用在内置 WebView 登录后读取并持久化在本地。
- 播放/下载相关本地数据：包含下载文件、下载元信息（如标题、封面链接、下载进度等）以及少量缓存；保存在应用沙盒（如 `Documents/downloads` 与 `SharedPreferences`）。
- 网络请求信息：应用会向 Bilibili 相关域名发起请求（例如 `bilibili.com`、`api.bilibili.com` 及其 CDN）；请求会携带必要的 `User-Agent`、`Referer`、`Cookie` 等以满足防盗链与鉴权要求。

提示：Cookie 属于敏感信息，请勿在截图、日志或分享文件中泄露；若怀疑泄露，请及时退出登录/更换登录态。

### 2) 我们不会做什么

- 不会收集或上传你的个人信息到作者服务器（本项目无自建后端）。
- 不会接入第三方广告、统计分析 SDK（以仓库当前依赖为准）。
- 不会在日志中主动上报你的 Cookie 等敏感信息。

### 3) 第三方服务与链接

- 你在应用内登录与播放时，会与 Bilibili 及其 CDN 发生网络交互；其对数据的处理规则以 Bilibili 的隐私政策与相关条款为准。
- 应用可能包含跳转到外部网页的链接（如打开 Bilibili 页面）；外部站点的行为不受本项目控制。

### 4) 权限说明

- 存储/媒体相关权限：用于保存离线音频文件（不同平台权限机制不同，按系统提示授予即可）。
- 网络权限：用于访问 Bilibili 相关接口与资源。

### 5) 你可以如何删除数据

- 在系统设置中清除应用数据/卸载应用，即可删除本地 Cookie、缓存与离线下载。

### 6) 政策变更

- 若后续新增可能影响隐私的数据处理行为，会在 README 中更新说明。

---

## ⚖️ 法律声明与使用限制

- 本项目为个人兴趣开发，仅供学习与个人使用，不以商业目的使用（包括但不限于销售、收费服务、广告变现、商业集成等）。
- 本项目与 Bilibili 无任何官方关联或背书；涉及的名称、商标与内容版权归其权利人所有。
- 数据来源于用户调用的公开接口与个人账户授权；使用时请遵守 Bilibili 的《用户协议》《社区规则》及相关法律法规。
- 禁止绕过登录/会员权限、DRM/加密措施，或进行批量爬取、恶意抓取等违反平台规则的行为。
- 本项目不对接口稳定性、内容可用性、账号风控等结果做任何保证；由此产生的风险与责任由使用者自行承担。
- 如涉及权利或合规问题，请通过仓库 Issue 联系，便于及时处理。

---

## 🙏 鸣谢

- 参考项目：[wood3n/biu](https://github.com/wood3n/biu)
- Bilibili API 资料整理：[SocialSisterYi/bilibili-API-collect](https://github.com/SocialSisterYi/bilibili-API-collect)
