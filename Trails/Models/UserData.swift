import Foundation

struct UserData {
    var id = UUID()
    var name: String = "伟子哥"
    var avatarName: String = "avatar_placeholder"
    var joinYear: Int = 2025
    
    var followers: Int = 12
    var following: Int = 16
    
    var streakDays: Int = 256
    var totalXP: Int = 31946
    var coins: Int = 300
    
    var heightCM: Double = 180.0
    var weightKG: Double = 75.0
    var preferredIntensity: Intensity = .moderate
    
    var league: String = "红宝石"
    
    // 新增：用户的收藏运动类型，最多4个
    var favoriteActivities: [ActivityType] = [.cycling, .hiking, .running, .badminton]
}
