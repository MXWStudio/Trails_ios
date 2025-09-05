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
        self.lastKnownLocation = newLocation
        
        // 如果有上一个点，就计算距离并累加
        if let previousLocation = previousLocation {
            let distanceIncrement = newLocation.distance(from: previousLocation)
            totalDistance += distanceIncrement
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
