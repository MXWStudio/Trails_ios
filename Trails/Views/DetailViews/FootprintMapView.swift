import SwiftUI
import MapKit

struct FootprintMapView: View {
    // 示例运动轨迹数据
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.681236, longitude: 139.767125), // 东京站
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        Map {
            // 在未来，这里会添加真实的运动轨迹和热力图标记
        }
        .mapStyle(.standard)
        .navigationTitle("我的足迹")
        .ignoresSafeArea(edges: .bottom)
    }
}
