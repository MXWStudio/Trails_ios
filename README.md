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
│   ├── Main/                         # 主要视图和导航
│   │   ├── MainNavigationView.swift  # 🆕 主导航容器
│   │   └── BottomTabView.swift       # 🔄 重构底部导航组件
│   ├── Tabs/                         # 标签页视图
│   │   ├── TodayGoalView.swift       # 🏠 今日目标页面 (主页)
│   │   ├── CommunityView.swift       # 社区页面
│   │   ├── FavoritesView.swift       # 成就页面
│   │   ├── ActivityView.swift        # 运动追踪页面
│   │   ├── ProfileView.swift         # 个人页面
│   │   └── DailyQuestsView.swift     # 每日任务视图
│   ├── DetailViews/                   # 详情页面视图
│   │   ├── ActivityDetailView.swift  # 🆕 运动详情页面
│   │   ├── FeaturedRoutesView.swift  # 推荐路线页面  
│   │   └── MapDetailView.swift       # 地图详情页面
│   └── Subviews/                     # 子视图组件
│       ├── ActivityDataPanel.swift   # 运动数据面板
│       ├── ActivitySummaryView.swift # 运动总结视图
│       ├── EditProfileView.swift     # 编辑资料视图
│       ├── InfoCardView.swift        # 🆕 信息卡片组件
│       ├── StatCard.swift            # 统计卡片组件
│       ├── CommunityFeedView.swift   # 🆕 社区动态视图
│       ├── LeaderboardPageView.swift # 🆕 排行榜页面视图
│       ├── PostCardView.swift        # 🆕 动态卡片组件
│       └── CreatePostView.swift      # 🆕 创建帖子视图
│       # 注: 天气、装备、排行榜、点评组件已集成到ActivityDetailView中
├── Models/                           # 数据模型
│   ├── TrailModels.swift            # 核心模型
│   ├── UserData.swift               # 用户数据模型
│   ├── DailyGoal.swift              # 每日目标模型
│   ├── DailyQuest.swift             # 每日任务模型
│   ├── Achievement.swift            # 成就模型
│   ├── ActivityType.swift           # 🆕 运动类型模型
│   ├── CommunityPost.swift          # 🆕 社区动态模型
│   └── RankedUser.swift             # 🆕 排行榜用户模型
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
- **运动详情**: 详细的运动介绍和参数展示
- **模拟数据**: 便于开发测试

### 🎮 游戏化系统
- **经验值系统**: 完成运动获得XP奖励
- **段位系统**: 红宝石等段位展示
- **每日任务**: 动态任务系统和金币奖励
- **成就系统**: 解锁各类运动成就

### 🌐 社区功能
- **好友动态**: 查看好友的运动分享和成就解锁
- **互动系统**: 点赞和评论功能
- **排行榜**: 基于经验值的用户排名
- **分享功能**: 运动记录和成就展示

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

### 📝 社区发帖功能测试

1. 在社区页面点击右下角的蓝色"+"按钮
2. 选择运动类型（会显示相应的彩色占位符）
3. 填写距离、运动感受和标签
4. 点击"发布"按钮
5. 新帖子会出现在动态列表的顶部

## 📂 应用导航结构

### 应用流程
```
TrailsApp.swift 
    ↓
LoginView.swift (未登录)
    ↓
MainNavigationView.swift (已登录，主导航容器)
    ↓
[TodayGoalView | CommunityView | FavoritesView | ProfileView]
    ↓  
BottomTabView.swift (底部导航栏组件)
    ↓
ActivityView (从TodayGoalView启动)
```

### 导航架构更新 🆕
- **TodayGoalView**: 默认主页面，用户登录后直接显示
- **MainNavigationView**: 新增主导航容器，管理页面切换
- **BottomTabView**: 重构为可重用的底部导航栏组件
- **统一底部导航**: 每个页面都集成了底部导航栏
- **页面切换**: 支持在今日目标、社区、成就、个人页面间无缝切换

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

## 🆕 最新更新

### 社区功能模块 - 用户互动和排行榜
- **功能**: 完整的社区交互系统，包含动态分享和排行榜功能
- **特色**:
  - 双标签页设计：好友动态 + 排行榜
  - 动态卡片展示：运动记录、成就解锁、等级提升
  - 互动功能：点赞和评论系统
  - 实时排行榜：基于经验值的用户排名
  - 地图快照：运动记录包含路线预览
