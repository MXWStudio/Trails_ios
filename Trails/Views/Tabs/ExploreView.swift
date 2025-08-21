//
//  ExploreView.swift
//  Trails
//
//  Created by 孟祥伟 on 2025/8/20.
//

import SwiftUI

/// 探索视图 - 游戏化运动目标设定
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
struct ExploreView: View {
    @State private var dailyGoal = DailyGoal()
    @State private var showActivityView = false

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // 页面标题
                Text("设定你的今日目标")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // 运动强度选择器
                VStack(alignment: .leading, spacing: 10) {
                    Text("运动强度")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Picker("运动强度", selection: $dailyGoal.intensity) {
                        ForEach(Intensity.allCases, id: \.self) { intensity in
                            Text(intensity.rawValue).tag(intensity)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.horizontal)
                
                // 目标详情卡片
                VStack(alignment: .leading, spacing: 15) {
                    Text("目标详情")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    HStack {
                        Label("\(dailyGoal.durationMinutes) 分钟", systemImage: "timer")
                            .font(.title3)
                            .foregroundColor(.blue)
                        Spacer()
                        Label("\(dailyGoal.caloriesBurned) 大卡", systemImage: "flame.fill")
                            .font(.title3)
                            .foregroundColor(.orange)
                    }
                    
                    // 强度描述
                    Text(getIntensityDescription(dailyGoal.intensity))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)

                Spacer()
                
                // 开始运动按钮
                Button(action: {
                    showActivityView = true
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("开始运动")
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .navigationTitle("今日目标")
            .navigationBarTitleDisplayMode(.large)
            // 跳转到实时运动视图
            .fullScreenCover(isPresented: $showActivityView) {
                ActivityView(goal: dailyGoal)
            }
        }
    }
    
    /// 根据运动强度返回描述文字
    private func getIntensityDescription(_ intensity: Intensity) -> String {
        switch intensity {
        case .beginner:
            return "适合初学者，轻松的运动节奏"
        case .moderate:
            return "适中强度，平衡的运动体验"
        case .advanced:
            return "进阶训练，挑战你的极限"
        case .professional:
            return "专业级别，最高强度的运动挑战"
        }
    }
}

// MARK: - 预览
struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
