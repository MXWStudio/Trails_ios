# Trails iOS 应用

一个使用 SwiftUI 开发的现代化 iOS 运动追踪应用。

## 📱 项目信息

- **开发工具**: Xcode 16.3
- **语言**: Swift 5.0 + SwiftUI
- **最低支持**: iOS 18.4
- **创建者**: 孟祥伟
- **创建时间**: 2025年8月20日

## 🏗️ 项目结构

```
Trails/
├── TrailsApp.swift                    # 应用入口
├── ViewModels/                        # 视图模型层
│   └── AuthenticationViewModel.swift  # 认证管理
├── Views/                            # 视图层
│   ├── Authentication/               # 认证相关视图
│   │   └── LoginView.swift          # 登录页面
│   ├── Main/                        # 主要视图
│   │   └── BottomTabView.swift      # 底部导航
│   └── Tabs/                        # 标签页视图
│       ├── ExploreView.swift        # 探索页面
│       ├── CommunityView.swift      # 社区页面
│       ├── FavoritesView.swift      # 收藏页面
│       ├── ActivityView.swift       # 活动页面
│       └── ProfileView.swift        # 个人页面
├── Models/                          # 数据模型
│   └── TrailModels.swift           # 核心模型
├── Managers/                        # 数据管理器
│   └── MotionManager.swift         # 运动数据管理
└── Assets.xcassets/                 # 资源文件
```

## ✨ 主要功能

### 🔐 用户认证
- **Apple 登录**: 使用 Sign in with Apple
- **状态管理**: 自动保存登录状态
- **模拟器支持**: 开发调试模式

### 🏃‍♂️ 运动追踪
- **实时监控**: 时长、距离、卡路里
- **数据管理**: 开始/停止/重置功能
- **模拟数据**: 便于开发测试

### 📱 核心页面

| 页面 | 功能 | 主题色 |
|------|------|--------|
| 探索 | 发现路线和目的地 | 蓝色 |
| 社区 | 用户交流分享 | 绿色 |
| 收藏 | 保存喜欢的内容 | 黄色 |
| 活动 | 运动数据追踪 | 橙色 |
| 个人 | 用户信息管理 | 蓝色 |

## 🚀 运行项目

1. 打开 `Trails.xcodeproj`
2. 选择目标设备
3. 按 `Cmd + R` 运行

### 登录测试

**真机**: 使用真实 Apple ID 登录  
**模拟器**: 点击"跳过登录"按钮

## 📂 跳转路径

### 应用流程
```
TrailsApp.swift 
    ↓
LoginView.swift (未登录)
    ↓
BottomTabView.swift (已登录)
    ↓
[ExploreView | CommunityView | FavoritesView | ActivityView | ProfileView]
```

### 文件关联
- `AuthenticationViewModel.swift` ← 管理登录状态
- `MotionManager.swift` ← 管理运动数据
- `TrailModels.swift` ← 定义数据结构

## 🧪 测试

- **单元测试**: `Cmd + U`
- **UI测试**: 选择 TrailsUITests 方案

---

*简洁、现代、功能完整的 iOS 应用基础架构*