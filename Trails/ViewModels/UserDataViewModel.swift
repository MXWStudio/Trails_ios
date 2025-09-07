import SwiftUI
import Foundation

@MainActor // 确保所有对 @Published 属性的修改都在主线程上
class UserDataViewModel: ObservableObject {
    @Published var user: UserData?
    @Published var isLoadingUserData = false
    @Published var isDataFromCache = false // 标记数据是否来自缓存
    
    // 本地管理的游戏化数据 (未来也可以从 Supabase 加载)
    @Published var achievements: [Achievement] = [] // Achievement.sampleAchievements
    @Published var dailyQuests: [DailyQuest] = [
        DailyQuest(title: "赚取 100 经验", progress: 0, target: 100, rewardCoins: 10),
        DailyQuest(title: "完成 1 次 2 公里以上的跑步", progress: 0, target: 1, rewardCoins: 20),
        DailyQuest(title: "燃烧 300 大卡", progress: 0, target: 300, rewardCoins: 15)
    ]
    
    init() {
        // 应用启动时先加载本地缓存的用户数据
        loadUserDataFromCache()
        
        // 监听用户认证成功的通知
        NotificationCenter.default.addObserver(
            forName: .userDidAuthenticate,
            object: nil,
            queue: .main
        ) { _ in
            Task {
                await self.smartFetchUserProfile()
            }
        }
        
        // 监听应用进入后台和前台的通知
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.saveUserDataToCache()
        }
        
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { _ in
            Task {
                await self.syncDataIfNeeded()
            }
        }
        
        // 监听用户登出通知
        NotificationCenter.default.addObserver(
            forName: .userDidSignOut,
            object: nil,
            queue: .main
        ) { _ in
            self.clearUserData()
        }
    }
}

extension UserDataViewModel {
    func saveActivityRecord(_ record: ActivityRecord) async {
        print("💾 准备保存运动记录到 Supabase...")
        print("📊 运动数据：类型=\(record.activity_type), 距离=\(String(format: "%.1f", record.distance_meters))米, 时长=\(record.duration_seconds)秒")
        print("🗺️ 轨迹点数量：\(record.route.count) 个坐标点")
        
        // 首先检查 activities 表是否存在
        let tableExists = await SupabaseManager.shared.checkActivitiesTable()
        if !tableExists {
            print("❌ activities 表不存在，无法保存运动记录")
            print("💡 请先在 Supabase 中执行 activities_table.sql 脚本创建表")
            return
        }
        
        do {
            let response = try await SupabaseManager.shared.client
                .from("activities")
                .insert(record, returning: .minimal)
                .execute()
            
            print("✅ 运动记录成功保存到 Supabase！")
            print("📄 响应状态：\(response.status)")
            
        } catch {
            print("❌ 保存运动记录失败: \(error)")
            
            // 详细的错误信息
            if let description = error as? LocalizedError {
                print("❌ 错误详情: \(description.errorDescription ?? "未知错误")")
            }
            
            // 检查是否是网络问题
            if error.localizedDescription.contains("网络") || error.localizedDescription.contains("network") {
                print("🌐 可能是网络连接问题，建议稍后重试")
            }
        }
    }


    // --- 智能数据同步和缓存管理 ---
    
    /// 从本地缓存加载用户数据
    func loadUserDataFromCache() {
        if let cachedUser = LocalStorageManager.shared.loadUserData() {
            self.user = cachedUser
            // 只有在真正需要显示离线模式时才标记为缓存数据
            self.isDataFromCache = LocalStorageManager.shared.shouldShowOfflineMode()
            print("✅ 已从本地缓存加载用户数据，离线模式：\(self.isDataFromCache)")
        }
    }
    
    /// 保存用户数据到本地缓存
    func saveUserDataToCache() {
        guard let currentUser = user else { return }
        LocalStorageManager.shared.saveUserData(currentUser)
    }
    
    /// 智能获取用户资料（优先使用缓存，按需同步云端）
    func smartFetchUserProfile() async {
        guard let currentUserID = try? await SupabaseManager.shared.client.auth.session.user.id else {
            return
        }
        
        // 如果本地没有数据，或者需要同步，则从云端获取
        if user == nil || LocalStorageManager.shared.shouldSyncWithCloud() {
            await fetchCurrentUserProfile()
        } else {
            print("ℹ️ 使用本地缓存数据，跳过云端同步")
            // 使用缓存数据时，更新离线状态标记
            self.isDataFromCache = LocalStorageManager.shared.shouldShowOfflineMode()
        }
    }
    
