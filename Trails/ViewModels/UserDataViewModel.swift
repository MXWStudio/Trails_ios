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
        guard let currentUserID = try? await SupabaseManager.shared.client.auth.session.user.id else {
            print("No active user session.")
            return
        }
        
        do {
            let profile: UserData = try await SupabaseManager.shared.client
                .from("profiles")
                .select()
                .eq("id", value: currentUserID)
                .single()
                .execute()
                .value
                
            self.user = profile
        } catch {
            print("Error fetching user profile: \(error)")
            // 如果用户资料不存在，创建一个新的
            await createNewUserProfile(userID: currentUserID)
        }
    }
    
    func createNewUserProfile(userID: UUID) async {
        let newUser = UserData(
            id: userID,
            name: "新用户",
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
        
        // 临时实现：直接设置用户数据
        self.user = newUser
        
        // 当Supabase包正确安装后，启用以下代码：
        /*
        do {
            try await SupabaseManager.shared.client
                .from("profiles")
                .insert(newUser, returning: .minimal)
                .execute()
            
            self.user = newUser
            print("Successfully created new user profile.")
        } catch {
            print("Error creating user profile: \(error)")
        }
        */
    }
    
    func createDefaultUserProfile() async {
        await createNewUserProfile(userID: UUID())
    }
    
    func updateUserProfile() async {
        guard user != nil else { return }
        
        // 临时实现：打印更新信息
        print("临时实现：用户数据已更新（本地）")
        
        // 当Supabase包正确安装后，启用以下代码：
        /*
        guard let userToUpdate = user else { return }
        
        print("Attempting to update user profile in Supabase...")
        do {
            try await SupabaseManager.shared.client
                .from("profiles")
                .update(userToUpdate, returning: .minimal)
                .eq("id", value: userToUpdate.id)
                .execute()
            print("Successfully updated user profile.")
        } catch {
            print("Error updating user profile: \(error)")
        }
        */
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
