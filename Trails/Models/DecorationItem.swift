import Foundation

// 家园装饰品的数据模型
struct DecorationItem: Identifiable, Hashable, Codable {
    var id = UUID()
    let name: String
    let imageName: String // 使用 SF Symbol 作为占位符
}
