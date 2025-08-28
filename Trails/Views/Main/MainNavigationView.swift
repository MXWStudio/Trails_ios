//
//  MainNavigationView.swift
//  Trails
//
//  Created by 孟祥伟 on 2025/8/20.
//

import SwiftUI

/// 主导航视图 - 管理应用的页面切换和底部导航栏
/// 
/// 这个视图是用户登录后的主容器，负责：
/// - 管理不同页面之间的切换
/// - 显示统一的底部导航栏
/// - 保持页面状态和数据一致性
/// 
/// 页面结构：
/// - 今日目标: 默认主页，运动目标设定
/// - 社区: 用户交流和分享
/// - 成就: 运动成就和奖励系统
/// - 个人: 用户信息和设置
struct MainNavigationView: View {
    @State private var selectedTab: TabItem = .todayGoal
    
    var body: some View {
        VStack(spacing: 0) {
            // 主内容区域
            switch selectedTab {
            case .todayGoal:
                TodayGoalWithNavigation(selectedTab: $selectedTab)
            case .community:
                CommunityWithNavigation(selectedTab: $selectedTab)
            case .achievements:
                AchievementsWithNavigation(selectedTab: $selectedTab)
            case .profile:
                ProfileWithNavigation(selectedTab: $selectedTab)
            }
            
            // 底部导航栏
            BottomTabView(selectedTab: $selectedTab) { newTab in
                selectedTab = newTab
            }
        }
    }
}

// MARK: - 带导航栏的页面包装器

/// 今日目标页面包装器
struct TodayGoalWithNavigation: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        TodayGoalView()
    }
}

/// 社区页面包装器
struct CommunityWithNavigation: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        CommunityView()
    }
}

/// 成就页面包装器
struct AchievementsWithNavigation: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        FavoritesView() // 使用现有的 FavoritesView (实际上是 AchievementsView)
    }
}

/// 个人页面包装器
struct ProfileWithNavigation: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ProfileView()
    }
}

// MARK: - 预览
struct MainNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigationView()
            .environmentObject(AuthenticationViewModel())
            .environmentObject(MotionManager())
            .environmentObject(UserDataViewModel())
    }
}
