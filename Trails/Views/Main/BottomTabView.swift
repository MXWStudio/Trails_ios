//
//  BottomTabView.swift
//  Trails
//
//  Created by 孟祥伟 on 2025/8/20.
//

import SwiftUI

/// 底部标签页导航视图 - 应用的核心导航容器
/// 
/// 这个视图是用户登录后看到的主界面，包含四个核心功能模块：
/// - 探索: 发现精彩路线和目的地
/// - 社区: 与其他旅行者交流分享  
/// - 收藏: 保存喜欢的路线和地点
/// - 个人: 用户信息管理和设置
/// 
/// 架构特点：
/// - 使用 TabView 提供原生的标签页导航体验
/// - 每个标签页对应一个独立的视图文件，便于维护
/// - 采用模块化设计，各功能相对独立
/// 
/// 依赖的视图文件：
/// - ExploreView.swift: 探索功能模块
/// - CommunityView.swift: 社区功能模块  
/// - FavoritesView.swift: 收藏功能模块
/// - ProfileView.swift: 个人资料模块
struct BottomTabView: View {
    var body: some View {
        TabView {
            // 第一个 Tab: 今日目标 (运动规划)
            ExploreView()
                .tabItem {
                    Image(systemName: "flag.checkered")
                    Text("今日目标")
                }

            // 第二个 Tab: 社区
            CommunityView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("社区")
                }

            // 第三个 Tab: 成就
            FavoritesView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("成就")
                }

            // 第四个 Tab: 个人
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("个人")
                }
        }
    }
}

// MARK: - 预览
struct BottomTabView_Previews: PreviewProvider {
    static var previews: some View {
        BottomTabView()
            .environmentObject(AuthenticationViewModel())
    }
}
