import SwiftUI

struct DailyQuestsView: View {
    @EnvironmentObject var userData: UserDataViewModel
    var isSummary: Bool = false // 判断是否为总结页面的简化版
    
    var body: some View {
        VStack {
            if !isSummary {
                HStack {
                    Text("每日任务").font(.title).bold()
                    Spacer()
                    Label("\(userData.user.coins)", systemImage: "diamond.fill").foregroundColor(.blue)
                }
            }
            
            ForEach(userData.dailyQuests) { quest in
                VStack(alignment: .leading) {
                    Text(quest.title)
                    ProgressView(value: Double(quest.progress), total: Double(quest.target))
                        .tint(quest.isCompleted ? .green : .blue)
                    Text("\(quest.progress) / \(quest.target)")
                        .font(.caption).foregroundColor(.gray)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
}