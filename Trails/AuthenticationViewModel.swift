//
//  AuthenticationViewModel.swift
//  Trails
//
//  Created by 孟祥伟 on 2025/8/20.
//

import SwiftUI
import AuthenticationServices
import Combine

// 认证视图模型，管理用户登录状态
class AuthenticationViewModel: ObservableObject {
    // 用户是否已认证的状态
    @Published var isUserAuthenticated = false
    
    // 用户登录信息
    @Published var userEmail: String?
    @Published var userName: String?
    
    // 登录状态
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        // 检查用户是否已经登录过
        checkExistingAuthentication()
    }
    
    // 检查是否有现有的认证状态
    private func checkExistingAuthentication() {
        // 从 UserDefaults 中检查用户登录状态
        if UserDefaults.standard.bool(forKey: "isUserAuthenticated") {
            isUserAuthenticated = true
            userEmail = UserDefaults.standard.string(forKey: "userEmail")
            userName = UserDefaults.standard.string(forKey: "userName")
        }
    }
    
    // 处理 Apple 登录结果
    func handleSignInWithApple(result: Result<ASAuthorization, Error>) {
        isLoading = true
        errorMessage = nil
        
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                // 获取用户信息
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                
                // 处理用户信息
                DispatchQueue.main.async {
                    self.isUserAuthenticated = true
                    self.userEmail = email ?? "demo@example.com"
                    
                    // 拼接用户姓名
                    if let fullName = fullName {
                        let firstName = fullName.givenName ?? ""
                        let lastName = fullName.familyName ?? ""
                        self.userName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
                        if self.userName?.isEmpty == true {
                            self.userName = "演示用户"
                        }
                    } else {
                        self.userName = "演示用户"
                    }
                    
                    // 保存登录状态到 UserDefaults
                    UserDefaults.standard.set(true, forKey: "isUserAuthenticated")
                    UserDefaults.standard.set(self.userEmail, forKey: "userEmail")
                    UserDefaults.standard.set(self.userName, forKey: "userName")
                    UserDefaults.standard.set(userIdentifier, forKey: "userIdentifier")
                    
                    self.isLoading = false
                    print("✅ Apple 登录成功: \(self.userName ?? "未知用户")")
                }
            }
            
        case .failure(let error):
            DispatchQueue.main.async {
                self.isLoading = false
                
                // 改进的错误处理
                if let authError = error as? ASAuthorizationError {
                    switch authError.code {
                    case .canceled:
                        self.errorMessage = "登录已取消"
                        print("⚠️ 用户取消了Apple登录")
                    case .unknown:
                        self.errorMessage = "模拟器暂不支持Apple登录，请在真机上测试"
                        print("⚠️ Apple登录错误 - 可能是模拟器限制: \(error)")
                    case .invalidResponse:
                        self.errorMessage = "无效的登录响应"
                        print("❌ Apple登录无效响应: \(error)")
                    case .notHandled:
                        self.errorMessage = "登录请求未被处理"
                        print("❌ Apple登录未处理: \(error)")
                    case .failed:
                        self.errorMessage = "登录失败，请重试"
                        print("❌ Apple登录失败: \(error)")
                    @unknown default:
                        self.errorMessage = "未知登录错误"
                        print("❌ Apple登录未知错误: \(error)")
                    }
                } else {
                    self.errorMessage = "登录失败: \(error.localizedDescription)"
                    print("❌ Apple登录错误: \(error)")
                }
            }
        }
    }
    
    // 模拟器专用登录方法
    func simulatorLogin() {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
            
            // 模拟登录延迟
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isUserAuthenticated = true
                self.userEmail = "simulator@trails.demo"
                self.userName = "模拟器用户"
                
                // 保存登录状态到 UserDefaults
                UserDefaults.standard.set(true, forKey: "isUserAuthenticated")
                UserDefaults.standard.set(self.userEmail, forKey: "userEmail")
                UserDefaults.standard.set(self.userName, forKey: "userName")
                UserDefaults.standard.set("simulator_user", forKey: "userIdentifier")
                
                self.isLoading = false
                print("✅ 模拟器登录成功: \(self.userName ?? "未知用户")")
            }
        }
    }
    
    // 退出登录
    func signOut() {
        DispatchQueue.main.async {
            self.isUserAuthenticated = false
            self.userEmail = nil
            self.userName = nil
            self.errorMessage = nil
            
            // 清除 UserDefaults 中的登录信息
            UserDefaults.standard.removeObject(forKey: "isUserAuthenticated")
            UserDefaults.standard.removeObject(forKey: "userEmail")
            UserDefaults.standard.removeObject(forKey: "userName")
            UserDefaults.standard.removeObject(forKey: "userIdentifier")
            
            print("🔓 用户已退出登录")
        }
    }
}
