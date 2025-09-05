import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userDataVM: UserDataViewModel
    // 新增：获取认证管理器，以便传递给子视图
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    @State private var isEditingProfile = false
    @State private var showLogoutAlert = false
    @State private var avatarImage: UIImage? = nil
    
    var body: some View {
        NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        // 顶部蓝色背景
                        VStack {
                            // 头像显示 - 优先显示本地选择的头像，然后是网络头像
                            if let avatarImage = avatarImage {
                                Image(uiImage: avatarImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            } else if let avatarURL = userDataVM.user?.avatarURL, !avatarURL.isEmpty, !avatarURL.hasPrefix("local_avatar_") {
                                AsyncImage(url: URL(string: avatarURL)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Image(systemName: "person.crop.circle.fill")
                                        .font(.system(size: 80))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.white)
                            }
                            
                            // 使用可选绑定，防止在数据加载完成前访问 user 导致崩溃
                            if let user = userDataVM.user {
                                Text(user.name).font(.title).bold().foregroundColor(.white)
                                
                                // 个人信息显示：年龄-加入年份-称号
                                HStack(spacing: 4) {
                                    // 年龄
                                    if let age = user.age {
                                        Text("\(age)岁")
                                    }
                                    
                                    // 分隔符
                                    if user.age != nil {
                                        Text("·")
                                    }
                                    
                                    // 加入年份
                                    Text("\(user.joinYear)年加入")
                                    
                                    // 自定义称号
                                    if let customTitle = user.customTitle, !customTitle.isEmpty {
                                        Text("·")
                                        Text("@\(customTitle)")
                                    }
                                }
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            } else {
                                Text("加载中...").foregroundColor(.white.opacity(0.8))
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
                        
                        // 伙伴IP系统入口
                        NavigationLink(destination: IPHomeView().environmentObject(userDataVM)) {
                            HStack {
                                Image(systemName: userDataVM.user?.companion.appearanceName ?? "pawprint.fill")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                                VStack(alignment: .leading) {
                                    Text("我的伙伴")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text(userDataVM.user?.companion.name ?? "小伙伴")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("等级 \(userDataVM.user?.companion.level ?? 1)")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)

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
                           // 第一行：经验、打卡天数、段位
                           HStack {
                              StatCard(value: "\(user.totalXP)", name: "经验", icon: "sparkle", color: .yellow)
                              StatCard(value: "\(user.streakDays)", name: "打卡天数", icon: "flame.fill", color: .orange)
                              StatCard(value: user.league, name: "段位", icon: "shield.fill", color: .red)
                           }
                           
                           // 第二行：身体数据
                           HStack {
                               if let height = user.heightCM {
                                   StatCard(value: String(format: "%.0f", height), name: "身高(cm)", icon: "ruler", color: .cyan)
                               } else {
                                   StatCard(value: "--", name: "身高(cm)", icon: "ruler", color: .gray)
                               }
                               
                               StatCard(value: String(format: "%.1f", user.weightKG), name: "体重(kg)", icon: "scalemass", color: .green)
                               
                               if let height = user.heightCM {
                                   let bmi = user.weightKG / ((height/100) * (height/100))
                                   StatCard(value: String(format: "%.1f", bmi), name: "BMI", icon: "heart.circle", color: .pink)
                               } else {
                                   StatCard(value: "--", name: "BMI", icon: "heart.circle", color: .gray)
                               }
                           }
                       }.padding(.horizontal)
                    }
                    
                        // 成就
                        VStack(alignment: .leading) {
                            Text("成就").font(.headline).padding(.horizontal)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(userDataVM.achievements.prefix(6)) { achievement in
                                        VStack {
                                            Image(systemName: achievement.iconName)
                                                .font(.largeTitle)
                                                .foregroundColor(achievement.isUnlocked ? .yellow : .gray)
                                            Text(achievement.title)
                                                .font(.caption)
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(achievement.isUnlocked ? .primary : .gray)
                                        }
                                        .frame(width: 80, height: 80)
                                        .background(achievement.isUnlocked ? Color.yellow.opacity(0.1) : Color.gray.opacity(0.1))
                                        .cornerRadius(12)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        // 设置选项
                        VStack(spacing: 10) {
                            // 个人数据编辑按钮
                            Button("编辑个人资料") { isEditingProfile = true }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .padding(.horizontal)
                            
                            // 登出按钮
                            Button("退出登录") { showLogoutAlert = true }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                        
                        // 底部间距，避免与导航栏重叠
                        Spacer().frame(height: 100)
                    }
                }
                .navigationTitle("个人资料")
                .navigationBarHidden(true)
                .sheet(isPresented: $isEditingProfile) {
                    EditProfileView(onAvatarUpdated: { newAvatar in
                        avatarImage = newAvatar
                    })
                        .environmentObject(userDataVM)
                        // 修改：将 authViewModel 也传递给编辑页面
                        .environmentObject(authViewModel)
                }
                .alert("确认退出", isPresented: $showLogoutAlert) {
                    Button("取消", role: .cancel) {}
                    Button("退出", role: .destructive) {
                        Task {
                            await authViewModel.signOut()
                        }
                    }
                } message: {
                    Text("退出登录后需要重新登录才能使用应用")
                }
        }
    }
}
