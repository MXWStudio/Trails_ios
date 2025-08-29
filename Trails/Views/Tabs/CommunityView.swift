import SwiftUI

struct CommunityView: View {
    // 使用一个枚举来管理顶部的选择器状态
    enum CommunityTab {
        case feed
        case leaderboard
    }
    
    @State private var selectedTab: CommunityTab = .feed

    var body: some View {
        NavigationView {
            VStack {
                // 1. 顶部切换器
                Picker("选择内容", selection: $selectedTab) {
                    Text("好友动态").tag(CommunityTab.feed)
                    Text("排行榜").tag(CommunityTab.leaderboard)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                // 2. 根据选择显示不同内容
                switch selectedTab {
                case .feed:
                    CommunityFeedView()
                case .leaderboard:
                    LeaderboardPageView()
                }
                
                Spacer()
            }
            .navigationTitle("社区")
            .navigationBarItems(trailing: Button(action: {
                // TODO: 实现添加好友功能
            }) {
                Image(systemName: "person.badge.plus")
                    .font(.title2)
            })
        }
    }
}
