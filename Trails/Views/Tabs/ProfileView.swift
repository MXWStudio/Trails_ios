//
//  ProfileView.swift
//  Trails
//
//  Created by 孟祥伟 on 2025/8/20.
//

import SwiftUI

/// 个人资料视图 - 用户信息管理和个人设置
/// 
/// 这个视图提供个人账户管理功能：
/// - 显示当前登录用户的基本信息
/// - 提供账户设置和偏好管理
/// - 支持安全的退出登录功能
/// - 展示用户头像和个人资料
/// 
/// 界面特色：
/// - 蓝色主题设计，与用户头像色彩呼应
/// - 清晰的信息层次，突出重要功能
/// - 安全的账户管理操作
/// 
/// 依赖：
/// - 需要 AuthenticationViewModel 来管理用户状态
/// - 使用 @EnvironmentObject 接收认证状态
struct ProfileView: View {
    @EnvironmentObject var userDataVM: UserDataViewModel
    @State private var isEditingProfile = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 顶部蓝色背景部分
                    VStack {
                        Image(systemName: "person.crop.circle.fill") // 头像占位符
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                        Text(userDataVM.user.name).font(.title).bold().foregroundColor(.white)
                        Text("@username · \(userDataVM.user.joinYear) 年加入").foregroundColor(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    
                    // 新增：伙伴家园入口
                    NavigationLink(destination: IPHomeView()) {
                        VStack(spacing: 10) {
                            // 使用伙伴的外观
                            Image(systemName: userDataVM.user.companion.appearanceName)
                                .font(.system(size: 60))
                                .foregroundColor(.orange)
                            
                            Text("\(userDataVM.user.companion.name)的家")
                                .font(.title2).bold()
                            
                            Text("等级: \(userDataVM.user.companion.level)")
                                .font(.headline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.orange.opacity(0.2))
                                .cornerRadius(10)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(20)
                    }
                    .foregroundColor(.primary) // 保证 NavigationLink 样式正常
                    .padding(.horizontal)
                    
                    // 关注/关注者
                    HStack {
                        Spacer()
                        VStack { Text("\(userDataVM.user.followers)").bold(); Text("关注") }
                        Spacer()
                        VStack { Text("\(userDataVM.user.following)").bold(); Text("关注者") }
                        Spacer()
                        Button("+ 添加好友") {}
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // 新增：生命日志入口
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
                    
                    // 新增：小队挑战入口 (如果有小队的话)
                    if let team = userDataVM.user.team {
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
                    VStack(alignment: .leading) {
                        Text("概览").font(.headline).padding(.horizontal)
                        HStack {
                            StatCard(value: "\(userDataVM.user.streakDays)", name: "打卡天数", icon: "flame.fill", color: .orange)
                            StatCard(value: "\(userDataVM.user.totalXP)", name: "经验", icon: "sparkle", color: .yellow)
                            StatCard(value: "\(userDataVM.user.league)", name: "段位", icon: "shield.fill", color: .red)
                        }
                    }.padding(.horizontal)
                    
                    // 成就
                    VStack(alignment: .leading) {
                        Text("成就").font(.headline).padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(userDataVM.achievements.prefix(6)) { achievement in
                                    VStack {
                                        Image(systemName: achievement.iconName)
                                            .font(.title2)
                                            .foregroundColor(achievement.isUnlocked ? .yellow : .gray)
                                            .frame(width: 60, height: 60)
                                            .background(
                                                Circle()
                                                    .fill(achievement.isUnlocked ? Color.yellow.opacity(0.2) : Color.gray.opacity(0.2))
                                            )
                                        
                                        Text(achievement.title)
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                            .frame(width: 60)
                                    }
                                    .opacity(achievement.isUnlocked ? 1.0 : 0.5)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // 个人数据编辑按钮
                    Button("编辑个人资料") { isEditingProfile = true }
                        .padding(.horizontal)
                }
            }
            .navigationTitle("个人资料")
            .navigationBarHidden(true)
            .sheet(isPresented: $isEditingProfile) {
                // 修复：需要将 UserDataViewModel 传递给编辑视图
                EditProfileView()
                    .environmentObject(userDataVM)
            }
        }
    }
}
// MARK: - 预览
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthenticationViewModel())
            .environmentObject(UserDataViewModel())
    }
}
