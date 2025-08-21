import SwiftUI

struct ActivitySummaryView: View {
    let goal: DailyGoal
    @ObservedObject var motionManager: MotionManager
    var onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("运动完成！").font(.largeTitle).bold()
            Text("+\(goal.xpReward) XP").font(.title).foregroundColor(.yellow)
            
            // 显示每日任务进度
            DailyQuestsView(isSummary: true)
            
            Button("完成") { onDismiss() }
                .buttonStyle(PrimaryButtonStyle())
        }
        .padding()
    }
}