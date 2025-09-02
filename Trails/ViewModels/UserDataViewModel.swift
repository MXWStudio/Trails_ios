import Foundation

class UserDataViewModel: ObservableObject {
    @Published var user = UserData()
    @Published var achievements: [Achievement] = Achievement.sampleAchievements
    @Published var dailyQuests: [DailyQuest] = [
        DailyQuest(title: "赚取 100 经验", progress: 0, target: 100, rewardCoins: 10),
        DailyQuest(title: "完成 1 次 2 公里以上的跑步", progress: 0, target: 1, rewardCoins: 20),
        DailyQuest(title: "燃烧 300 大卡", progress: 0, target: 300, rewardCoins: 15)
    ]
    
    func addXP(_ amount: Int) {
        user.totalXP += amount
        // 检查与XP相关的任务
        if let index = dailyQuests.firstIndex(where: { $0.title.contains("经验") }) {
            dailyQuests[index].progress += amount
        }
    }
    
    func addCoins(_ amount: Int) {
        user.coins += amount
    }
    
    // 示例：完成一个基于距离的任务
    func checkDistanceQuest(distanceKm: Double) {
        if let index = dailyQuests.firstIndex(where: { $0.title.contains("公里") }) {
            if distanceKm >= 2.0 {
                dailyQuests[index].progress = 1
            }
        }
    }
    
    // 示例：完成一个基于卡路里的任务
    func checkCaloriesQuest(calories: Double) {
        if let index = dailyQuests.firstIndex(where: { $0.title.contains("大卡") }) {
            dailyQuests[index].progress += Int(calories)
        }
    }

    // 新增：升级伙伴的方法
    func levelUpCompanion() {
        user.companion.level += 1
        // 可以在这里添加升级时的特殊奖励逻辑
    }
    
    // 新增：解锁新装饰品的方法
    func unlockDecoration(_ item: DecorationItem) {
        // 确保不重复添加
        if !user.ownedDecorations.contains(where: { $0.name == item.name }) {
            user.ownedDecorations.append(item)
        }
    }
    
    // 新增：解锁成就的方法
    func unlockAchievement(withTitle title: String) {
        if let index = achievements.firstIndex(where: { $0.title == title }) {
            achievements[index].isUnlocked = true
        }
    }
    
    // 新增：检查是否应该解锁成就
    func checkAchievements() {
        // 检查首次跑步成就
        if user.totalXP > 0 {
            if let achievement = achievements.first(where: { $0.title == "首次跑步" }), !achievement.isUnlocked {
                unlockAchievement(withTitle: "首次跑步")
            }
        }
        
        // 检查连续运动成就
        if user.streakDays >= 30 {
            if let achievement = achievements.first(where: { $0.title == "持续运动者" }), !achievement.isUnlocked {
                unlockAchievement(withTitle: "持续运动者")
            }
        }
    }
}

