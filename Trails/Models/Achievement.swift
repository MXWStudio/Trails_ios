import Foundation

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    var isUnlocked: Bool
    var iconName: String // e.g., "star.fill"
    
    // 静态示例成就
    static let sampleAchievements: [Achievement] = [
        Achievement(title: "首次跑步", description: "完成第一次跑步活动", isUnlocked: true, iconName: "star.fill"),
        Achievement(title: "森林徒步者", description: "在森林中徒步5公里", isUnlocked: false, iconName: "tree.fill"),
        Achievement(title: "持续运动者", description: "连续运动30天", isUnlocked: false, iconName: "flame.fill"),
        Achievement(title: "速度达人", description: "达到10公里/小时的跑步速度", isUnlocked: false, iconName: "speedometer")
    ]
}

