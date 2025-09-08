import SwiftUI

struct ActivitySummaryView: View {
    let goal: DailyGoal
    @ObservedObject var motionManager: MotionManager
    var onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("运动完成！").font(.largeTitle).bold()
            Text("+\(goal.xpReward) XP").font(.title).foregroundColor(.yellow)
            
            // 显示运动数据
            VStack(spacing: 12) {
                HStack {
                    Text("距离:")
                    Spacer()
                    Text(String(format: "%.2f 公里", motionManager.distanceMeters / 1000))
                }
                
                HStack {
                    Text("时长:")
                    Spacer()
                    Text(String(format: "%.0f 分钟", motionManager.durationSeconds / 60))
                }
                
                HStack {
                    Text("消耗卡路里:")
                    Spacer()
                    Text(String(format: "%.0f 大卡", motionManager.caloriesBurned))
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            // 显示每日任务进度
            DailyQuestsView(isSummary: true)
            
            Button("完成") { 
                print("🏠 运动总结页面：点击完成按钮")
                onDismiss() 
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding()
        .onAppear {
            print("📊 运动总结页面已显示")
        }
    }
}