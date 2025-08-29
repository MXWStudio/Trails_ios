import SwiftUI

struct LeaderboardPageView: View {
    // 临时的示例数据
    @State private var rankedUsers: [RankedUser] = [
        RankedUser(rank: 1, name: "伟子哥", avatar: "person.crop.circle.fill.badge.checkmark", xp: 31946),
        RankedUser(rank: 2, name: "用户B", avatar: "person.crop.circle.fill", xp: 28500),
        RankedUser(rank: 3, name: "用户A", avatar: "person.crop.circle.fill", xp: 25100)
    ]

    var body: some View {
        List {
            ForEach(rankedUsers) { user in
                HStack(spacing: 15) {
                    Text("\(user.rank)").font(.headline).fontWeight(.bold)
                    Image(systemName: user.avatar).font(.largeTitle).foregroundColor(.gray)
                    VStack(alignment: .leading) {
                        Text(user.name).font(.headline)
                        Text("\(user.xp) XP").font(.subheadline).foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 5)
            }
        }
    }
}


// ===================================================================
// MARK: - 预览代码
// ===================================================================
struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}
