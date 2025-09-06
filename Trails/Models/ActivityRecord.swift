import Foundation

// 为了能和 Supabase 的 jsonb 类型对应，我们需要一个简单的坐标模型
struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
}

// 对应 Supabase 'activities' 表的数据模型
struct ActivityRecord: Codable {
    // 我们让 Supabase 自动生成 id，所以在 Swift 中设为可选
    var id: UUID? = nil
    let user_id: UUID
    let activity_type: String
    let distance_meters: Double
    let duration_seconds: Int
    let calories_burned: Double
    let route: [Coordinate] // 存储运动轨迹
    // created_at 会由数据库自动生成
}
