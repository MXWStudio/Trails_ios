import SwiftUI

struct PostCardView: View {
    let post: CommunityPost
    
    var body: some View {
        VStack(alignment: .leading) {
            // 顶部用户信息
            HStack {
                Image(systemName: post.userAvatar).font(.largeTitle).foregroundColor(.gray)
                VStack(alignment: .leading) {
                    Text(post.userName).font(.headline)
                    Text(post.timestamp).font(.caption).foregroundColor(.gray)
                }
            }
            .padding([.horizontal, .top])
            
            // 根据帖子内容类型显示不同视图
            switch post.content {
            case .systemMessage(let title, let description):
                SystemMessageCard(title: title, description: description)
            case .userPost(let content):
                UserPostCard(content: content)
            }
            
            // 底部互动按钮
            HStack(spacing: 20) {
                Button(action: {}) { Label("\(post.likes)", systemImage: "flame.fill") }
                Button(action: {}) { Label("\(post.comments)", systemImage: "bubble.left.fill") }
                Spacer()
            }
            .foregroundColor(.secondary)
            .padding([.horizontal, .bottom])
        }
    }
}
// --- 子视图：用户发布的帖子样式 ---
struct UserPostCard: View {
    let content: UserGeneratedContent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 封面图片 (如果图片不存在，使用彩色占位符)
            ZStack {
                // 彩色背景占位符
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [content.activityType.themeColor.opacity(0.6), content.activityType.themeColor]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 200)
                    .cornerRadius(10)
                
                // 运动图标叠加
                VStack {
                    Image(systemName: content.activityType.illustrationName)
                        .font(.system(size: 50))
                        .foregroundColor(.white.opacity(0.8))
                    Text(content.activityType.rawValue)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }

            // 文案
            Text(content.caption)
                .font(.body)
            
            // 标签
            HStack {
                ForEach(content.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
            }
            
            // 运动类型和路线信息
            HStack {
                Label(content.activityType.rawValue, systemImage: content.activityType.illustrationName)
                Spacer()
                Text(content.routeInfo).fontWeight(.bold)
            }
            .font(.subheadline)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

// --- 子视图：系统生成的帖子样式 ---
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
