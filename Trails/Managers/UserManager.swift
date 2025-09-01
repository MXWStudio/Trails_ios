import Foundation

/// 用户管理器 - 管理当前登录用户信息
class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @Published var currentUser: User?
    
    private init() {
        // 模拟已登录用户，真实应用中应该从UserDefaults或Keychain读取
        loadCurrentUser()
    }
    
    // MARK: - 用户信息管理
    
    /// 加载当前用户信息
    private func loadCurrentUser() {
        // 模拟用户数据，真实应用中应该从本地存储或网络加载
        self.currentUser = User(
            id: "user_001",
            username: "伟子哥",
            displayName: "伟子哥",
            avatar: "person.crop.circle.fill.badge.checkmark",
            email: "weizige@example.com",
            bio: "热爱运动，享受生活",
            joinDate: Date().addingTimeInterval(-86400 * 365), // 一年前注册
            level: 12,
            totalDistance: 1250.5,
            totalWorkouts: 145
        )
    }
    
    /// 更新用户信息
    func updateUser(_ user: User) {
        self.currentUser = user
        saveUserToLocal(user)
    }
    
    /// 保存用户信息到本地
    private func saveUserToLocal(_ user: User) {
        // TODO: 实现本地存储逻辑
        print("保存用户信息: \(user.username)")
    }
    
    /// 登出
    func logout() {
        self.currentUser = nil
        // TODO: 清除本地存储的用户信息
    }
    
    /// 检查是否已登录
    var isLoggedIn: Bool {
        return currentUser != nil
    }
}

// MARK: - 用户数据模型

struct User: Identifiable, Codable {
    let id: String
    var username: String
    var displayName: String
    var avatar: String // SF Symbol名称或图片URL
    var email: String
    var bio: String
    let joinDate: Date
    var level: Int
    var totalDistance: Double // 总距离（公里）
    var totalWorkouts: Int // 总锻炼次数
    
    /// 格式化的总距离
    var formattedTotalDistance: String {
        return String(format: "%.1f km", totalDistance)
    }
    
    /// 注册时长
    var membershipDuration: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.unitsStyle = .full
        return formatter.localizedString(for: joinDate, relativeTo: Date())
    }
}
