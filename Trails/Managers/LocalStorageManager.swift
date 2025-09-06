import Foundation

/// 本地数据存储管理器
/// 负责用户数据的本地缓存，确保应用退出后重新进入时数据不丢失
class LocalStorageManager {
    static let shared = LocalStorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let userDataKey = "saved_user_data"
    private let lastSyncTimeKey = "last_sync_time"
    
    private init() {}
    
    // MARK: - 用户数据本地存储
    
    /// 保存用户数据到本地
    func saveUserData(_ userData: UserData) {
        do {
            let data = try JSONEncoder().encode(userData)
            userDefaults.set(data, forKey: userDataKey)
            userDefaults.set(Date(), forKey: lastSyncTimeKey)
            print("✅ 用户数据已保存到本地缓存")
        } catch {
            print("❌ 保存用户数据到本地失败: \(error.localizedDescription)")
        }
    }
    
    /// 从本地加载用户数据
    func loadUserData() -> UserData? {
        guard let data = userDefaults.data(forKey: userDataKey) else {
            print("ℹ️ 本地没有缓存的用户数据")
            return nil
        }
        
        do {
            let userData = try JSONDecoder().decode(UserData.self, from: data)
            print("✅ 从本地缓存加载用户数据成功")
            return userData
        } catch {
            print("❌ 从本地加载用户数据失败: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// 清除本地用户数据（用于登出）
    func clearUserData() {
        userDefaults.removeObject(forKey: userDataKey)
        userDefaults.removeObject(forKey: lastSyncTimeKey)
        print("🗑️ 已清除本地用户数据缓存")
    }
    
    /// 获取上次同步时间
    func getLastSyncTime() -> Date? {
        return userDefaults.object(forKey: lastSyncTimeKey) as? Date
    }
    
    /// 检查数据是否需要同步（例如：超过5分钟没有同步）
    func shouldSyncWithCloud() -> Bool {
        guard let lastSync = getLastSyncTime() else {
            return true // 从未同步过，需要同步
        }
        
        let timeSinceLastSync = Date().timeIntervalSince(lastSync)
        return timeSinceLastSync > 300 // 5分钟
    }
    
    // MARK: - 应用状态管理
    
    private let isFirstLaunchKey = "is_first_launch"
    
    /// 检查是否是首次启动
    func isFirstLaunch() -> Bool {
        return !userDefaults.bool(forKey: isFirstLaunchKey)
    }
    
    /// 标记已经启动过
    func markFirstLaunchCompleted() {
        userDefaults.set(true, forKey: isFirstLaunchKey)
    }
    
    // MARK: - 离线数据管理
    
    private let pendingChangesKey = "pending_changes"
    
    /// 保存待同步的更改
    func savePendingChanges(_ changes: [String: Any]) {
        var allPendingChanges = getPendingChanges()
        for (key, value) in changes {
            allPendingChanges[key] = value
        }
        userDefaults.set(allPendingChanges, forKey: pendingChangesKey)
        print("💾 已保存待同步的更改到本地")
    }
    
    /// 获取待同步的更改
    func getPendingChanges() -> [String: Any] {
        return userDefaults.dictionary(forKey: pendingChangesKey) ?? [:]
    }
    
    /// 清除待同步的更改
    func clearPendingChanges() {
        userDefaults.removeObject(forKey: pendingChangesKey)
        print("🧹 已清除待同步的更改")
    }
    
    /// 检查是否有待同步的更改
    func hasPendingChanges() -> Bool {
        return !getPendingChanges().isEmpty
    }
}
