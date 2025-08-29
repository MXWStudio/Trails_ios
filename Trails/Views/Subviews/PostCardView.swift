import SwiftUI

struct PostCardView: View {
    let post: CommunityPost
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 顶部用户信息
            HStack {
                Image(systemName: post.userAvatar)
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                VStack(alignment: .leading) {
                    Text(post.userName).font(.headline)
                    Text("\(post.postType.rawValue) · \(post.timestamp)")
                        .font(.caption).foregroundColor(.gray)
                }
            }
            
            // 帖子内容
            Text(post.description)
                .font(.body)
            
            // 如果是运动记录，显示地图快照
            if let mapSnapshot = post.activityMapSnapshot {
                Image(systemName: mapSnapshot)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
                    .cornerRadius(10)
                    .foregroundColor(.secondary)
            }
            
            // 底部互动按钮
            HStack(spacing: 20) {
                Button(action: {}) {
                    Label("\(post.likes)", systemImage: "flame.fill")
                }
                Button(action: {}) {
                    Label("\(post.comments)", systemImage: "bubble.left.fill")
                }
                Spacer()
            }
            .foregroundColor(.secondary)
            
        }
        .padding()
    }
}
