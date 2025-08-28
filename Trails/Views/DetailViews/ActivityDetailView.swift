import SwiftUI

// --- 卡片点击后跳转的详情页 ---
struct ActivityDetailView: View {
    let activity: ActivityType
    let goal: DailyGoal
    
    var body: some View {
        VStack {
            Text("\(activity.rawValue) 详情页")
                .font(.largeTitle)
            
            // 在这里显示经验系统
            VStack(alignment: .leading, spacing: 15) {
                Text("完成目标可获得：")
                    .font(.headline)
                Label("经验奖励: \(goal.xpReward) XP", systemImage: "sparkles")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .padding(.top, 20)
            
            Spacer()
        }
        .navigationTitle(activity.rawValue)
    }
}