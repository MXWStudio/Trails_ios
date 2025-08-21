import Foundation

struct UserData {
    var id = UUID()
    var name: String = "伟子哥" // 示例名称
    var avatarName: String = "avatar_placeholder" // 示例头像
    var joinYear: Int = 2025
    
    var followers: Int = 12
    var following: Int = 16
    
    var streakDays: Int = 256
    var totalXP: Int = 31946
    var coins: Int = 300
    
    // 用于精确计算的个人数据
    var heightCM: Double = 180.0
    var weightKG: Double = 75.0

    // 新增：用户的默认运动强度
    var preferredIntensity: Intensity = .moderate
    
    var league: String = "红宝石" // 段位
}