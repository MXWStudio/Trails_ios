//
//  LoginView.swift
//  Trails
//
//  Created by 孟祥伟 on 2025/8/20.
//

import SwiftUI
import AuthenticationServices

// 登录视图
struct LoginView: View {
    // 从环境中获取认证视图模型
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    // 定义背景颜色为纯白色
    let backgroundColor = Color.white

    var body: some View {
        ZStack {
            // 设置纯色背景并忽略安全区域
            backgroundColor.ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                // 应用标题
                Text("Trails")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(.black.opacity(0.8))

                Spacer()
                Spacer()

                // 使用 Apple 登录按钮
                SignInWithAppleButton(
                    .signIn,
                    onRequest: { request in
                        // 配置 Apple 登录请求
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: { result in
                        // 处理登录结果
                        authViewModel.handleSignInWithApple(result: result)
                    }
                )
                .signInWithAppleButtonStyle(.black) // 按钮样式
                .frame(height: 55)
                .cornerRadius(12)
                .padding(.horizontal, 40) // 左右边距
                .disabled(authViewModel.isLoading) // 登录时禁用按钮
                
                // 加载指示器
                if authViewModel.isLoading {
                    ProgressView("正在登录...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(0.8)
                        .padding(.top, 10)
                }
                
                // 错误提示
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.top, 10)
                }

                // 法律文本 (链接暂时为空)
                Text("登录即表示您同意我们的用户协议和隐私政策。")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 15)
                
                // 开发者模式 - 仅在模拟器上显示
                #if targetEnvironment(simulator)
                VStack(spacing: 10) {
                    Divider()
                        .padding(.horizontal, 40)
                        .padding(.top, 20)
                    
                    Text("开发者模式")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        // 模拟器跳过登录
                        authViewModel.simulatorLogin()
                    }) {
                        HStack {
                            Image(systemName: "wrench.and.screwdriver")
                            Text("跳过登录 (仅模拟器)")
                        }
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(.top, 10)
                #endif

                Spacer()
            }
        }
    }
}

// SwiftUI 预览
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthenticationViewModel())
    }
}