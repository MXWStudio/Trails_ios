import Foundation

struct DailyQuest: Identifiable {
    let id = UUID()
    var title: String
    var progress: Int
    var target: Int
    var rewardCoins: Int
    var isCompleted: Bool { progress >= target }
}
