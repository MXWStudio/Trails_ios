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
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            try await SupabaseManager.shared.client.auth.signIn(
                email: email,
                password: password
            )
            self.isLoading = false
            self.isUserAuthenticated = true
            
            // 登录成功后，尝试获取或创建用户资料
            NotificationCenter.default.post(name: .userDidAuthenticate, object: nil)
        } catch {
            self.errorMessage = "邮箱登录失败: \(error.localizedDescription)"
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
    
    // --- 开发者功能 ---
    
    // 模拟器跳过登录
    func simulatorLogin() {
        self.isUserAuthenticated = true
    }
}
