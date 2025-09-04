import Foundation

struct DailyGoal {
    // 现在由用户的偏好直接初始化
    var intensity: Intensity
    
    var durationMinutes: Int {
        switch intensity {
            case .beginner: return 20
            case .moderate: return 30
            case .advanced: return 45
            case .professional: return 60
        }
    }
    
    var caloriesBurned: Int {
        switch intensity {
            case .beginner: return 150
            case .moderate: return 250
            case .advanced: return 400
            case .professional: return 600
        }
    }
    
    var xpReward: Int {
        switch intensity {
            case .beginner: return 50
            case .moderate: return 75
            case .advanced: return 125
            case .professional: return 200
        }
    }
}

// Intensity 枚举已在 UserData.swift 中定义
