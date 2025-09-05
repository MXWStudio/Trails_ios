import Foundation

// "第一次"记录的数据模型
struct UserFirstRecord: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var date: String
    var icon: String
}

// 小队数据模型
struct Team: Codable {
    var name: String
    var members: [String] // 成员名字列表
    var weeklyProgress: Int
    var weeklyGoal: Int
}
