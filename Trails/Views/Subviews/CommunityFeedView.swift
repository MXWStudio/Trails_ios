import SwiftUI

struct CommunityFeedView: View {
    @State private var showCreatePostView = false
    
    // 更新示例数据以包含新的帖子类型
    @State private var posts: [CommunityPost] = [
        CommunityPost(
            userName: "伟子哥", userAvatar: "person.crop.circle.fill.badge.checkmark", timestamp: "刚刚", likes: 8, comments: 2,
            content: .userPost(UserGeneratedContent(
                coverImage: "hiking_cover_placeholder", // 确保你在 Assets 中有这张图
                photos: [],
                caption: "今天天气真好，去公园徒步了一圈，感觉非常放松！推荐大家也去试试。",
                tags: ["#徒步", "#户外", "#放松"],
                activityType: .hiking,
                routeInfo: "5.2 km"
            ))
        ),
        CommunityPost(userName: "用户A", userAvatar: "person.crop.circle.fill", timestamp: "1小时前", likes: 25, comments: 8, content: .systemMessage("解锁了新成就！", "解锁了【公园跑者】徽章！")),
        CommunityPost(userName: "用户B", userAvatar: "person.crop.circle.fill", timestamp: "昨天", likes: 50, comments: 15, content: .systemMessage("升级了！", "升到了 12 级！"))
    ]

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(posts) { post in
                        PostCardView(post: post)
                        Divider()
                    }
                }
            }
            
            // 新增：发布动态的悬浮按钮
            Button(action: { showCreatePostView = true }) {
                Image(systemName: "plus")
                    .font(.title.weight(.semibold))
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 4, x: 0, y: 4)
            }
            .padding()
            .sheet(isPresented: $showCreatePostView) {
                CreatePostView { newPost in
                    addNewPost(newPost)
                }
            }
        }
    }
    
    // 添加新帖子到列表顶部
    private func addNewPost(_ newPost: CommunityPost) {
        posts.insert(newPost, at: 0)
    }
}
