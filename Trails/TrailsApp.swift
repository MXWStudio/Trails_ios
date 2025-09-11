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
