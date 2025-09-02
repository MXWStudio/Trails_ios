import Foundation

// "第一次"记录的数据模型
struct UserFirstRecord: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let icon: String
}

// 小队数据模型
struct Team {
    var name: String
    var members: [String] // 成员名字列表
    var weeklyProgress: Int
    var weeklyGoal: Int
}
