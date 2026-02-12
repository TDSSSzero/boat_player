# Boat Player 设计文档

## 1. 项目概述
Boat Player 是一款基于 Flutter 开发的 Bilibili 音频播放器，专注于提供沉浸式的海洋主题音乐体验。当前实现以指定 UP 主的投稿为核心数据源，提供音频播放、后台播放、离线缓存、播放队列与翻唱清单等功能。

## 2. 核心功能

### 2.1 用户系统
- **Cookie 管理**：
  - 启动时从本地读取 Cookie 字符串并缓存到内存。
  - 欢迎页仅基于 Cookie 是否存在决定是否进入主页。
  - 通过内置 WebView (`InAppWebView`) 拦截 B 站登录流程，自动获取并持久化 `SESSDATA` 等关键 Cookie。
  - 支持移动端 User-Agent 伪装，确保登录页面适配和风控通过率。

- **登录流程**：
  - `WelcomePage`：检查本地 Cookie，存在则进入主页，否则引导登录。
  - `LoginPage`：使用 `flutter_inappwebview` 打开登录页并读取 `bilibili.com` 的 Cookie。

### 2.2 音乐播放
- **音频流获取**：
  - 通过 Bilibili API 获取音频信息：
    - `/x/web-interface/view` 获取视频信息与 CID。
    - `/x/player/wbi/playurl` 获取 DASH 音频流。
  - 支持 Wbi 签名算法 (`WbiSigner`) 应对 B 站 API 鉴权。
  - 自动注入 `Referer`、`User-Agent`、`Cookie` 防止防盗链拦截。
- **播放控制**：
  - 支持播放/暂停、上一首/下一首、进度拖拽。
  - 全局播放栏 (`PlayerBar`) 常驻底部，支持打开播放队列与进入播放页。
  - 后台播放支持 (通过 `audio_session` 配置)。
  - 播放页 (`MusicPlayerPage`) 提供大封面展示、播放控制、进度拖拽与下载入口。

- **播放队列**：
  - 通过底部弹窗 (`PlaylistBottomSheet`) 展示当前播放列表与快速切歌。

### 2.3 离线下载
- **下载管理**：
  - 支持将当前播放的音频下载到本地 (`DownloadManager`)。
  - 自动检测本地缓存：播放前优先查找本地文件，存在则直接播放本地资源，节省流量。
  - 下载进度实时反馈（圆环进度条）。
  - 下载文件保存在应用 Documents/downloads 目录；下载元信息持久化在 `SharedPreferences`。
  - `DownloadsPage` 支持查看下载列表、下拉刷新、滑动删除与直接播放。

### 2.4 翻唱清单 (Cover List)
- **特定 UP 主聚合**：
  - 自动拉取特定 MID (如 `208976996`) 的投稿。
  - 当前实现以标题列表形式缓存到本地 (`SharedPreferences`)，支持离线查看。
- **透明 UI**：
  - 列表页采用透明背景，无缝融入主页的海洋渐变背景。

### 2.5 主页导航
- **三栏导航**：
  - `HomePage` 顶部 `TabBar`：投稿列表 / 下载 / 更多。
  - 投稿列表支持手动刷新与点击播放。

## 3. UI/UX 设计

### 3.1 视觉主题：海洋 (Marine Theme)
- **配色方案**：
  - 主色调：深蓝渐变 (`Colors.blue[900]` -> `Colors.blue[400]`)。
  - 强调色：活力橙 (`Colors.orangeAccent`)，用于按钮、选中态图标。
  - 文字颜色：白色 (`Colors.white`)，确保深色背景下的可读性。

### 3.2 动态交互
- **欢迎页 (`WelcomePage`)**：
  - 摇晃的小船动画。
  - 底部双层波浪动画 (`WaveClipper`)。
- **主页导航 (`HomePage`)**：
  - 顶部 Tab 栏 (`AnimatedBoatIcon`)：选中 Tab 时图标会有节奏地摇晃，模拟海上漂浮感。
  - 沉浸式布局：内容区域延伸至 AppBar 底部，背景全屏覆盖。

### 3.3 调试能力
- `Config.debug = true` 时：
  - 欢迎页提供快捷入口进入主页。
  - 主页提供 Debug 悬浮按钮，可打开调试弹窗。

## 4. 技术架构

### 4.1 目录结构
```
lib/
├── api/            # Bilibili API 客户端及 Wbi 签名
├── components/     # 可复用组件 (PlayerBar, AnimatedBoatIcon, PlaylistBottomSheet)
│   └── backgrounds/ # 海洋主题背景
├── models/         # 数据模型 (VideoItem, PlayUrlResponse)
├── pages/          # 页面层 (WelcomePage, HomePage, LoginPage, MusicPlayerPage)
│   ├── downloads/   # 下载列表页
│   ├── home/        # 主页与翻唱清单
│   ├── more/        # 更多页
│   └── player/      # 播放页
├── providers/      # 状态管理 (PlayerProvider 等)
├── utils/          # 工具类 (CookieStore, DownloadManager)
└── main.dart       # 应用入口
```

### 4.2 关键依赖
- `riverpod`: 状态管理。
- `dio`: 网络请求。
- `just_audio`: 音频播放。
- `flutter_inappwebview`: 登录拦截。
- `shared_preferences`: 本地持久化。
- `path_provider`: 文件路径管理。
- `flutter_smart_dialog`: 调试弹窗等全局弹窗。

## 5. 未来规划 (Roadmap)

### Phase 1: 基础体验优化 (进行中)
- [x] 登录与 Cookie 自动维护。
- [x] 音频缓存与离线播放。
- [x] 海洋主题 UI 重构。
- [ ] 播放列表管理 (创建、删除、排序)。

### Phase 2: 社区与互动
- **评论查看**：在播放页查看视频评论。：https://github.com/SocialSisterYi/bilibili-API-collect/blob/master/docs/comment/list.md
- **分享功能**：生成带封面的音乐分享卡片。
点赞投币收藏：https://github.com/SocialSisterYi/bilibili-API-collect/blob/master/docs/video/action.md
在线观看人数：https://github.com/SocialSisterYi/bilibili-API-collect/blob/master/docs/video/online.md
