import Foundation
import Network
import Combine

/// 本地数据存储管理器
/// 负责用户数据的本地缓存，确保应用退出后重新进入时数据不丢失
class LocalStorageManager: ObservableObject {
    static let shared = LocalStorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let userDataKey = "saved_user_data"
    private let lastSyncTimeKey = "last_sync_time"
    
    // 网络状态监控
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    @Published var isNetworkAvailable = true
    
    private init() {
        setupNetworkMonitoring()
    }
    
    // MARK: - 网络状态监控
    
    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isNetworkAvailable = path.status == .satisfied
                print("📡 网络状态更新: \(path.status == .satisfied ? "已连接" : "已断开")")
            }
        }
        monitor.start(queue: queue)
    }
    
    /// 检查网络是否可用
    func isNetworkConnected() -> Bool {
        return isNetworkAvailable
    }
    
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
    
    /// 检查数据是否需要同步（例如：超过30分钟没有同步）
    func shouldSyncWithCloud() -> Bool {
        guard let lastSync = getLastSyncTime() else {
            return true // 从未同步过，需要同步
        }
        
        let timeSinceLastSync = Date().timeIntervalSince(lastSync)
        return timeSinceLastSync > 1800 // 30分钟 (增加间隔时间)
    }
    
    /// 检查是否真正需要显示离线提示（更严格的条件）
    func shouldShowOfflineMode() -> Bool {
        // 如果用户选择隐藏离线模式提示，直接返回false
        guard !isOfflineModeHidden() else {
            return false
        }
        
        // 首先检查网络状态
        guard !isNetworkConnected() else {
            return false // 网络正常时不显示离线模式
        }
        
        // 网络断开时，检查数据是否较旧
        guard let lastSync = getLastSyncTime() else {
            return false // 首次使用或没有同步记录时不显示
        }
        
        let timeSinceLastSync = Date().timeIntervalSince(lastSync)
        return timeSinceLastSync > 1800 // 网络断开且超过30分钟没同步才显示离线模式
    }
    
    // MARK: - 应用状态管理
    
    private let isFirstLaunchKey = "is_first_launch"
    private let hideOfflineModeKey = "hide_offline_mode"
    
    /// 检查是否是首次启动
    func isFirstLaunch() -> Bool {
        return !userDefaults.bool(forKey: isFirstLaunchKey)
    }
    
    /// 标记已经启动过
    func markFirstLaunchCompleted() {
        userDefaults.set(true, forKey: isFirstLaunchKey)
    }
    
    /// 检查用户是否选择隐藏离线模式提示
    func isOfflineModeHidden() -> Bool {
        return userDefaults.bool(forKey: hideOfflineModeKey)
    }
    
    /// 设置是否隐藏离线模式提示
    func setHideOfflineMode(_ hidden: Bool) {
        userDefaults.set(hidden, forKey: hideOfflineModeKey)
        print("⚙️ 离线模式提示设置: \(hidden ? "隐藏" : "显示")")
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
