import SwiftUI
import MapKit

struct ActivityView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var motionManager: MotionManager
    @EnvironmentObject var userDataVM: UserDataViewModel
    let goal: DailyGoal
    
    @State private var showSummary = false

    var body: some View {
        ZStack {
            // (可选) 未来我们可以用 locationManager.lastKnownLocation 来更新地图中心点
            Map().ignoresSafeArea() 
            
            VStack {
                Spacer()
                // ActivityDataPanel 会自动显示来自 MotionManager 的真实距离
                ActivityDataPanel(motionManager: motionManager)
                Spacer()
                
                Button(action: {
                    motionManager.stopTracking()
                    
                    // (可选) 在这里，你可以将最终的 motionManager.distanceMeters,
                    // motionManager.durationSeconds 等真实数据保存到 Supabase 的新表中
                    
                    // ... 奖励和任务检查逻辑保持不变 ...
                    
                    showSummary = true
                }) {
                    Text("结束运动") // ... 按钮样式 ...
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            motionManager.resetData()
            // 将当前用户数据传入，用于卡路里计算
            motionManager.startTracking(user: userDataVM.user)
        }
        .sheet(isPresented: $showSummary) {
            ActivitySummaryView(goal: goal, motionManager: motionManager) {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
