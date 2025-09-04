//
//  ExploreView.swift
//  Trails
//
//  Created by 孟祥伟 on 2025/8/20.
//

import SwiftUI

/// 今日目标视图 - 游戏化运动目标设定
/// 
/// 这个视图是应用的核心功能，提供游戏化的运动体验：
/// - 设定每日运动目标和强度
/// - 开始运动追踪和实时数据显示
/// - 游戏化奖励系统
/// - 个性化运动计划
/// 
/// 界面特色：
/// - 现代化的运动追踪界面设计
/// - 直观的目标设定和进度显示
/// - 响应式设计，适配不同设备尺寸
/// - 沉浸式的运动体验
struct TodayGoalView: View {
    @EnvironmentObject var userDataVM: UserDataViewModel
    @State private var showActivityView = false
    @State private var selectedActivityIndex = 0 // 追踪当前显示的卡片
    @State private var searchText = ""

    // 获取当前选中的运动类型
    private var currentActivity: ActivityType {
        guard let favoriteActivities = userDataVM.user?.favoriteActivities, !favoriteActivities.isEmpty else {
            return .running // 默认活动
        }
        let safeIndex = min(selectedActivityIndex, favoriteActivities.count - 1)
        return favoriteActivities[safeIndex]
    }
    
    // 根据用户偏好和当前运动类型生成目标
    private var dailyGoal: DailyGoal {
        DailyGoal(intensity: userDataVM.user?.preferredIntensity ?? .moderate)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // 1. 顶部标题和搜索栏
                    VStack {
                        Text("探索你的路线") // 中文标题
                            .font(.largeTitle).bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            TextField("搜索路线...", text: $searchText)
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    // 2. 左右滑动的运动卡片
                    if !(userDataVM.user?.favoriteActivities.isEmpty ?? true) {
                        TabView(selection: $selectedActivityIndex) {
                            ForEach(0..<(userDataVM.user?.favoriteActivities.count ?? 0), id: \.self) { index in
                                let activity = userDataVM.user?.favoriteActivities[index] ?? .cycling
                                NavigationLink(destination: ActivityDetailView(activity: activity, goal: dailyGoal)) {
                                    ActivityCardView(activity: activity)
                                        .tag(index)
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .frame(height: 250)
                    } else {
                        // 当没有收藏活动时的占位符
                        VStack {
                            Text("还没有收藏的运动")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("去个人资料设置你喜欢的运动吧！")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                        .padding(.horizontal)
                    }
                    
                    // 3. 类别按钮
                    VStack(alignment: .leading) {
                        Text("类别")
                            .font(.title2).bold()
                        
                        HStack(spacing: 20) {
                            NavigationLink(destination: MapDetailView()) {
                                CategoryButtonView(icon: "map.fill", title: "地图")
                            }
                            NavigationLink(destination: FeaturedRoutesView()) {
                                CategoryButtonView(icon: "star.fill", title: "精选")
                            }
                            // 你可以添加更多类别
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true) // 隐藏默认导航栏以自定义标题
            .overlay(
                // 4. 悬浮的“开始运动”按钮
                Button(action: {
                    showActivityView = true
                }) {
                    Text("开始 \(currentActivity.rawValue)")
                        .font(.headline)
                        .padding()
                        .background(currentActivity.themeColor)
                        .foregroundColor(.white)
                        .cornerRadius(18)
                        .shadow(radius: 5)
                }
                .padding(.bottom, 20)
                .fullScreenCover(isPresented: $showActivityView) {
                    // 点击按钮后，传入当前卡片对应的运动目标
                    ActivityView(goal: dailyGoal)
                }
                , alignment: .bottom
            )
        }
    }
}

// --- 子视图：运动卡片 ---
struct ActivityCardView: View {
    let activity: ActivityType
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(activity.themeColor.opacity(0.8))
            
            // 使用 SF Symbol 作为占位符，你需要替换为自己的插画
            Image(systemName: activity.illustrationName)
                .font(.system(size: 100))
                .foregroundColor(.white.opacity(0.5))
                .scaleEffect(1.2)
                .offset(x: 40, y: -20)
            
            VStack(alignment: .leading) {
                Text(activity.rawValue)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("开始新的挑战")
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding()
        }
        .padding(.horizontal)
    }
}

// --- 子视图：类别按钮 ---
struct CategoryButtonView: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.blue)
                .frame(width: 80, height: 80)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
            Text(title)
                .font(.headline)
        }
    }
}