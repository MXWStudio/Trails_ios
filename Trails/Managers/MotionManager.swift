//
//  MotionManager.swift
//  Trails
//
//  Created by 孟祥伟 on 2025/8/20.
//

import Foundation
import Combine

// MARK: - 运动数据管理器

/// 运动数据管理器 - 负责追踪用户的运动数据
/// 
/// 功能包括：
/// - 实时追踪运动时长、距离、卡路里
/// - 开始/停止运动追踪
/// - 重置运动数据
/// - 为开发阶段提供模拟数据
class MotionManager: ObservableObject {
    @Published var isTracking = false
    @Published var durationSeconds: TimeInterval = 0
    @Published var caloriesBurned: Double = 0
    @Published var distanceMeters: Double = 0
    
    private var timer: Timer?

   // 未来的精确计算将在这里进行
    func startTracking(user: UserData) {
        isTracking = true
        // 模拟数据增长 (未来将替换为 HealthKit 或 GPS 数据)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.durationSeconds += 1
            // 简单模拟卡路里燃烧，实际应使用公式: METs * weight * time
            self.caloriesBurned += 0.1 * (user.weightKG / 75.0)
            self.distanceMeters += 1.5
        }
    }

    /// 停止运动追踪
    func stopTracking() {
        isTracking = false
        timer?.invalidate()
        timer = nil
    }
    
    func resetData() {
        durationSeconds = 0
        caloriesBurned = 0
        distanceMeters = 0
    }
}