- **技术实现**:
  - 使用 Picker 和 SegmentedPickerStyle 实现标签切换
  - 模块化设计：CommunityFeedView 和 LeaderboardPageView
  - 数据模型：CommunityPost 和 RankedUser
  - 响应式布局：ScrollView + LazyVStack 优化性能

### 新增的社区组件

#### CommunityView - 社区主视图
- **功能**: 社区功能的主容器，管理动态和排行榜的切换
- **特色**:
  - 顶部分段控制器，支持动态/排行榜切换
  - 添加好友按钮（待实现）
  - 统一的导航栏设计

#### CommunityFeedView - 好友动态视图
- **功能**: 展示好友的运动分享和成就动态
- **特色**:
  - 使用 PostCardView 组件展示每条动态
  - 支持滚动浏览和实时更新
  - 模拟真实的社交体验

#### PostCardView - 动态卡片组件
- **功能**: 单条动态内容的展示组件
- **参数**:
  - `post`: CommunityPost 类型，包含动态的完整信息
- **设计特点**:
  - 用户头像和信息的横向布局
  - 动态类型和时间戳显示
  - 条件渲染地图快照（针对运动记录）
  - 底部互动按钮：点赞和评论计数

#### LeaderboardPageView - 排行榜视图
- **功能**: 展示基于经验值的用户排行榜
- **特色**:
  - List 布局展示排名信息
  - 排名、头像、姓名、经验值的完整展示
  - 支持动态数据更新

#### 数据模型

##### CommunityPost - 社区动态模型
- **属性**:
  - `userName`: 用户名称
  - `userAvatar`: 用户头像（SF Symbol）
  - `postType`: 动态类型（运动/成就/升级）
  - `timestamp`: 发布时间
  - `description`: 动态描述
  - `likes/comments`: 互动数据
  - `activityMapSnapshot`: 地图快照（可选）

##### RankedUser - 排行榜用户模型
- **属性**:
  - `rank`: 排名
  - `name`: 用户名
  - `avatar`: 头像
  - `xp`: 经验值

### ActivityDetailView - 运动详情页面
- **功能**: 展示具体运动项目的详细信息
- **特色**: 
  - 交互式地图显示运动路线
  - 使用 InfoCardView 组件展示运动参数
  - 集成实用工具：天气预报、装备建议
  - 社交元素：排行榜、用户点评
  - 游戏化奖励系统（XP、成就）
  - 悬浮的"开始运动"按钮
- **技术实现**: 
  - 使用 ScrollView 实现滚动布局
  - 集成 MapKit 展示地图
  - 模块化设计，多个子组件集成
  - 响应式布局适配不同屏幕

### 集成的子视图组件

#### InfoCardView - 信息卡片组件  
- **功能**: 可重用的信息展示卡片
- **参数**:
  - `icon`: SF Symbol 图标名称
  - `value`: 主要数值（如距离、时间）
  - `label`: 标签文字说明
- **设计特点**:
  - 垂直布局，图标+数值+标签
  - 圆角卡片样式，浅灰色背景
  - 自适应宽度，支持水平排列
  - 蓝色图标主题，突出视觉层次

#### WeatherForecastView - 天气预报组件
- **功能**: 显示当前及未来几小时的天气预报
- **特色**:
  - 水平滚动的天气卡片布局
  - SF Symbol 天气图标，橙色主题
  - 时间、图标、温度三层信息展示
  - 响应式卡片设计

#### GearSuggestionView - 装备建议组件
- **功能**: 为运动推荐必要装备
- **特色**:
  - 水平排列的装备图标
  - 包含水、跑鞋、速干衣、防晒等建议
  - 蓝色图标主题，简洁的垂直布局
  - 自适应宽度设计

#### LeaderboardView - 排行榜组件
- **功能**: 展示该运动的用户排行榜
- **特色**:
  - 排名、用户头像、姓名、成绩的完整展示
  - 灰色背景卡片，突出排行信息
  - 支持动态数据加载

