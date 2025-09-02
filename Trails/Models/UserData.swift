import Foundation

struct UserData {
    var name: String = "伟子哥"
    var totalXP: Int = 31946
    var joinYear: Int = 2025
    var followers: Int = 12
    var following: Int = 16
    var streakDays: Int = 256
    var league: String = "红宝石"
    var coins: Int = 150  // 新增：金币系统
    var weightKG: Double = 70.0  // 新增：用户体重，用于卡路里计算
    var preferredIntensity: Intensity = .moderate  // 新增：用户偏好的运动强度
    
    // 新增：伙伴和装饰品数据
    var companion: CompanionIP = CompanionIP()
    var ownedDecorations: [DecorationItem] = [
        DecorationItem(name: "营地帐篷", imageName: "tent.fill"),
        DecorationItem(name: "篝火", imageName: "bonfire.fill")
    ]


    
    // 新增：用户的收藏运动类型，最多4个
    var favoriteActivities: [ActivityType] = [.cycling, .hiking, .running, .badminton]
}
