import SwiftUI
import CoreLocation
import Foundation
import CoreLocation

// 这个类专门负责处理所有与GPS定位相关的功能
@MainActor
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    // 实时发布用户的最新位置和总移动距离
    @Published var lastKnownLocation: CLLocation?
    @Published var totalDistance: Double = 0.0
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationError: String?
    
    // 存储上一个位置点，用于计算距离增量
    private var previousLocation: CLLocation?
    
    // 🆕 存储完整的运动轨迹（GPS坐标点数组）
    @Published var route: [CLLocation] = []

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation // 设置最高精度
        // 注意：后台定位需要额外的配置和权限，这里先注释掉
        // locationManager.allowsBackgroundLocationUpdates = true
        // locationManager.showsBackgroundLocationIndicator = true
    }

    // 外部调用的方法：请求权限
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    // 外部调用的方法：开始追踪
    func startUpdating() {
        // 清除之前的错误
        locationError = nil
        
        // 检查权限状态
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            locationError = "定位权限未授权，请在设置中开启定位权限"
            return
        }
        
        // 重置数据
        totalDistance = 0.0
        previousLocation = nil
        lastKnownLocation = nil
        route = [] // 🆕 重置轨迹数组
        
        locationManager.startUpdatingLocation()
    }

    // 外部调用的方法：停止追踪
    func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }

    // --- CLLocationManagerDelegate 代理方法 ---

    // 当位置更新时被调用
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        // 过滤掉精度较差的位置点（水平精度大于10米的点）
        guard newLocation.horizontalAccuracy <= 10.0 && newLocation.horizontalAccuracy > 0 else {
            print("⚠️ GPS精度较差，跳过此位置点: \(newLocation.horizontalAccuracy)米")
            return
        }
        
        self.lastKnownLocation = newLocation
        
        // 🆕 将新位置点添加到轨迹数组中
        route.append(newLocation)
        
        // 如果有上一个点，就计算距离并累加
        if let previousLocation = previousLocation {
            let distanceIncrement = newLocation.distance(from: previousLocation)
            totalDistance += distanceIncrement
            
            // 打印调试信息
            print("📍 新增GPS点: \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
            print("📏 距离增量: \(String(format: "%.1f", distanceIncrement))米, 总距离: \(String(format: "%.1f", totalDistance))米")
        }
        
        // 更新上一个点
        self.previousLocation = newLocation
    }
    
    // 当权限状态改变时被调用
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ 定位权限已获取")
            locationError = nil
        case .denied:
            print("❌ 用户拒绝了定位权限")
            locationError = "定位权限被拒绝，请在设置中开启定位权限"
        case .restricted:
            locationError = "定位权限受限制"
        case .notDetermined:
            print("❓ 用户尚未决定定位权限")
        @unknown default:
            locationError = "未知的定位权限状态"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ 定位失败: \(error.localizedDescription)")
        locationError = "定位失败: \(error.localizedDescription)"
    }
}
