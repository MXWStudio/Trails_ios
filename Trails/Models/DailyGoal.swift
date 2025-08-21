import Foundation

struct DailyGoal {
    var intensity: Intensity = .moderate
    
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

enum Intensity: String, CaseIterable {
    case beginner = "新手"
    case moderate = "适中"
    case advanced = "进阶"
    case professional = "专业"
}
