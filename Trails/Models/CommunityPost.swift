import Foundation

// 社区动态帖子的数据模型
struct CommunityPost: Identifiable {
    let id = UUID()
    let userName: String
    let userAvatar: String // 暂时使用 SF Symbol 名称
    let postType: PostType
    let timestamp: String // e.g., "5分钟前"
    let description: String
    var likes: Int
    var comments: Int
    let activityMapSnapshot: String? // 用于运动记录的地图快照图片名

    enum PostType: String {
        case activity = "完成了一项运动"
        case achievement = "解锁了新成就"
        case levelUp = "升级了！"
    }
}
