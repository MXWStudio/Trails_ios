import SwiftUI

struct PostCardView: View {
    @State var post: CommunityPost
    var onLike: ((CommunityPost) -> Void)?
    var onComment: ((CommunityPost) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            // 顶部用户信息
            HStack {
                Image(systemName: post.userAvatar)
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                VStack(alignment: .leading) {
                    Text(post.userName)
                        .font(.headline)
                    Text(post.relativeTimeString)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding([.horizontal, .top])
            
            // 根据帖子内容类型显示不同视图
            switch post.content {
            case .systemMessage(let title, let description):
                SystemMessageCard(title: title, description: description)
                    .padding([.horizontal, .bottom])
            case .userPost(let content):
                // 传入完整的帖子对象和回调
                UserPostCard(
                    content: content, 
                    post: $post,
                    onLike: { 
                        handleLike()
                    },
                    onComment: { 
                        handleComment() 
                    }
                )
            }
        }
    }
    
    // MARK: - 交互处理
    
    private func handleLike() {
        withAnimation(.easeInOut(duration: 0.2)) {
            post.isLiked.toggle()
            post.likes += post.isLiked ? 1 : -1
        }
        onLike?(post)
    }
    
    private func handleComment() {
        onComment?(post)
    }
}

// --- 子视图：用户发布的帖子样式 (已重构) ---
struct UserPostCard: View {
    let content: UserGeneratedContent
    @Binding var post: CommunityPost
    var onLike: (() -> Void)?
    var onComment: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 封面图片
            Image(content.coverImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 250)
                .cornerRadius(10)
                .clipped()

            // 互动按钮 (移到图片下方)
            HStack(spacing: 20) {
                Button(action: { onLike?() }) { 
                    HStack(spacing: 4) {
                        Image(systemName: post.isLiked ? "flame.fill" : "flame")
                            .foregroundColor(post.isLiked ? .orange : .primary)
                            .scaleEffect(post.isLiked ? 1.1 : 1.0)
                        Text("\(post.likes)")
                            .foregroundColor(.primary)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { onComment?() }) { 
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.left")
                            .foregroundColor(.primary)
                        Text("\(post.comments)")
                            .foregroundColor(.primary)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.primary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .font(.title3)
            
            // 文案和标签
            VStack(alignment: .leading, spacing: 8) {
                Text(content.caption)
                    .lineLimit(3)
                    .font(.body)
                
                // 标签
                if !content.tags.isEmpty {
                    LazyHStack {
                        ForEach(content.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.blue.opacity(0.8))
                                )
                        }
                    }
                }
            }
            
            Divider()
            
            // 运动类型和路线信息 (弱化并放在一行)
            HStack {
                Image(systemName: content.activityType.illustrationName)
                Text(content.activityType.rawValue)
                Spacer()
                Text(content.routeInfo).fontWeight(.bold)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        .padding(.horizontal)
    }
}

// --- 子视图：系统生成的帖子样式 
struct SystemMessageCard: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline).fontWeight(.bold)
            Text(description).font(.body)
        }
        .padding()
    }
}
