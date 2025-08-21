import Foundation

class UserDataViewModel: ObservableObject {
    @Published var user = UserData()
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
}
