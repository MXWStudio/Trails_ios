import SwiftUI
import MapKit


struct ActivityDetailView: View {
    let activity: ActivityType
    let goal: DailyGoal
    
    @State private var showActivityView = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 1. 顶部主视觉 - 交互式地图
                Map() // 这是一个占位符，之后可以配置得更详细
                    .frame(height: 300)
                    .cornerRadius(15)
                    .padding(.horizontal)

                // 2. 标题和简介
                VStack(alignment: .leading, spacing: 5) {
                    Text(activity.rawValue)
                        .font(.largeTitle).bold()
                    Text("经典的城市公园路线，适合放松心情。")
                        .font(.subheadline).foregroundColor(.gray)
                }
                .padding(.horizontal)

                // 3. 核心运动信息
                HStack {
                    InfoCardView(icon: "arrow.left.arrow.right", value: "5.2 km", label: "距离")
                    InfoCardView(icon: "clock.fill", value: "~45 min", label: "预计用时")
                    InfoCardView(icon: "chart.bar.fill", value: goal.intensity.rawValue, label: "难度")
                }
                .padding(.horizontal)

                Divider().padding(.horizontal)

                // 4. 游戏化与激励机制
                VStack(alignment: .leading, spacing: 15) {
                    Text("奖励与挑战")
                        .font(.title2).bold()
                    
                    // XP 奖励
                    HStack {
                        Image(systemName: "sparkles")
                            .font(.title)
                            .foregroundColor(.yellow)
                        VStack(alignment: .leading) {
                            Text("+\(goal.xpReward) XP")
                                .font(.headline).bold()
                            Text("完成本次运动即可获得")
                                .font(.caption).foregroundColor(.gray)
                        }
                    }
                    
                    // 关联成就
                    HStack {
                        Image(systemName: "star.circle.fill")
                            .font(.title)
                            .foregroundColor(.orange)
                        VStack(alignment: .leading) {
                            Text("解锁【公园跑者】")
                                .font(.headline).bold()
                            Text("首次完成即可解锁此徽章！")
                                .font(.caption).foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)
                
                // 5. 社交元素 (占位符)
                VStack(alignment: .leading, spacing: 15) {
                    Text("好友动态")
                        .font(.title2).bold()
                    Text("你的好友 A 和 B 上周也完成了这项运动。")
                        .font(.subheadline)
                }
                .padding(.horizontal)
                
                // 增加一些底部空间，防止被悬浮按钮遮挡
                Spacer(minLength: 100)
            }
        }
        .navigationTitle(activity.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .bottom) // 让悬浮按钮可以贴近底部
        .overlay(
            // 悬浮的“开始运动”按钮
            Button(action: {
                showActivityView = true
            }) {
                Text("开始运动")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(activity.themeColor)
                    .foregroundColor(.white)
                    .cornerRadius(18)
                    .shadow(radius: 5)
            }
            .padding()
            .fullScreenCover(isPresented: $showActivityView) {
                ActivityView(goal: goal)
            }
            , alignment: .bottom
        )
    }
}

