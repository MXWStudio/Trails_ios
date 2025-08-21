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
                    
                    // 关注/关注者
                    HStack {
                        VStack { Text("\(userDataVM.user.followers)").bold(); Text("关注") }
                        Spacer()
                        VStack { Text("\(userDataVM.user.following)").bold(); Text("关注者") }
                        Spacer()
                        Button("+ 添加好友") {}
                    }
                    .padding(.horizontal)
                    
                    // 概览
                    VStack(alignment: .leading) {
                        Text("概览").font(.headline).padding(.horizontal)
                        HStack {
                            StatCard(value: "\(userDataVM.user.streakDays)", name: "打卡天数", icon: "flame.fill", color: .orange)
                            StatCard(value: "\(userDataVM.user.totalXP)", name: "经验", icon: "sparkle", color: .yellow)
                            StatCard(value: userDataVM.user.league, name: "段位", icon: "shield.fill", color: .red)
                        }
                    }.padding(.horizontal)
                    
                    // 成就
                    VStack(alignment: .leading) {
                        Text("成就").font(.headline).padding(.horizontal)
                        // ... 成就徽章的横向滚动视图 ...
                    }
                    
                    // 个人数据编辑按钮
                    Button("编辑个人资料") { isEditingProfile = true }
                }
            }
            .navigationTitle("个人资料")
            .navigationBarHidden(true)
            .sheet(isPresented: $isEditingProfile) {
                EditProfileView()
            }
        }
    }
}
// MARK: - 预览
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthenticationViewModel())
    }
}
