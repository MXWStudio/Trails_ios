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
├── TrailsApp.swift                     # 应用入口
├── ViewModels/                         # 视图模型层
│   ├── AuthenticationViewModel.swift   # 认证管理
│   └── UserDataViewModel.swift        # 用户数据管理
├── Views/                             # 视图层
│   ├── Authentication/                # 认证相关视图
│   │   └── LoginView.swift           # 登录页面
│   ├── Main/                         # 主要视图
│   │   └── BottomTabView.swift       # 底部导航
│   ├── Tabs/                         # 标签页视图
│   │   ├── TodayGoalView.swift       # 今日目标页面
│   │   ├── CommunityView.swift       # 社区页面
│   │   ├── FavoritesView.swift       # 成就页面
│   │   ├── ActivityView.swift        # 运动追踪页面
│   │   ├── ProfileView.swift         # 个人页面
│   │   └── DailyQuestsView.swift     # 每日任务视图
│   └── Subviews/                     # 子视图组件
│       ├── ActivityDataPanel.swift   # 运动数据面板
│       ├── ActivitySummaryView.swift # 运动总结视图
│       ├── EditProfileView.swift     # 编辑资料视图
│       └── StatCard.swift            # 统计卡片组件
├── Models/                           # 数据模型
│   ├── TrailModels.swift            # 核心模型
│   ├── UserData.swift               # 用户数据模型
│   ├── DailyGoal.swift              # 每日目标模型
│   ├── DailyQuest.swift             # 每日任务模型
│   └── Achievement.swift            # 成就模型
├── Managers/                         # 数据管理器
│   └── MotionManager.swift          # 运动数据管理
├── Helpers/                          # 帮助类和样式
│   └── PrimaryButtonStyle.swift     # 主要按钮样式
└── Assets.xcassets/                  # 资源文件
```

## ✨ 主要功能

### 🔐 用户认证
- **Apple 登录**: 使用 Sign in with Apple
- **状态管理**: 自动保存登录状态
- **模拟器支持**: 开发调试模式

### 🏃‍♂️ 运动追踪
- **实时监控**: 时长、距离、卡路里
- **数据管理**: 开始/停止/重置功能
- **地图集成**: 全屏地图背景显示
- **模拟数据**: 便于开发测试

### 🎮 游戏化系统
- **经验值系统**: 完成运动获得XP奖励
- **段位系统**: 红宝石等段位展示
- **每日任务**: 动态任务系统和金币奖励
- **成就系统**: 解锁各类运动成就

### 👤 个人中心
- **用户资料**: 个人信息管理和编辑
- **运动统计**: 打卡天数、总经验等数据
- **社交功能**: 关注者和关注数显示
- **个性化设置**: 身高体重等个人数据

### 📱 核心页面

| 页面 | 功能 | 主要特色 |
|------|------|---------|
| 今日目标 | 设定和开始运动目标 | 游戏化目标设定，强度选择 |
| 社区 | 用户交流分享 | 社交互动，分享运动成果 |
| 成就 | 查看解锁的成就徽章 | 成就系统，激励持续运动 |
| 运动追踪 | 实时监控运动数据 | 地图背景，实时数据显示 |
| 个人 | 用户信息和统计 | 经验值系统，段位展示 |

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
[TodayGoalView | CommunityView | FavoritesView | ProfileView]
    ↓
ActivityView (从TodayGoalView启动)
```

### 文件关联
- `AuthenticationViewModel.swift` ← 管理登录状态
- `UserDataViewModel.swift` ← 管理用户数据和任务系统
- `MotionManager.swift` ← 管理运动数据追踪
- `TrailModels.swift` ← 定义核心数据结构
- `DailyGoal.swift` ← 每日运动目标配置
- `DailyQuest.swift` ← 每日任务和奖励系统
- `Achievement.swift` ← 成就系统数据结构

## 🧪 测试

- **单元测试**: `Cmd + U`
- **UI测试**: 选择 TrailsUITests 方案

---

*简洁、现代、功能完整的 iOS 应用基础架构*