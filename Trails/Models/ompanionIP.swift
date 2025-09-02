import Foundation

// 伙伴IP的数据模型
struct CompanionIP {
    var level: Int = 1
    var name: String = "小狐狸" // 默认名字，未来可以自定义
    
    // 根据等级变化的外观 (使用 SF Symbol 作为占位符)
    var appearanceName: String {
        if level < 5 {
            return "pawprint.fill" // 1-4级
        } else if level < 10 {
            return "pawprint.circle.fill" // 5-9级
        } else {
            return "flame.circle.fill" // 10级以上 (示例)
        }
    }
}
