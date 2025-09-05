import Foundation

@MainActor
class MotionManager: ObservableObject {
    // 新增：持有 LocationManager 的实例
    private var locationManager = LocationManager()
    
    @Published var isTracking = false
    @Published var durationSeconds: TimeInterval = 0
    @Published var caloriesBurned: Double = 0
    
    // 修改：距离现在直接从 locationManager 获取
    var distanceMeters: Double {
        locationManager.totalDistance
    }
    
    private var timer: Timer?

    // 外部调用的方法：开始追踪
    func startTracking(user: UserData?) {
        // 先请求权限
        locationManager.requestPermission()
        // 开始GPS追踪
        locationManager.startUpdating()
        
        isTracking = true
        durationSeconds = 0 // 重置计时器
        
        // 计时器现在只负责更新运动时长和卡路里
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.durationSeconds += 1
            
            // 卡路里计算可以保持不变，或未来引入更复杂的算法
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
