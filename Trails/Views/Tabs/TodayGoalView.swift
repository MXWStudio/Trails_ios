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

    // 从用户数据动态生成目标
    private var dailyGoal: DailyGoal {
        DailyGoal(intensity: userDataVM.user.preferredIntensity)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("你的今日目标")
                    .font(.largeTitle).fontWeight(.bold)
                
                // 移除了选择器，直接显示用户的默认目标
                VStack(alignment: .center, spacing: 10) {
                    Text(dailyGoal.intensity.rawValue)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Label("时长: \(dailyGoal.durationMinutes) 分钟", systemImage: "timer")
                    Label("卡路里: \(dailyGoal.caloriesBurned) 大卡", systemImage: "flame.fill")
                    Label("经验奖励: \(dailyGoal.xpReward) XP", systemImage: "sparkles")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
                
                Button("开始运动") { showActivityView = true }
                    .buttonStyle(PrimaryButtonStyle())
            }
            .padding()
            .navigationTitle("今日目标")
            .fullScreenCover(isPresented: $showActivityView) {
                ActivityView(goal: dailyGoal)
            }
        }
    }
}

// MARK: - 预览
struct TodayGoalView_Previews: PreviewProvider {
    static var previews: some View {
        TodayGoalView()
            .environmentObject(UserDataViewModel())
    }
}
