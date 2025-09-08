import SwiftUI

struct ActivityHistoryView: View {
    @EnvironmentObject var userDataVM: UserDataViewModel

    var body: some View {
        Group {
            if userDataVM.activityHistory.isEmpty {
                // 空状态显示
                VStack(spacing: 16) {
                    Image(systemName: "figure.walk.motion")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("还没有运动记录")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("开始你的第一次运动吧！")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            } else {
                // 有数据时显示列表
                List {
                    // 遍历从 ViewModel 获取的历史记录
                    ForEach(userDataVM.activityHistory) { record in
                        // 为每一条记录创建一个可点击的行
                        NavigationLink(destination: ActivityHistoryDetailView(record: record)) {
                            HStack {
                                // 左侧的图标
                                Image(systemName: ActivityType(rawValue: record.activity_type)?.illustrationName ?? "figure.walk")
                                    .font(.title)
                                    .foregroundColor(ActivityType(rawValue: record.activity_type)?.themeColor ?? .gray)
                                    .frame(width: 40)

                                // 中间的文字信息
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(record.activity_type)
                                        .font(.headline)
                                    Text(formatDate(record.created_at ?? Date()))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    // 添加时长显示
                                    Text("时长: \(formatDuration(record.duration_seconds))")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                // 右侧的距离和卡路里
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text(String(format: "%.2f km", record.distance_meters / 1000))
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                    Text("\(Int(record.calories_burned)) 大卡")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .refreshable {
                    // 添加下拉刷新功能
                    await userDataVM.refreshActivityHistory()
                }
            }
        }
        .navigationTitle("运动历史")
        .navigationBarTitleDisplayMode(.large)
        .task {
            // 当这个页面出现时，自动执行异步任务来获取历史记录
            await userDataVM.fetchActivityHistory()
        }
    }
    
    // 格式化时长的辅助函数
    private func formatDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        
        if hours > 0 {
            return "\(hours)小时\(remainingMinutes)分钟"
        } else {
            return "\(minutes)分钟"
        }
    }
    
    // 一个辅助函数，用来格式化日期显示
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
