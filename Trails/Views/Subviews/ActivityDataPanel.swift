import SwiftUI

struct ActivityDataPanel: View {
    @ObservedObject var motionManager: MotionManager
    var body: some View {
        VStack(spacing: 20) {
            Text(String(format: "%02d:%02d", Int(motionManager.durationSeconds)/60, Int(motionManager.durationSeconds)%60))
                .font(.system(size: 80, weight: .bold, design: .rounded))
            HStack(spacing: 40) {
                VStack { Text(String(format: "%.2f", motionManager.distanceMeters/1000)).font(.title).bold(); Text("公里") }
                VStack { Text(String(format: "%.0f", motionManager.caloriesBurned)).font(.title).bold(); Text("大卡") }
            }
        }.frame(maxWidth: .infinity).padding().background(.thinMaterial).cornerRadius(20).padding()
    }
}
