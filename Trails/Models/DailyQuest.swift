import Foundation

struct DailyQuest: Identifiable {
    let id = UUID()
    var title: String
    var progress: Int
    var target: Int
    var rewardCoins: Int
    
    var isCompleted: Bool {
        return progress >= target
    }
    
    var progressPercentage: Double {
        return Double(progress) / Double(target)
    }
}