import Foundation

// 排行榜用户的数据模型
struct RankedUser: Identifiable {
    let id = UUID()
    let rank: Int
    let name: String
    let avatar: String // SF Symbol
    let xp: Int
}
