import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userDataVM: UserDataViewModel
    // 新增：获取认证管理器，以便传递给子视图
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    @State private var isEditingProfile = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 顶部蓝色背景
                    VStack {
                        Image(systemName: "person.crop.circle.fill").font(.system(size: 80)).foregroundColor(.white)
                        // 使用可选绑定，防止在数据加载完成前访问 user 导致崩溃
                        if let user = userDataVM.user {
                            Text(user.name).font(.title).bold().foregroundColor(.white)
                            Text("@username · \(user.joinYear) 年加入").foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .frame(maxWidth: .infinity).padding().background(Color.blue)

                    // 关注/关注者
                    if let user = userDataVM.user {
                        HStack {
                            Spacer()
                            VStack { Text("\(user.followers)").bold(); Text("关注") }
                            Spacer()
                            VStack { Text("\(user.following)").bold(); Text("关注者") }
                            Spacer()
                            Button("+ 添加好友") {}
                            Spacer()
                        }
                        .padding(.horizontal)
                    }

                    // 生命日志入口
                    VStack(alignment: .leading) {
                        Text("生命日志").font(.headline).padding(.horizontal)
                        HStack {
                            NavigationLink(destination: FootprintMapView()) {
                                StatCard(value: "足迹", name: "地图", icon: "map.fill", color: .green)
                            }
                            NavigationLink(destination: FirstsCollectionView()) {
                               StatCard(value: "我的", name: "第一次", icon: "rosette", color: .purple)
                            }
                        }
                    }.padding(.horizontal)
                    
                    // 小队挑战入口
                    if let team = userDataVM.user?.team {
                        NavigationLink(destination: TeamView(team: team)) {
                            VStack(alignment: .leading) {
                                Text(team.name).font(.headline)
                                Text("本周目标：\(team.weeklyProgress)/\(team.weeklyGoal) 次运动").font(.subheadline)
                                ProgressView(value: Double(team.weeklyProgress), total: Double(team.weeklyGoal))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(20)
                        }
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                    }
                    
                    // 概览
                    if let user = userDataVM.user {
                        VStack(alignment: .leading) {
                           Text("概览").font(.headline).padding(.horizontal)
                           HStack {
                              StatCard(value: "\(user.totalXP)", name: "经验", icon: "sparkle", color: .yellow)
                              StatCard(value: "\(user.streakDays)", name: "打卡天数", icon: "flame.fill", color: .orange)
                              StatCard(value: user.league, name: "段位", icon: "shield.fill", color: .red)
                           }
                       }.padding(.horizontal)
                    }
                    
                    // 成就
                    VStack(alignment: .leading) {
                        Text("成就").font(.headline).padding(.horizontal)
                        // ... 成就徽章的横向滚动视图 ...
                    }

                    // 个人数据编辑按钮
                    Button("编辑个人资料") { isEditingProfile = true }
                        .padding(.horizontal)
                }
            }
            .navigationTitle("个人资料")
            .navigationBarHidden(true)
            .sheet(isPresented: $isEditingProfile) {
                EditProfileView()
                    .environmentObject(userDataVM)
                    // 修改：将 authViewModel 也传递给编辑页面
                    .environmentObject(authViewModel)
            }
        }
    }
}
