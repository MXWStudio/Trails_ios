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
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                // 用户头像
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .padding()
                
                // 用户信息部分
                VStack(spacing: 8) {
                    // 用户姓名
                    Text(authViewModel.userName ?? "用户")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    // 用户邮箱
                    Text(authViewModel.userEmail ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                Spacer()
                
                // 退出登录按钮
                Button(action: {
                    authViewModel.signOut()
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("退出登录")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
            .navigationTitle("个人")
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
