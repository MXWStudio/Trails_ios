import Foundation

// 伙伴IP的数据模型
import Foundation

// 伙伴IP的数据模型
struct CompanionIP {
    var level: Int = 1
    var name: String = "小狐狸"
    
    // 根据等级变化的外观
    var appearanceName: String {
        if level < 5 { return "pawprint.fill" }
        else if level < 10 { return "pawprint.circle.fill" }
        else { return "flame.circle.fill" }
    }
    
    // 新增：情感化反馈
    func getFeedback(for event: FeedbackEvent) -> String {
        switch event {
        case .appOpened:
            return "今天我们去哪里冒险呀？"
        case .completedWorkout:
            return "太棒了！你今天又进步了！"
        case .recordBroken:
            return "哇！你打破了自己的纪录，真为你骄傲！"
        case .streakContinued:
            return "连续打卡！我们的毅力无人能及！"
        }
    }
    
    enum FeedbackEvent {
        case appOpened, completedWorkout, recordBroken, streakContinued
    }
}
