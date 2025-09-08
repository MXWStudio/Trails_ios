import Foundation

// 为了能和 Supabase 的 jsonb 类型对应，我们需要一个简单的坐标模型
struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
}

struct ActivityRecord: Codable, Identifiable { // 新增 Identifiable
    // id 现在不再是可选的，因为我们需要它来唯一标识列表中的每一行
    var id: UUID = UUID() 
    let user_id: UUID
    let activity_type: String
    let distance_meters: Double
    let duration_seconds: Int
    let calories_burned: Double
    let route: [Coordinate]
    var created_at: Date? = nil // 让 Swift 可以解码数据库的时间戳
    
    // Supabase 的表中列名是下划线，我们需要 CodingKey 来转换
    enum CodingKeys: String, CodingKey {
        case id, user_id, activity_type, distance_meters, duration_seconds, calories_burned, route, created_at
    }
}
