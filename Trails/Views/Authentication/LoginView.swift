import SwiftUI
import AuthenticationServices

// 超时工具扩展
func withTimeout<T>(
    seconds: TimeInterval,
    operation: @escaping () async throws -> T
) async throws -> T {
    try await withThrowingTaskGroup(of: T.self) { group in
        // 添加主要操作
        group.addTask {
            try await operation()
        }
        
        // 添加超时任务
        group.addTask {
            try await Task.sleep(for: .seconds(seconds))
            throw TimeoutError()
        }
        
        // 返回第一个完成的任务结果
        let result = try await group.next()!
        group.cancelAll()
        return result
    }
}

struct TimeoutError: Error {
    let localizedDescription = "操作超时"
}

// 登录视图
struct LoginView: View {
    // 从环境中获取认证视图模型
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    // 定义背景颜色为纯白色
    let backgroundColor = Color.white
    
    // Email 登录状态
    @State private var showEmailLogin = false
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false

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
                
                // Email 登录按钮
                Button(action: {
                    showEmailLogin = true
                }) {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("使用邮箱登录")
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .disabled(authViewModel.isLoading)
                
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
        .sheet(isPresented: $showEmailLogin) {
            EmailLoginView(
                email: $email,
                password: $password,
                isSignUp: $isSignUp,
                authViewModel: authViewModel
            )
        }
    }
}

// Email 登录模态视图
struct EmailLoginView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var isSignUp: Bool
    let authViewModel: AuthenticationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                // 标题
                Text(isSignUp ? "创建账户" : "邮箱登录")
                    .font(.title.bold())
                    .padding(.bottom, 30)
                
                // Email 输入框
                VStack(alignment: .leading, spacing: 8) {
                    Text("邮箱地址")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("请输入邮箱地址", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding(.horizontal, 20)
                
                // 密码输入框
                VStack(alignment: .leading, spacing: 8) {
                    Text("密码")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    SecureField("请输入密码", text: $password)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal, 20)
                
                // 登录/注册按钮
                Button(action: {
                    Task {
                        print("🔘 用户点击登录按钮")
                        
                        do {
                            // 使用withTimeout实现超时机制
                            try await withTimeout(seconds: 30) {
                                if isSignUp {
                                    print("📝 执行注册流程")
                                    await authViewModel.signUpWithEmail(email: email, password: password)
                                } else {
                                    print("🔐 执行登录流程")
                                    await authViewModel.signInWithEmail(email: email, password: password)
                                }
                            }
                            
                            if authViewModel.isUserAuthenticated {
                                print("✅ 登录成功，关闭登录页面")
                                presentationMode.wrappedValue.dismiss()
                            }
                        } catch {
                            print("⏰ 登录超时或失败")
                            await MainActor.run {
                                if authViewModel.isLoading {
                                    authViewModel.isLoading = false
                                    authViewModel.errorMessage = "登录超时，请检查网络连接后重试"
                                }
                            }
                        }
                    }
                }) {
                    Text(isSignUp ? "创建账户" : "登录")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)
                
                // 切换登录/注册模式
                Button(action: {
                    isSignUp.toggle()
                }) {
                    Text(isSignUp ? "已有账户？点击登录" : "没有账户？点击注册")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)
                
                // 错误提示
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    
                    // 如果是邮箱未确认错误，显示重新发送按钮
                    if errorMessage.contains("邮箱未确认") {
                        Button(action: {
                            // TODO: 实现重新发送确认邮件功能
                            print("重新发送确认邮件功能待实现")
                        }) {
                            Text("重新发送确认邮件")
                                .font(.footnote)
                                .foregroundColor(.blue)
                                .padding(.top, 5)
                        }
                        .disabled(authViewModel.isLoading)
                    }
                }
                
                if authViewModel.isLoading {
                    ProgressView("处理中...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(0.8)
                        .padding(.top, 10)
                }
                
                Spacer()
            }
            .navigationTitle("")
            .navigationBarItems(
                trailing: Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}
