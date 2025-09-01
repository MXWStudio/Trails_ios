import Foundation

// 新增：定义用户生成的帖子内容
struct UserGeneratedContent {
    let coverImage: String // 使用 assets 中的图片名
    let photos: [String]
    let caption: String
    let tags: [String]
    let activityType: ActivityType
    let routeInfo: String // 例如 "5.2 km"
}

// 社区动态帖子的数据模型 (已重构)
struct CommunityPost: Identifiable {
    let id = UUID()
    let userName: String
    let userAvatar: String // 暂时使用 SF Symbol 名称
    let createdAt: Date // 改为使用 Date 类型
    var likes: Int
    var comments: Int
    var isLiked: Bool = false // 新增：当前用户是否已点赞
    
    // 使用枚举来区分不同类型的帖子内容
    enum PostContent {
        case systemMessage(String, String) // title, description e.g., "升级了！", "升到了12级"
        case userPost(UserGeneratedContent)
    }
    let content: PostContent
    
    // 计算属性：获取相对时间显示
    var relativeTimeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.unitsStyle = .short
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }
    
    // 便利初始化器，支持旧的 timestamp 参数
    init(userName: String, userAvatar: String, timestamp: String, likes: Int, comments: Int, content: PostContent) {
        self.userName = userName
        self.userAvatar = userAvatar
        self.createdAt = Date() // 新帖子使用当前时间
        self.likes = likes
        self.comments = comments
        self.content = content
    }
    
    // 新的初始化器，直接使用 Date
    init(userName: String, userAvatar: String, createdAt: Date, likes: Int, comments: Int, content: PostContent, isLiked: Bool = false) {
        self.userName = userName
        self.userAvatar = userAvatar
        self.createdAt = createdAt
        self.likes = likes
        self.comments = comments
        self.content = content
        self.isLiked = isLiked
    }
}