    /// 检查是否需要同步数据
    func syncDataIfNeeded() async {
        // 检查是否有待同步的更改
        if LocalStorageManager.shared.hasPendingChanges() {
            print("🔄 检测到待同步的更改，正在同步...")
            await updateUserProfile()
        }
        
        // 检查是否需要从云端获取最新数据
        if LocalStorageManager.shared.shouldSyncWithCloud() {
            print("🔄 数据较旧，从云端同步最新数据...")
            await fetchCurrentUserProfile()
        }
    }
    
    // --- Supabase 数据交互 ---
    
    func fetchCurrentUserProfile() async {
        guard let currentUserID = try? await SupabaseManager.shared.client.auth.session.user.id else {
            return
        }
        
        self.isLoadingUserData = true
        
        do {
            let profile: UserData = try await SupabaseManager.shared.client
                .from("profiles")
                .select()
                .eq("id", value: currentUserID)
                .single()
                .execute()
                .value
                
            self.user = profile
            self.isDataFromCache = false
            
            // 保存到本地缓存
            saveUserDataToCache()
            
            // 清除待同步的更改（因为已经获取到最新数据）
            LocalStorageManager.shared.clearPendingChanges()
            
        } catch {
            // 如果用户资料不存在，创建一个新的
            await createNewUserProfile(userID: currentUserID)
        }
        
        self.isLoadingUserData = false
    }
    
    func createNewUserProfile(userID: UUID) async {
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
            firsts: [],
            team: nil,
            companion: CompanionIP(),
            ownedDecorations: []
        )
        
