import SwiftUI

struct ActivityHistoryDetailView: View {
    let record: ActivityRecord

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 顶部卡片 - 运动类型和图标
                HStack {
                    Image(systemName: ActivityType(rawValue: record.activity_type)?.illustrationName ?? "figure.walk")
                        .font(.system(size: 50))
                        .foregroundColor(ActivityType(rawValue: record.activity_type)?.themeColor ?? .gray)
                    
                    VStack(alignment: .leading) {
                        Text(record.activity_type)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        if let createdAt = record.created_at {
                            Text(formatFullDate(createdAt))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // 运动数据卡片
                VStack(alignment: .leading, spacing: 16) {
                    Text("运动数据")
                        .font(.headline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        StatDetailCard(
                            icon: "ruler",
                            title: "距离",
                            value: String(format: "%.2f", record.distance_meters / 1000),
                            unit: "公里",
                            color: .blue
                        )
                        
                        StatDetailCard(
                            icon: "clock",
                            title: "时长",
                            value: formatDuration(record.duration_seconds),
                            unit: "",
                            color: .green
                        )
                        
                        StatDetailCard(
                            icon: "flame",
                            title: "卡路里",
                            value: String(format: "%.0f", record.calories_burned),
                            unit: "大卡",
                            color: .orange
                        )
                        
                        StatDetailCard(
                            icon: "speedometer",
                            title: "平均速度",
                            value: String(format: "%.1f", calculateAverageSpeed()),
                            unit: "公里/小时",
                            color: .purple
                        )
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // 路线信息
                if !record.route.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("路线信息")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: "location")
                                .foregroundColor(.red)
                            Text("轨迹点数量: \(record.route.count)")
                                .font(.subheadline)
                        }
                        
                        // 这里未来可以添加地图显示
                        Text("🗺️ 地图轨迹显示功能正在开发中...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("运动详情")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // 辅助函数
    private func formatFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, remainingSeconds)
        } else {
            return String(format: "%d:%02d", minutes, remainingSeconds)
        }
    }
    
    private func calculateAverageSpeed() -> Double {
        let distanceKm = record.distance_meters / 1000
        let timeHours = Double(record.duration_seconds) / 3600
        return timeHours > 0 ? distanceKm / timeHours : 0
    }
}

// 详细数据展示卡片
struct StatDetailCard: View {
    let icon: String
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                if !unit.isEmpty {
                    Text(unit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}
