import SwiftUI

struct TeamView: View {
    let team: Team
    
    var body: some View {
        List {
            Section(header: Text("本周挑战")) {
                VStack(alignment: .leading) {
                    Text("共同完成 \(team.weeklyGoal) 次运动")
                    ProgressView(value: Double(team.weeklyProgress), total: Double(team.weeklyGoal))
                    Text("\(team.weeklyProgress) / \(team.weeklyGoal)")
                }
            }
            
            Section(header: Text("小队成员")) {
                ForEach(team.members, id: \.self) { member in
                    Text(member)
                }
            }
        }
        .navigationTitle(team.name)
    }
}
