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
    @State private var dailyGoal = DailyGoal()
    @State private var showActivityView = false

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // ... (与之前版本类似，UI未大改)
                Text("设定你的今日目标").font(.largeTitle).fontWeight(.bold)
                Picker("运动强度", selection: $dailyGoal.intensity) {
                    ForEach(Intensity.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }.pickerStyle(SegmentedPickerStyle())
                VStack(alignment: .leading, spacing: 15) {
                    Label("时长: \(dailyGoal.durationMinutes) 分钟", systemImage: "timer")
                    Label("卡路里: \(dailyGoal.caloriesBurned) 大卡", systemImage: "flame.fill")
                    Label("经验奖励: \(dailyGoal.xpReward) XP", systemImage: "sparkles")
                }.padding().background(Color.gray.opacity(0.1)).cornerRadius(12)
                Spacer()
                Button("开始运动") { showActivityView = true }
                    .buttonStyle(PrimaryButtonStyle())
            }
            .padding().navigationTitle("今日目标")
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
    }
}
