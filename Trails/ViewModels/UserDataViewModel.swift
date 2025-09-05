import SwiftUI
import Supabase


// DateFormatter 扩展
extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

@MainActor // 确保所有对 @Published 属性的修改都在主线程上
class UserDataViewModel: ObservableObject {
    // 从 Supabase 加载的用户数据
    @Published var user: UserData?
    
    // 本地管理的游戏化数据 (未来也可以从 Supabase 加载)
    @Published var achievements: [Achievement] = Achievement.sampleAchievements
    @Published var dailyQuests: [DailyQuest] = [
        DailyQuest(title: "赚取 100 经验", progress: 0, target: 100, rewardCoins: 10),
        DailyQuest(title: "完成 1 次 2 公里以上的跑步", progress: 0, target: 1, rewardCoins: 20),
        DailyQuest(title: "燃烧 300 大卡", progress: 0, target: 300, rewardCoins: 15)
    ]
    
    init() {
        // 监听用户认证成功的通知
        NotificationCenter.default.addObserver(
            forName: .userDidAuthenticate,
            object: nil,
            queue: .main
        ) { _ in
            Task {
                await self.fetchCurrentUserProfile()
            }
        }
    }
    
    // --- Supabase 数据交互 ---
    
    func fetchCurrentUserProfile() async {
        print("👤 开始获取用户资料...")
        guard let currentUserID = try? await SupabaseManager.shared.client.auth.session.user.id else {
            print("❌ 没有活跃的用户会话")
            return
        }
        
        print("🆔 当前用户ID: \(currentUserID)")
        
        do {
            print("🗄️ 正在从 profiles 表查询用户资料...")
            let profile: UserData = try await SupabaseManager.shared.client
                .from("profiles")
                .select()
                .eq("id", value: currentUserID)
                .single()
                .execute()
                .value
                
            print("✅ 成功获取用户资料: \(profile.name)")
            self.user = profile
        } catch {
            print("❌ 获取用户资料失败: \(error)")
            print("❌ 错误详情: \(error.localizedDescription)")
            print("🔄 准备为用户创建新的资料...")
            // 如果用户资料不存在，创建一个新的
            await createNewUserProfile(userID: currentUserID)
        }
    }
    
    func createNewUserProfile(userID: UUID) async {
        print("🆕 开始创建新的用户资料，用户ID: \(userID)")
        
        let newUser = UserData(
            id: userID,
            name: "新用户",
            avatarURL: nil,
            age: nil,
            heightCM: nil,
            customTitle: nil,
            totalXP: 0,
            joinYear: Calendar.current.component(.year, from: Date()),
            followers: 0,
            following: 0,
            streakDays: 0,
            league: "青铜",
            coins: 50,
            weightKG: 70.0,
            preferredIntensity: .moderate,
            favoriteActivities: [],
            firsts: [
                UserFirstRecord(title: "第一次使用 Trails", date: DateFormatter.shortDate.string(from: Date()), icon: "sparkles")
            ],
            team: nil,
            companion: CompanionIP(),
            ownedDecorations: [
                DecorationItem(name: "小花", imageName: "flower.fill"),
                DecorationItem(name: "宝石", imageName: "gem.fill")
            ]
        )
        
        print("📝 用户资料数据已准备完成")
        print("🔄 尝试将用户资料保存到 Supabase...")
        
        do {
            try await SupabaseManager.shared.client
                .from("profiles")
                .insert(newUser, returning: .minimal)
                .execute()
            
            print("✅ 成功创建用户资料到数据库")
            self.user = newUser
            print("🎉 新用户资料创建完成")
        } catch {
            print("❌ 创建用户资料失败: \(error)")
            print("❌ 错误详情: \(error.localizedDescription)")
            print("🔄 使用临时实现：仅设置本地用户数据")
            // 如果数据库操作失败，至少设置本地数据，避免应用卡住
            self.user = newUser
        }
    }
    
    func createDefaultUserProfile() async {
        await createNewUserProfile(userID: UUID())
    }
    
    func updateUserProfile() async {
        guard let userToUpdate = user else { return }
        
        print("📝 准备更新用户资料...")
        print("🆔 用户ID: \(userToUpdate.id)")
        print("👤 用户姓名: \(userToUpdate.name)")
        
        do {
            try await SupabaseManager.shared.client
                .from("profiles")
                .update(userToUpdate, returning: .minimal)
                .eq("id", value: userToUpdate.id)
                .execute()
            print("✅ 成功更新用户资料到数据库")
        } catch {
            print("❌ 更新用户资料失败: \(error)")
            print("❌ 错误详情: \(error.localizedDescription)")
            // 即使数据库更新失败，本地数据已经更新，保持应用可用性
        }
    }
    
    // 新增：专门用于更新个人信息的方法
    func updatePersonalInfo(name: String?, age: Int?, heightCM: Double?, weightKG: Double?, customTitle: String? = nil, avatarURL: String? = nil) async {
        guard user != nil else { return }
        
        // 更新本地数据
        if let name = name { user?.name = name }
        if let age = age { user?.age = age }
        if let height = heightCM { user?.heightCM = height }
        if let weight = weightKG { user?.weightKG = weight }
        if let title = customTitle { user?.customTitle = title }
        if let avatarURL = avatarURL { user?.avatarURL = avatarURL }
        
        // 同步到云端
        await updateUserProfile()
    }
    
    // --- 本地游戏化逻辑 (会触发云端同步) ---
    
    func addXP(_ amount: Int) {
        guard user != nil else { return }
        user?.totalXP += amount
        
        if let index = dailyQuests.firstIndex(where: { $0.title.contains("经验") }) {
            dailyQuests[index].progress += amount
        }
        
        // 修改后，自动保存到云端
        Task { await updateUserProfile() }
    }
    
    func addCoins(_ amount: Int) {
        guard user != nil else { return }
        user?.coins += amount
        Task { await updateUserProfile() }
    }

    func levelUpCompanion() {
        guard user != nil else { return }
        user?.companion.level += 1
        Task { await updateUserProfile() }
    }
    
    func checkDistanceQuest(distanceKm: Double) {
        if let index = dailyQuests.firstIndex(where: { $0.title.contains("公里") }) {
            if distanceKm >= 2.0 {
                dailyQuests[index].progress = 1
            }
        }
    }
    
    func checkCaloriesQuest(calories: Double) {
        if let index = dailyQuests.firstIndex(where: { $0.title.contains("大卡") }) {
            dailyQuests[index].progress += Int(calories)
        }
    }
    
    func unlockAchievement(withTitle title: String) {
        if let index = achievements.firstIndex(where: { $0.title == title }) {
            achievements[index].isUnlocked = true
        }
    }
}
