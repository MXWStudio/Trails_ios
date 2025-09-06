import SwiftUI
import CoreLocation

@main
struct TrailsApp: App {
    @StateObject private var authViewModel = AuthenticationViewModel()
    @StateObject private var motionManager = MotionManager()
    @StateObject private var userDataViewModel = UserDataViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
                .environmentObject(motionManager)
                .environmentObject(userDataViewModel)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var userDataViewModel: UserDataViewModel
    @State private var isCheckingSession = true
    
    var body: some View {
        ZStack {
            if isCheckingSession {
                // 启动加载动画
                VStack(spacing: 20) {
                    Image(systemName: "figure.walk.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                        .scaleEffect(isCheckingSession ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isCheckingSession)
                    
                    Text("Trails")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("正在检查登录状态...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ProgressView()
                        .tint(.blue)
                }
                .background(Color(.systemBackground))
            } else {
                // 检查完成后显示主界面或登录界面
                if authViewModel.isUserAuthenticated {
                    MainNavigationView()
                } else {
                    LoginView()
                }
            }
        }
        .task {
            // App 启动时检查用户是否已经登录，实现自动登录
            await authViewModel.checkUserSession()
            
            // 添加延迟以确保加载动画有足够时间显示
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1秒
            
            // 检查完成后，隐藏加载动画
            withAnimation(.easeInOut(duration: 0.5)) {
                isCheckingSession = false
            }
        }
    }
}
