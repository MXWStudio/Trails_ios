import Foundation

// 为了能和数据库的表对应，我们需要让模型遵循 Codable 协议
struct UserData: Codable, Identifiable {
    // 将 id 改为 UUID 类型，并设为数据库的主键
    var id: UUID
    var name: String = "伟子哥"
    var totalXP: Int = 31946
    var joinYear: Int = 2025
    var followers: Int = 12
    var following: Int = 16
    var streakDays: Int = 256
    var league: String = "红宝石"
    var coins: Int = 150
    var weightKG: Double = 70.0
    var preferredIntensity: Intensity = .moderate
    var favoriteActivities: [ActivityType] = [.cycling, .hiking, .running, .badminton]
    var firsts: [UserFirstRecord] = [
        UserFirstRecord(title: "第一次使用 Trails", date: "2025-08-20", icon: "sparkles"),
        UserFirstRecord(title: "第一次完成5公里", date: "2025-08-22", icon: "figure.run")
    ]
    var team: Team? = Team(name: "冒险者小队", members: ["伟子哥", "用户A", "用户B"], weeklyProgress: 3, weeklyGoal: 5)
    var companion: CompanionIP = CompanionIP()
    var ownedDecorations: [DecorationItem] = [
        DecorationItem(name: "小花", imageName: "flower.fill"),
        DecorationItem(name: "宝石", imageName: "gem.fill"),
        DecorationItem(name: "星星", imageName: "star.fill"),
        DecorationItem(name: "奖杯", imageName: "trophy.fill")
    ]
    
    // Supabase 的表中列名通常是下划线风格，我们需要一个 CodingKey 来做转换
    enum CodingKeys: String, CodingKey {
        case id, name, followers, following, league, coins, firsts, team, companion
        case totalXP = "total_xp"
        case joinYear = "join_year"
        case streakDays = "streak_days"
        case weightKG = "weight_kg"
        case preferredIntensity = "preferred_intensity"
        case favoriteActivities = "favorite_activities"
        case ownedDecorations = "owned_decorations"
    }
}

// 运动强度枚举
enum Intensity: String, Codable, CaseIterable, Identifiable {
    case beginner = "新手"
    case moderate = "适中"
    case advanced = "进阶" 
    case professional = "专业"
    
    var id: String { self.rawValue }
}
