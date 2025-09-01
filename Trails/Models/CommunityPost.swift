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
    let timestamp: String // e.g., "5分钟前"
    var likes: Int
    var comments: Int
    
    // 使用枚举来区分不同类型的帖子内容
    enum PostContent {
        case systemMessage(String, String) // title, description e.g., "升级了！", "升到了12级"
        case userPost(UserGeneratedContent)
    }
    let content: PostContent
}
