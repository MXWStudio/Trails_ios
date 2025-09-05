import SwiftUI
import AuthenticationServices
import Supabase

// 通知名称扩展
extension Notification.Name {
    static let userDidAuthenticate = Notification.Name("userDidAuthenticate")
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var isUserAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // --- 认证流程 ---
    
    // App 启动时自动检查登录状态
    func checkUserSession() async {
        do {
            _ = try await SupabaseManager.shared.client.auth.session
            self.isUserAuthenticated = true
        } catch {
            self.isUserAuthenticated = false
        }
    }
    
    // 处理来自 SwiftUI 按钮的结果
    func handleSignInWithApple(result: Result<ASAuthorization, Error>) {
        self.isLoading = true
        self.errorMessage = nil
        
        switch result {
        case .success(let authorization):
            guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                self.errorMessage = "无法获取 Apple ID 凭证。"
                self.isLoading = false
                return
            }
            
            // 使用 Task 切换到异步上下文
            Task {
                await signInWithSupabase(credential: appleIDCredential)
            }
            
        case .failure(let error):
            self.errorMessage = "Apple 登录失败: \(error.localizedDescription)"
            self.isLoading = false
        }
    }

    // 与 Supabase 进行认证
    private func signInWithSupabase(credential: ASAuthorizationAppleIDCredential) async {
        guard let idTokenData = credential.identityToken,
              let idToken = String(data: idTokenData, encoding: .utf8) else {
            self.errorMessage = "无法从 Apple 获取 ID Token。"
            self.isLoading = false
            return
        }
        
        do {
            try await SupabaseManager.shared.client.auth.signInWithIdToken(
                credentials: .init(provider: .apple, idToken: idToken)
            )
            self.isLoading = false
            self.isUserAuthenticated = true
            
            // 登录成功后，尝试获取或创建用户资料
            NotificationCenter.default.post(name: .userDidAuthenticate, object: nil)
        } catch {
            self.errorMessage = "Supabase 登录失败: \(error.localizedDescription)"
            self.isLoading = false
        }
    }

    // 退出登录
    func signOut() async {
        do {
            try await SupabaseManager.shared.client.auth.signOut()
            self.isUserAuthenticated = false
        } catch {
            self.errorMessage = "退出登录失败: \(error.localizedDescription)"
        }
    }
    
    // --- Email 登录功能 ---
    
    func signInWithEmail(email: String, password: String) async {
        print("🔐 开始邮箱登录流程，邮箱: \(email)")
        self.isLoading = true
        self.errorMessage = nil
        
        // 先测试网络连接（现在修改为更宽松的检查）
        print("🔍 开始网络和配置检查...")
        let connectionOK = await SupabaseManager.shared.testConnection()
        if !connectionOK {
            print("⚠️ 网络预检查失败，但继续尝试直接认证...")
            // 不再直接返回，而是继续尝试认证
        }
        
        // 检查数据库表（也改为更宽松的检查）
        let tableOK = await SupabaseManager.shared.checkProfilesTable()
        if !tableOK {
            print("⚠️ profiles 表检查失败，但继续尝试登录")
        }
        
        do {
            print("🌐 正在连接 Supabase 进行认证...")
            let response = try await SupabaseManager.shared.client.auth.signIn(
                email: email,
                password: password
            )
            print("✅ Supabase 认证成功，用户ID: \(response.user.id)")
            
            self.isLoading = false
            self.isUserAuthenticated = true
            
            // 登录成功后，尝试获取或创建用户资料
            print("📢 发送用户认证成功通知")
            NotificationCenter.default.post(name: .userDidAuthenticate, object: nil)
            print("🎉 邮箱登录流程完成")
        } catch {
            print("❌ 邮箱登录失败: \(error)")
            print("❌ 错误详情: \(error.localizedDescription)")
            
            // 提供更友好的错误信息
            let friendlyMessage: String
            if error.localizedDescription.contains("Invalid login credentials") {
                friendlyMessage = "邮箱或密码不正确，请检查后重试"
            } else if error.localizedDescription.contains("Email not confirmed") {
                friendlyMessage = "邮箱未确认，请检查您的邮箱并点击确认链接，或联系管理员手动确认"
            } else if error.localizedDescription.contains("network") || error.localizedDescription.contains("timeout") {
                friendlyMessage = "网络连接超时，请检查网络后重试"
            } else {
                friendlyMessage = "登录失败: \(error.localizedDescription)"
            }
            
            self.errorMessage = friendlyMessage
            self.isLoading = false
        }
    }
    
    func signUpWithEmail(email: String, password: String) async {
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            try await SupabaseManager.shared.client.auth.signUp(
                email: email,
                password: password
            )
            self.isLoading = false
            self.isUserAuthenticated = true
            
            // 注册成功后，尝试获取或创建用户资料
            NotificationCenter.default.post(name: .userDidAuthenticate, object: nil)
        } catch {
            self.errorMessage = "邮箱注册失败: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
    
    // 重新发送确认邮件
    func resendConfirmationEmail(email: String) async {
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            try await SupabaseManager.shared.client.auth.resend(
                email: email,
                type: .signup
            )
            self.isLoading = false
            self.errorMessage = "确认邮件已重新发送，请检查您的邮箱"
        } catch {
            self.errorMessage = "重新发送邮件失败: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
    
    // --- 开发者功能 ---
    
    // 模拟器跳过登录
    func simulatorLogin() {
        self.isUserAuthenticated = true
    }
}
