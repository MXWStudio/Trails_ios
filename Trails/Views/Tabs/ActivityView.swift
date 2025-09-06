import SwiftUI
import MapKit

struct ActivityView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var motionManager: MotionManager
    @EnvironmentObject var userDataVM: UserDataViewModel
    let goal: DailyGoal
    let activityType: ActivityType // 新增：需要知道当前是什么运动

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
                    // 🆕 使用新的异步方法处理运动结束
                    Task {
                        await handleFinishActivity()
                    }
                }) {
                    Text("结束运动")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.red)
                        .cornerRadius(25)
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
    
    // 🆕 新增：处理结束运动的逻辑
    @MainActor
    private func handleFinishActivity() async {
        // 1. 停止追踪
        motionManager.stopTracking()
        
        // 2. 检查是否有用户登录，并获取用户ID
        guard let currentUserID = userDataVM.user?.id else {
            print("❌ 无法保存记录：用户未登录或用户数据未加载")
            showSummary = true // 即使保存失败，也显示总结页面
            return
        }
        
        // 3. 将 [CLLocation] 轨迹转换为 [Coordinate]
        let routeCoordinates = motionManager.route.map { location in
            Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        
        // 4. 创建要保存的 ActivityRecord
        let newRecord = ActivityRecord(
            user_id: currentUserID,
            activity_type: activityType.rawValue, // 使用传入的运动类型
            distance_meters: motionManager.distanceMeters,
            duration_seconds: Int(motionManager.durationSeconds),
            calories_burned: motionManager.caloriesBurned,
            route: routeCoordinates
        )
        
        // 5. 调用 ViewModel 的方法来保存到 Supabase
        await userDataVM.saveActivityRecord(newRecord)
        
        // 6. 更新本地游戏化数据 (例如：经验值、任务进度等)
        let earnedXP = goal.xpReward
        userDataVM.addXP(earnedXP)
        userDataVM.checkExperienceQuest(xp: earnedXP)
        userDataVM.checkDistanceQuest(distanceKm: motionManager.distanceMeters / 1000)
        userDataVM.checkCaloriesQuest(calories: motionManager.caloriesBurned)
        
        // 7. 显示总结页面
        showSummary = true
    }
}