#### UserReviewView - 用户点评组件
- **功能**: 展示用户对运动路线的评价和贴士
- **特色**:
  - 用户头像 + 评论内容的横向布局
  - 真实的用户体验分享
  - 为其他用户提供有价值的参考信息

### 🔧 组件集成策略
- **单文件集成**: 所有子组件都集成在 `ActivityDetailView.swift` 中，确保编译一致性
- **模块化设计**: 每个组件独立定义，便于维护和复用
- **统一主题**: 所有组件遵循应用的色彩主题（蓝色、橙色、灰色）
- **响应式布局**: 支持不同屏幕尺寸的自适应显示
- **预览支持**: 包含完整的 SwiftUI 预览代码，便于开发调试

## 🆕 新增功能详解 - 社区发帖系统

### CreatePostView - 创建帖子视图
- **功能**: 完整的用户发帖功能，支持创建运动记录帖子
- **特色**:
  - 📸 **封面选择**: 提供彩色渐变占位符，根据运动类型自动匹配主题色
  - 🏃 **运动类型**: 支持徒步、跑步、骑行、羽毛球四种运动类型选择
  - 📏 **距离输入**: 灵活的距离记录（如 "5.2 km"）
  - ✍️ **感受分享**: 多行文本编辑器，让用户分享运动体验
  - 🏷️ **标签系统**: 支持自由添加标签，自动处理 # 号前缀
  - ✅ **表单验证**: 必填项验证，确保数据完整性

### 数据流程优化
- **回调机制**: CreatePostView 通过回调函数将新帖子传递给 CommunityFeedView
- **实时更新**: 新发布的帖子立即出现在动态列表顶部
- **状态管理**: 使用 @State 管理表单数据和发布状态

### UserGeneratedContent - 用户生成内容模型
- **设计理念**: 专门为用户发布的内容设计的数据结构
- **包含属性**:
  - `coverImage`: 封面图片名称
  - `photos`: 图片数组（为未来扩展预留）
  - `caption`: 用户输入的文案
  - `tags`: 标签数组
  - `activityType`: 运动类型枚举
  - `routeInfo`: 路线信息（距离等）

### CommunityPost 重构升级
- **支持多种帖子类型**:
  - `systemMessage`: 系统生成的消息（升级、成就等）
  - `userPost`: 用户发布的运动记录
- **统一数据结构**: 便于在 PostCardView 中进行条件渲染
- **扩展性设计**: 易于添加新的帖子类型

### PostCardView 增强
- **双模式渲染**:
  - **SystemMessageCard**: 简洁的系统消息展示
  - **UserPostCard**: 丰富的用户内容展示
- **视觉设计改进**:
  - 🎨 彩色渐变背景根据运动类型自动匹配
  - 🏃 运动图标和类型名称叠加显示
  - 🏷️ 标签的蓝色胶囊设计
  - 📊 运动数据的卡片式展示

### 彩色占位符系统
- **动态主题**: 根据 ActivityType 的 themeColor 生成渐变背景
- **视觉一致性**: 从封面选择到帖子展示，保持色彩主题统一
- **图标集成**: SF Symbols 图标与运动类型相匹配

### 技术亮点
1. **枚举关联值**: CommunityPost.PostContent 使用枚举关联值优雅处理不同类型数据
2. **回调闭包**: CreatePostView 使用闭包回调实现解耦的数据传递
3. **条件渲染**: switch 语句在 PostCardView 中实现类型安全的视图切换
4. **字符串处理**: 自动为标签添加 # 前缀，提升用户体验
5. **表单验证**: 禁用按钮直到必填项完成，确保数据质量

### 使用流程
```
用户点击发布按钮 
    ↓
打开 CreatePostView
    ↓  
填写表单（运动类型、距离、感受、标签）
    ↓
点击发布按钮
    ↓
创建 UserGeneratedContent 对象
    ↓
包装成 CommunityPost
    ↓
通过回调传递给 CommunityFeedView
    ↓
插入到帖子列表顶部
    ↓
PostCardView 渲染新帖子
```

这个完整的发帖系统为用户提供了流畅的内容创建体验，同时为未来的功能扩展（如照片上传、位置标记等）奠定了良好的基础。

---

*简洁、现代、功能完整的 iOS 应用基础架构*