        do {
            try await SupabaseManager.shared.client
                .from("profiles")
                .insert(newUser, returning: .minimal)
                .execute()
            
            self.user = newUser
        } catch {
            // 如果数据库操作失败，至少设置本地数据，避免应用卡住
            self.user = newUser
        }
    }
    
    // 之前实现的头像上传和资料更新方法，与你的新逻辑结合
    func updateProfileWithAvatar(name: String, age: Int?, customTitle: String?, height: Double?, weight: Double, newAvatar: UIImage?) async throws {
        guard var userToUpdate = self.user else { return }
        
        // 如果有新头像，先上传
        if let newAvatar = newAvatar {
            let avatarUrl = try await SupabaseManager.shared.uploadAvatar(userId: userToUpdate.id, image: newAvatar)
            userToUpdate.avatarURL = avatarUrl
        }
        
        // 更新其他信息
        userToUpdate.name = name
        userToUpdate.age = age
        userToUpdate.customTitle = customTitle
        userToUpdate.heightCM = height
        userToUpdate.weightKG = weight
        
        // 将更新后的整个 user 对象写回 Supabase
        try await SupabaseManager.shared.client.from("profiles").update(userToUpdate).eq("id", value: userToUpdate.id).execute()
        
        // 更新本地 @Published 属性，触发UI刷新
        self.user = userToUpdate
    }
    
    // 更新此方法以调用新的保存逻辑
    func saveChanges() {
        Task {
            guard let userToUpdate = user else { 
                print("❌ 保存失败：用户数据为空")
                return 
            }
            
            do {
                try await SupabaseManager.shared.client
                    .from("profiles")
                    .update(userToUpdate)
                    .eq("id", value: userToUpdate.id)
                    .execute()
                print("✅ 用户数据已成功保存到云端")
            } catch {
                print("❌ 保存用户数据失败: \(error.localizedDescription)")
                // 这里可以添加重试逻辑或者显示错误提示给用户
                // 考虑实现本地缓存机制，离线时先保存到本地
            }
        }
    }

    // --- 本地游戏化逻辑 (会触发云端同步) ---
    
    func addXP(_ amount: Int) {
        guard var currentUser = user else { 
            print("❌ 无法添加经验：用户数据为空")
            return 
        }
        
        // 先更新本地数据
        currentUser.totalXP += amount
        self.user = currentUser
        
        // 检查经验相关的每日任务
        checkExperienceQuest(xp: amount)
        
        // 异步保存到云端
        Task { await updateUserProfile() }
        
        print("✅ 添加了 \(amount) 经验，当前总经验：\(currentUser.totalXP)")
    }
    
    func addCoins(_ amount: Int) {
        guard var currentUser = user else { 
            print("❌ 无法添加金币：用户数据为空")
            return 
        }
        
        // 先更新本地数据
        currentUser.coins += amount
        self.user = currentUser
        
        // 异步保存到云端
        Task { await updateUserProfile() }
        
        print("✅ 添加了 \(amount) 金币，当前总金币：\(currentUser.coins)")
    }
    
    // --- 每日任务检查方法 ---
    
    func checkDistanceQuest(distanceKm: Double) {
        // 检查距离相关的每日任务
        for i in 0..<dailyQuests.count {
            if dailyQuests[i].title.contains("公里") && dailyQuests[i].progress < dailyQuests[i].target {
                let completedRuns = Int(distanceKm >= 2.0 ? 1 : 0) // 如果跑了2公里以上，完成1次任务
                let newProgress = min(dailyQuests[i].progress + completedRuns, dailyQuests[i].target)
                dailyQuests[i].progress = newProgress
                
                if newProgress == dailyQuests[i].target {
                    // 任务完成，奖励金币
                    addCoins(dailyQuests[i].rewardCoins)
                    print("🎉 每日任务完成：\(dailyQuests[i].title)")
                }
            }
        }
    }
    
    func checkCaloriesQuest(calories: Double) {
        // 检查卡路里相关的每日任务
        for i in 0..<dailyQuests.count {
            if dailyQuests[i].title.contains("大卡") && dailyQuests[i].progress < dailyQuests[i].target {
                let newProgress = min(dailyQuests[i].progress + Int(calories), dailyQuests[i].target)
                dailyQuests[i].progress = newProgress
                
                if newProgress == dailyQuests[i].target {
                    // 任务完成，奖励金币
                    addCoins(dailyQuests[i].rewardCoins)
                    print("🎉 每日任务完成：\(dailyQuests[i].title)")
                }
            }
        }
    }
    
    func checkExperienceQuest(xp: Int) {
        // 检查经验值相关的每日任务
        for i in 0..<dailyQuests.count {
            if dailyQuests[i].title.contains("经验") && dailyQuests[i].progress < dailyQuests[i].target {
                let newProgress = min(dailyQuests[i].progress + xp, dailyQuests[i].target)
                dailyQuests[i].progress = newProgress
                
                if newProgress == dailyQuests[i].target {
                    // 任务完成，奖励金币
                    addCoins(dailyQuests[i].rewardCoins)
                    print("🎉 每日任务完成：\(dailyQuests[i].title)")
                }
            }
        }
    }
}

// MARK: - 自动保存功能扩展
extension UserDataViewModel {
    // 修改：智能保存，支持离线模式
    func updateUserProfile() async {
        guard let userToUpdate = user else {
            print("⚠️ 尝试更新用户资料，但本地无数据。")
            return
        }
        
        // 1. 立即保存到本地缓存
        saveUserDataToCache()
        
        // 2. 尝试同步到云端
        print("💾 正在将本地用户资料同步到 Supabase...")
        do {
            try await SupabaseManager.shared.client
                .from("profiles")
                .update(userToUpdate)
                .eq("id", value: userToUpdate.id)
                .execute()
            print("✅ 用户资料成功同步到云端！")
            
            // 同步成功，清除待同步标记
            LocalStorageManager.shared.clearPendingChanges()
            
        } catch {
            print("❌ 同步用户资料失败: \(error.localizedDescription)")
            
            // 网络失败时，保存待同步的更改
            let pendingChanges: [String: Any] = [
                "user_profile": true,
                "last_attempt": Date().timeIntervalSince1970
            ]
            LocalStorageManager.shared.savePendingChanges(pendingChanges)
            print("💾 已保存待同步的更改，将在网络恢复时重试")
        }
    }
    
    /// 强制从云端刷新数据（用于下拉刷新等场景）
    func forceRefreshFromCloud() async {
        print("🔄 强制从云端刷新用户数据...")
        await fetchCurrentUserProfile()
    }
    
    /// 清除用户数据（用于登出）
    func clearUserData() {
        self.user = nil
        self.isDataFromCache = false
        LocalStorageManager.shared.clearUserData()
        print("🗑️ 已清除用户数据")
    }
}
