//
//  ActivityView.swift
//  Trails
//
//  Created by 孟祥伟 on 2025/8/20.
//

import SwiftUI
import MapKit

/// 实时运动追踪视图
/// 
/// 这个视图提供沉浸式的运动追踪体验：
/// - 全屏地图背景显示当前位置
/// - 实时显示运动数据（时间、距离、卡路里）
/// - 大型停止按钮便于运动时操作
/// - 完成运动后的奖励反馈
/// 
/// 界面特色：
/// - 地图背景提供真实的位置感知
/// - 毛玻璃效果的数据面板，保持可读性
/// - 游戏化的完成奖励提示
/// - 简洁的操作界面，专注运动体验
struct ActivityView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var motionManager: MotionManager
    @EnvironmentObject var userData: UserDataViewModel
    let goal: DailyGoal
    
    @State private var showReward = false
    @State private var showSummary = false

    var body: some View {
        ZStack {
            Map().ignoresSafeArea()
            VStack {
                Spacer()
                ActivityDataPanel(motionManager: motionManager)
                Spacer()
                Button(action: {
                    motionManager.stopTracking()
                    // 增加经验值
                    userData.addXP(goal.xpReward)
                    // 检查任务进度
                    userData.checkDistanceQuest(distanceKm: motionManager.distanceMeters / 1000)
                    userData.checkCaloriesQuest(calories: motionManager.caloriesBurned)
                    // 显示总结页面
                    showSummary = true
                }) {
                    Text("结束运动").font(.title2).fontWeight(.bold).foregroundColor(.white)
                        .padding().frame(width: 150, height: 150)
                        .background(Color.red).clipShape(Circle()).shadow(radius: 10)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            motionManager.resetData()
            motionManager.startTracking(user: userData.user)
        }
        .sheet(isPresented: $showSummary) {
            ActivitySummaryView(goal: goal, motionManager: motionManager) {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

// MARK: - 预览
struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(goal: DailyGoal())
            .environmentObject(MotionManager())
    }
}
