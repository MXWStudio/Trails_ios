import SwiftUI
import Foundation

@MainActor // 确保所有对 @Published 属性的修改都在主线程上
class UserDataViewModel: ObservableObject {
    @Published var user: UserData?
    
    // 本地管理的游戏化数据 (未来也可以从 Supabase 加载)
    @Published var achievements: [Achievement] = [] // Achievement.sampleAchievements
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


    // --- Supabase 数据交互 ---
    
    func fetchCurrentUserProfile() async {
        guard let currentUserID = try? await SupabaseManager.shared.client.auth.session.user.id else {
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
            // 如果用户资料不存在，创建一个新的
            await createNewUserProfile(userID: currentUserID)
        }
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
        
        // 异步保存到云端
        saveChanges()
        
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
        saveChanges()
        
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
