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
    let goal: DailyGoal
    
    @State private var showReward = false

    var body: some View {
        ZStack {
            // 背景地图显示当前位置
            Map()
                .ignoresSafeArea()

            VStack {
                Spacer()
                
                // 实时数据显示面板
                VStack(spacing: 20) {
                    // 运动时间 - 大字体显示
                    Text(formatDuration(motionManager.durationSeconds))
                        .font(.system(size: 80, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    // 距离和卡路里数据
                    HStack(spacing: 40) {
                        VStack {
                            Text(String(format: "%.2f", motionManager.distanceMeters / 1000))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            Text("公里")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Text(String(format: "%.0f", motionManager.caloriesBurned))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                            Text("大卡")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // 目标进度指示
                    if motionManager.durationSeconds >= Double(goal.durationMinutes * 60) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("已达成目标时长！")
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                        .padding(.top, 10)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20))
                .padding()

                Spacer()
                
                // 结束运动按钮
                Button(action: {
                    motionManager.stopTracking()
                    showReward = true
                }) {
                    VStack {
                        Image(systemName: "stop.fill")
                            .font(.title)
                        Text("结束运动")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .frame(width: 150, height: 150)
                    .background(Color.red)
                    .clipShape(Circle())
                    .shadow(color: .red.opacity(0.4), radius: 15, x: 0, y: 5)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            motionManager.resetData()
            motionManager.startTracking()
        }
        .alert(isPresented: $showReward) {
            Alert(
                title: Text("🎉 运动完成！"),
                message: Text("恭喜你完成了今日运动！\n获得了 100 金币和 50 XP！"),
                dismissButton: .default(Text("太棒了！"), action: {
                    presentationMode.wrappedValue.dismiss()
                })
            )
        }
    }
    
    /// 格式化运动时长为 MM:SS 格式
    private func formatDuration(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

// MARK: - 预览
struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(goal: DailyGoal())
            .environmentObject(MotionManager())
    }
}
