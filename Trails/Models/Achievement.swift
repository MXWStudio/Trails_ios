import Foundation

struct Achievement: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var icon: String
    var isUnlocked: Bool = false
    var unlockedDate: Date?
    var category: AchievementCategory
    
    mutating func unlock() {
        isUnlocked = true
        unlockedDate = Date()
    }
}

enum AchievementCategory: String, CaseIterable {
    case distance = "距离"
    case time = "时间"
    case calories = "卡路里"
    case streak = "连续天数"
    case special = "特殊"
}