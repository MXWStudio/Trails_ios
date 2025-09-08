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
                print("🏠 ActivityView：从总结页面返回，关闭运动视图")
                showSummary = false
                // 确保关闭当前的运动视图，返回到主页面
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    // 🆕 新增：处理结束运动的逻辑
    @MainActor
    private func handleFinishActivity() async {
        print("🏁 开始处理运动结束流程...")
        
        // 1. 停止追踪
        motionManager.stopTracking()
        print("⏹️ 运动追踪已停止")
        
        // 2. 更新本地游戏化数据 (即使保存失败也要更新)
        let earnedXP = goal.xpReward
        userDataVM.addXP(earnedXP)
        userDataVM.checkExperienceQuest(xp: earnedXP)
        userDataVM.checkDistanceQuest(distanceKm: motionManager.distanceMeters / 1000)
        userDataVM.checkCaloriesQuest(calories: motionManager.caloriesBurned)
        print("🎮 游戏化数据已更新：+\(earnedXP) XP")
        
        // 3. 尝试保存运动记录（不阻塞UI）
        if let currentUserID = userDataVM.user?.id {
            print("👤 用户ID：\(currentUserID)")
            
            // 将 [CLLocation] 轨迹转换为 [Coordinate]
            let routeCoordinates = motionManager.route.map { location in
                Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
            
            // 创建要保存的 ActivityRecord
            let newRecord = ActivityRecord(
                user_id: currentUserID,
                activity_type: activityType.rawValue,
                distance_meters: motionManager.distanceMeters,
                duration_seconds: Int(motionManager.durationSeconds),
                calories_burned: motionManager.caloriesBurned,
                route: routeCoordinates
            )
            
            // 异步保存，不阻塞UI
            Task {
                await userDataVM.saveActivityRecord(newRecord)
            }
        } else {
            print("⚠️ 用户未登录或数据未加载，跳过保存运动记录")
        }
        
        // 4. 立即显示总结页面（不等待保存完成）
        print("📊 显示运动总结页面")
        showSummary = true
    }
}