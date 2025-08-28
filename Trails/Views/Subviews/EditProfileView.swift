import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var userDataVM: UserDataViewModel
    @Environment(\.presentationMode) var presentationMode
    
    // 使用 Set 来管理选择，更高效
    @State private var selectedActivities: Set<ActivityType> = []

    var body: some View {
        NavigationView {
            Form {
                // ... 原有的身体数据和运动偏好 Section ...
                
                // 新增：选择最爱的运动
                Section(header: Text("我的运动 (最多选择4项)")) {
                    ForEach(ActivityType.allCases) { activity in
                        Button(action: {
                            // 点击时更新 Set
                            if selectedActivities.contains(activity) {
                                selectedActivities.remove(activity)
                            } else {
                                if selectedActivities.count < 4 {
                                    selectedActivities.insert(activity)
                                }
                            }
                        }) {
                            HStack {
                                Text(activity.rawValue)
                                Spacer()
                                if selectedActivities.contains(activity) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .foregroundColor(.primary) // 保证文字颜色正常
                    }
                }
            }
            .navigationTitle("编辑个人资料")
            .onAppear {
                // 每次视图出现时，都从 ViewModel 同步一次数据
                self.selectedActivities = Set(userDataVM.user.favoriteActivities)
            }
            .navigationBarItems(
                leading: Button("取消") { presentationMode.wrappedValue.dismiss() },
                trailing: Button("保存") {
                    // 保存数据回 ViewModel
                    // 将 Set 转回 Array 并保持原有顺序
                    userDataVM.user.favoriteActivities = ActivityType.allCases.filter { selectedActivities.contains($0) }
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}
