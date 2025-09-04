import SwiftUI
import AuthenticationServices
// import Supabase // 如需使用 Supabase，请先在项目中添加 Supabase 依赖

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var isUserAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // --- 认证流程 ---
    
    // App 启动时自动检查登录状态
    func checkUserSession() async {
        // 暂时注释掉 Supabase 相关代码
        /*
        do {
            _ = try await SupabaseManager.shared.client.auth.session
            self.isUserAuthenticated = true
        } catch {
            self.isUserAuthenticated = false
        }
        */
        
        // 临时实现：检查本地存储的登录状态
        self.isUserAuthenticated = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
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
        
        // 暂时注释掉 Supabase 相关代码
        /*
        do {
            try await SupabaseManager.shared.client.auth.signInWithIdToken(
                credentials: .init(provider: .apple, idToken: idToken)
            )
            self.isLoading = false
            self.isUserAuthenticated = true
        } catch {
            self.errorMessage = "Supabase 登录失败: \(error.localizedDescription)"
            self.isLoading = false
        }
        */
        
        // 临时实现：直接设置为已登录
        self.isLoading = false
        self.isUserAuthenticated = true
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
    }

    // 退出登录
    func signOut() async {
        // 暂时注释掉 Supabase 相关代码
        /*
        do {
            try await SupabaseManager.shared.client.auth.signOut()
            self.isUserAuthenticated = false
        } catch {
            self.errorMessage = "退出登录失败: \(error.localizedDescription)"
        }
        */
        
        // 临时实现：清除本地登录状态
        self.isUserAuthenticated = false
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
    }
    
    // --- Email 登录功能 ---
    
    func signInWithEmail(email: String, password: String) async {
        self.isLoading = true
        self.errorMessage = nil
        
        // 暂时注释掉 Supabase 相关代码
        /*
        do {
            try await SupabaseManager.shared.client.auth.signIn(
                email: email,
                password: password
            )
            self.isLoading = false
            self.isUserAuthenticated = true
        } catch {
            self.errorMessage = "邮箱登录失败: \(error.localizedDescription)"
            self.isLoading = false
        }
        */
        
        // 临时实现：模拟网络延迟和登录成功
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1秒延迟
        self.isLoading = false
        if email.contains("@") && password.count >= 6 {
            self.isUserAuthenticated = true
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        } else {
            self.errorMessage = "邮箱格式不正确或密码过短"
        }
    }
    
    func signUpWithEmail(email: String, password: String) async {
        self.isLoading = true
        self.errorMessage = nil
        
        // 暂时注释掉 Supabase 相关代码
        /*
        do {
            try await SupabaseManager.shared.client.auth.signUp(
                email: email,
                password: password
            )
            self.isLoading = false
            self.isUserAuthenticated = true
        } catch {
            self.errorMessage = "邮箱注册失败: \(error.localizedDescription)"
            self.isLoading = false
        }
        */
        
        // 临时实现：模拟注册成功
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1秒延迟
        self.isLoading = false
        if email.contains("@") && password.count >= 6 {
            self.isUserAuthenticated = true
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        } else {
            self.errorMessage = "邮箱格式不正确或密码过短"
        }
    }
    
    // --- 开发者功能 ---
    
    // 模拟器跳过登录
    func simulatorLogin() {
        self.isUserAuthenticated = true
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
    }
}
