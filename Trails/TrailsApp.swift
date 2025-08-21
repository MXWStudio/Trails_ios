//
//  TrailsApp.swift
//  Trails
//
//  Created by 孟祥伟 on 2025/8/20.
//

import SwiftUI

@main
struct TrailsApp: App {
    // 使用 @StateObject 来管理整个应用的认证状态
    @StateObject private var authViewModel = AuthenticationViewModel()
    // 添加运动数据管理器
    @StateObject private var motionManager = MotionManager()

    var body: some Scene {
        WindowGroup {
            // 根据登录状态决定显示哪个视图
            if authViewModel.isUserAuthenticated {
                // 如果用户已登录，显示底部导航栏视图
                BottomTabView()
                    .environmentObject(authViewModel)
                    .environmentObject(motionManager) // 注入运动管理器到环境中
            } else {
                // 如果用户未登录，显示登录页
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
