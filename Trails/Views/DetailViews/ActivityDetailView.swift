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

               // 4. 新增：实用工具
                VStack(alignment: .leading, spacing: 20) {
                    Text("实用工具")
                        .font(.title2).bold()
                        .padding(.horizontal)
                    
                    // 天气预报
                    WeatherForecastView()
                    
                    // 装备建议
                    GearSuggestionView()
                }
                
                Divider().padding(.horizontal)

                // 5. 游戏化与激励机制
                VStack(alignment: .leading, spacing: 15) {
                    Text("奖励与挑战").font(.title2).bold()
                    HStack {
                        Image(systemName: "sparkles").font(.title).foregroundColor(.yellow)
                        VStack(alignment: .leading) {
                            Text("+\(goal.xpReward) XP").font(.headline).bold()
                            Text("完成本次运动即可获得").font(.caption).foregroundColor(.gray)
                        }
                    }
                    HStack {
                        Image(systemName: "star.circle.fill").font(.title).foregroundColor(.orange)
                        VStack(alignment: .leading) {
                            Text("解锁【公园跑者】").font(.headline).bold()
                            Text("首次完成即可解锁此徽章！").font(.caption).foregroundColor(.gray)
                        }
                    }
                }
                .padding([.horizontal, .bottom])
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)
                
                // 6. 社交元素
                VStack(alignment: .leading, spacing: 20) {
                    Text("社区动态").font(.title2).bold()
                    
                    // 排行榜
                    LeaderboardView()
                    
                    // 用户点评
                    UserReviewView()
                }
                .padding(.horizontal)
                
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

// MARK: - 子视图组件

// --- 天气预报视图 ---
struct WeatherForecastView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("天气预报")
                .font(.headline)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    WeatherCard(time: "现在", icon: "sun.max.fill", temperature: "28°")
                    WeatherCard(time: "1小时后", icon: "cloud.sun.fill", temperature: "27°")
                    WeatherCard(time: "2小时后", icon: "cloud.fill", temperature: "26°")
                    WeatherCard(time: "3小时后", icon: "wind", temperature: "25°")
                }
                .padding(.horizontal)
            }
        }
    }
}

struct WeatherCard: View {
    let time: String
    let icon: String
    let temperature: String
    
    var body: some View {
        VStack {
            Text(time).font(.caption)
            Image(systemName: icon).font(.title2).foregroundColor(.orange).padding(.vertical, 5)
            Text(temperature).font(.headline).bold()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

// --- 装备建议视图 ---
struct GearSuggestionView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("装备建议")
                .font(.headline)
                .padding(.horizontal)
            HStack(spacing: 20) {
                GearItem(icon: "drop.fill", name: "水")
                GearItem(icon: "shoeprints.fill", name: "跑鞋")
                GearItem(icon: "tshirt.fill", name: "速干衣")
                GearItem(icon: "sun.max.fill", name: "防晒")
            }
            .padding(.horizontal)
        }
    }
}

struct GearItem: View {
    let icon: String
    let name: String
    
    var body: some View {
        VStack {
            Image(systemName: icon).font(.title).foregroundColor(.blue)
            Text(name).font(.caption)
        }
        .frame(maxWidth: .infinity)
    }
}

// --- 排行榜视图 ---
struct LeaderboardView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("排行榜").font(.headline)
            LeaderboardRow(rank: 1, name: "伟子哥", time: "25:18")
            LeaderboardRow(rank: 2, name: "用户A", time: "26:05")
            LeaderboardRow(rank: 3, name: "用户B", time: "27:30")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct LeaderboardRow: View {
    let rank: Int
    let name: String
    let time: String
    
    var body: some View {
        HStack {
            Text("\(rank)").fontWeight(.bold)
            Image(systemName: "person.circle.fill").foregroundColor(.gray)
            Text(name)
            Spacer()
            Text(time).font(.headline)
        }
        .padding(.vertical, 5)
    }
}

// --- 用户点评视图 ---
struct UserReviewView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("用户点评与贴士").font(.headline)
            HStack(alignment: .top) {
                Image(systemName: "person.circle.fill").font(.largeTitle).foregroundColor(.gray)
                VStack(alignment: .leading) {
                    Text("用户C").font(.headline)
                    Text("路线很棒，风景优美！不过山顶风大，记得多穿一件衣服。")
                        .font(.subheadline)
                }
            }
        }
    }
}

// MARK: - 预览代码
struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ActivityDetailView(
                activity: .running,
                goal: DailyGoal(intensity: .moderate)
            )
            .environmentObject(UserDataViewModel())
        }
    }
}