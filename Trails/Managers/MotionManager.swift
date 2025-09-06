import Foundation
import CoreLocation

@MainActor
class MotionManager: ObservableObject {
    private var locationManager = LocationManager()
    
    @Published var isTracking = false
    @Published var durationSeconds: TimeInterval = 0
    @Published var caloriesBurned: Double = 0
    
    var distanceMeters: Double {
        locationManager.totalDistance
    }
    
    // 新增：让外部可以访问轨迹数据
    var route: [CLLocation] {
        locationManager.route
    }
    
    private var timer: Timer?

    func startTracking(user: UserData?) {
        locationManager.requestPermission()
        locationManager.startUpdating()
        
        isTracking = true
        durationSeconds = 0
        caloriesBurned = 0 // 重置卡路里
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.durationSeconds += 1
            if let user = user {
                self?.caloriesBurned += 0.1 * (user.weightKG / 75.0)
            }
        }
    }

    // 外部调用的方法：停止追踪
    func stopTracking() {
        isTracking = false
        // 停止GPS追踪
        locationManager.stopUpdating()
        timer?.invalidate()
        timer = nil
    }
    
    // 外部调用的方法：重置数据
    func resetData() {
        durationSeconds = 0
        caloriesBurned = 0
        // 不需要重置 locationManager 的距离，因为它在 startUpdating 时会自动重置
    }
}
