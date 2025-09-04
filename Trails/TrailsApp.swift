import SwiftUI

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
    
    var body: some View {
        VStack {
            if authViewModel.isUserAuthenticated {
                MainNavigationView()
                    .task {
                        // 登录成功后，立刻去获取用户的个人资料
                        await userDataViewModel.fetchCurrentUserProfile()
                    }
            } else {
                LoginView()
            }
        }
        .task {
            // App 启动时检查用户是否已经登录，实现自动登录
            await authViewModel.checkUserSession()
        }
    }
}
