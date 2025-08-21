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

    /// 开始运动追踪
    func startTracking() {
        isTracking = true
        // 模拟数据增长 - 在实际应用中这里会连接 HealthKit 或 Core Motion
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.durationSeconds += 1
            self.caloriesBurned += 0.1 // 简化模拟：每秒消耗0.1卡路里
            self.distanceMeters += 1.5 // 简化模拟：每秒移动1.5米
        }
    }

    /// 停止运动追踪
    func stopTracking() {
        isTracking = false
        timer?.invalidate()
        timer = nil
    }
    
    /// 重置所有运动数据
    func resetData() {
        durationSeconds = 0
        caloriesBurned = 0
        distanceMeters = 0
    }
}
