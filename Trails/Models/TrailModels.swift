//
//  TrailModels.swift
//  Trails
//
//  Created by 孟祥伟 on 2025/8/20.
//

import Foundation

// MARK: - 运动目标模型

/// 用户每日运动目标设定
struct DailyGoal {
    var intensity: Intensity = .moderate
    var durationMinutes: Int = 30
    var caloriesBurned: Int = 200
}

/// 运动强度等级
enum Intensity: String, CaseIterable {
    case beginner = "新手"
    case moderate = "适中"
    case advanced = "进阶"
    case professional = "专业"
}

// MARK: - 成就系统模型

/// 用户成就模型
struct Achievement {
    let id = UUID()
    let title: String
    let description: String
    var isUnlocked: Bool
}
