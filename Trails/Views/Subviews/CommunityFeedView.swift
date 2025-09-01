import SwiftUI

struct CommunityFeedView: View {
    @State private var showCreatePostView = false
    
    // 更新示例数据以包含新的帖子类型
    @State private var posts: [CommunityPost] = [
        CommunityPost(
            userName: "伟子哥", 
            userAvatar: "person.crop.circle.fill.badge.checkmark", 
            createdAt: Date().addingTimeInterval(-300), // 5分钟前
            likes: 8, 
            comments: 2,
            content: .userPost(UserGeneratedContent(
                coverImage: "hiking_cover_placeholder",
                photos: [],
                caption: "今天天气真好，去公园徒步了一圈，感觉非常放松！推荐大家也去试试。",
                tags: ["#徒步", "#户外", "#放松"],
                activityType: .hiking,
                routeInfo: "5.2 km"
            ))
        ),
        CommunityPost(
            userName: "用户A", 
            userAvatar: "person.crop.circle.fill", 
            createdAt: Date().addingTimeInterval(-3600), // 1小时前
            likes: 25, 
            comments: 8, 
            content: .systemMessage("解锁了新成就！", "解锁了【公园跑者】徽章！")
        ),
        CommunityPost(
            userName: "用户B", 
            userAvatar: "person.crop.circle.fill", 
            createdAt: Date().addingTimeInterval(-86400), // 1天前
            likes: 50, 
            comments: 15, 
            content: .systemMessage("升级了！", "升到了 12 级！")
        )
    ]

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach($posts) { $post in
                        PostCardView(
                            post: post,
                            onLike: { updatedPost in
                                handleLikeAction(for: updatedPost)
                            },
                            onComment: { post in
                                handleCommentAction(for: post)
                            }
                        )
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
    
    // MARK: - 私有方法
    
    /// 添加新帖子到列表顶部
    private func addNewPost(_ newPost: CommunityPost) {
        withAnimation(.easeInOut) {
            posts.insert(newPost, at: 0)
        }
    }
    
    /// 处理点赞操作
    private func handleLikeAction(for updatedPost: CommunityPost) {
        // 在真实应用中，这里应该调用API来同步点赞状态到服务器
        if let index = posts.firstIndex(where: { $0.id == updatedPost.id }) {
            posts[index] = updatedPost
        }
        
        // 提供触觉反馈
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    /// 处理评论操作
    private func handleCommentAction(for post: CommunityPost) {
        // TODO: 实现评论界面
        print("点击了评论按钮，帖子ID: \(post.id)")
        
        // 临时模拟增加评论数
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index].comments += 1
        }
    }
}
