import Foundation

// 为了能和数据库的表对应，我们需要让模型遵循 Codable 协议
struct UserData: Codable, Identifiable {
    // 将 id 改为 UUID 类型，并设为数据库的主键
    var id: UUID
    var name: String = "新用户"
    var avatarURL: String? = nil // 头像URL，可选
    var age: Int? = nil // 年龄，可选
    var heightCM: Double? = nil // 身高（厘米），可选
    var customTitle: String? = nil // 自定义称号，可选
    var totalXP: Int = 0
    var joinYear: Int = Calendar.current.component(.year, from: Date())
    var followers: Int = 0
    var following: Int = 0
    var streakDays: Int = 0
    var league: String = "青铜"
    var coins: Int = 50
    var weightKG: Double = 70.0
    var preferredIntensity: Intensity = .moderate
    var favoriteActivities: [ActivityType] = []
    var firsts: [UserFirstRecord] = []
    var team: Team? = nil
    var companion: CompanionIP = CompanionIP()
    var ownedDecorations: [DecorationItem] = []
    
    // 时间戳字段（从数据库读取，但不用于创建）
    var createdAt: Date?
    var updatedAt: Date?
    
    // Supabase 的表中列名通常是下划线风格，我们需要一个 CodingKey 来做转换
    enum CodingKeys: String, CodingKey {
        case id, name, age, followers, following, league, coins, firsts, team, companion
        case avatarURL = "avatar_url"
        case heightCM = "height_cm"
        case customTitle = "custom_title"
        case totalXP = "total_xp"
        case joinYear = "join_year"
        case streakDays = "streak_days"
        case weightKG = "weight_kg"
        case preferredIntensity = "preferred_intensity"
        case favoriteActivities = "favorite_activities"
        case ownedDecorations = "owned_decorations"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    // 初始化方法，用于创建新用户
    init(id: UUID) {
        self.id = id
        self.name = "新用户"
        self.totalXP = 0
        self.joinYear = Calendar.current.component(.year, from: Date())
        self.followers = 0
        self.following = 0
        self.streakDays = 0
        self.league = "青铜"
        self.coins = 50
        self.weightKG = 70.0
        self.preferredIntensity = .moderate
        self.favoriteActivities = []
        self.firsts = []
        self.team = nil
        self.companion = CompanionIP()
        self.ownedDecorations = []
        self.createdAt = nil
        self.updatedAt = nil
    }
    
    // 完整的初始化方法，用于从数据库加载
    init(
        id: UUID,
        name: String = "新用户",
        avatarURL: String? = nil,
        age: Int? = nil,
        heightCM: Double? = nil,
        customTitle: String? = nil,
        totalXP: Int = 0,
        joinYear: Int = Calendar.current.component(.year, from: Date()),
        followers: Int = 0,
        following: Int = 0,
        streakDays: Int = 0,
        league: String = "青铜",
        coins: Int = 50,
        weightKG: Double = 70.0,
        preferredIntensity: Intensity = .moderate,
        favoriteActivities: [ActivityType] = [],
        firsts: [UserFirstRecord] = [],
        team: Team? = nil,
        companion: CompanionIP = CompanionIP(),
        ownedDecorations: [DecorationItem] = [],
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
        self.age = age
        self.heightCM = heightCM
        self.customTitle = customTitle
        self.totalXP = totalXP
        self.joinYear = joinYear
        self.followers = followers
        self.following = following
        self.streakDays = streakDays
        self.league = league
        self.coins = coins
        self.weightKG = weightKG
        self.preferredIntensity = preferredIntensity
        self.favoriteActivities = favoriteActivities
        self.firsts = firsts
        self.team = team
        self.companion = companion
        self.ownedDecorations = ownedDecorations
        self.createdAt = createdAt
        self.updatedAt = updatedAt
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

