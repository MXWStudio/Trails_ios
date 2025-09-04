import SwiftUI

// 定义运动类型的数据模型
enum ActivityType: String, CaseIterable, Identifiable, Codable {
    case cycling = "骑行"
    case hiking = "徒步"
    case running = "跑步"
    case badminton = "羽毛球"
    
    var id: String { self.rawValue }
    
    // 每个运动类型的UI表现（颜色和图标）
    var themeColor: Color {
        switch self {
        case .cycling: return .orange
        case .hiking: return .green
        case .running: return .blue
        case .badminton: return .purple
        }
    }
    
    // 使用 SF Symbols 作为占位符图标，之后你可以换成自己的插画图片名
    var illustrationName: String {
        switch self {
        case .cycling: return "bicycle"
        case .hiking: return "figure.hiking"
        case .running: return "figure.run"
        case .badminton: return "sportscourt" // 使用可用的SF Symbol
        }
    }
}
