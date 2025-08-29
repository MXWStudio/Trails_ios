import SwiftUI

struct CommunityFeedView: View {
    // 临时的示例数据
    @State private var posts: [CommunityPost] = [
        CommunityPost(userName: "伟子哥", userAvatar: "person.crop.circle.fill.badge.checkmark", postType: .activity, timestamp: "5分钟前", description: "完成了 5.2 公里的跑步，获得了 75 XP！", likes: 12, comments: 3, activityMapSnapshot: "map.fill"),
        CommunityPost(userName: "用户A", userAvatar: "person.crop.circle.fill", postType: .achievement, timestamp: "1小时前", description: "解锁了【公园跑者】徽章！", likes: 25, comments: 8, activityMapSnapshot: nil),
        CommunityPost(userName: "用户B", userAvatar: "person.crop.circle.fill", postType: .levelUp, timestamp: "昨天", description: "升到了 12 级！", likes: 50, comments: 15, activityMapSnapshot: nil)
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(posts) { post in
                    PostCardView(post: post)
                    Divider()
                }
            }
        }
    }
}
