import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var userDataVM: UserDataViewModel
    // 新增：获取认证管理器以实现退出登录
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedActivities: Set<ActivityType> = []

    var body: some View {
        NavigationView {
            Form {
                // ... 你可以把身体数据和运动偏好 Section 加回到这里 ...
                
                Section(header: Text("我的运动 (最多选择4项)")) {
                    ForEach(ActivityType.allCases) { activity in
                        Button(action: {
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
                        .foregroundColor(.primary)
                    }
                }
                
                // 新增：账户操作 Section
                Section {
                    Button("退出登录") {
                        Task {
                            // 调用认证管理器中的退出方法
                            await authViewModel.signOut()
                        }
                    }
                    .foregroundColor(.red) // 使用红色以示警告
                }
            }
            .navigationTitle("编辑个人资料")
            .onAppear {
                self.selectedActivities = Set(userDataVM.user?.favoriteActivities ?? [])
            }
            .navigationBarItems(
                leading: Button("取消") { presentationMode.wrappedValue.dismiss() },
                trailing: Button("保存") {
                    if userDataVM.user != nil {
                        userDataVM.user!.favoriteActivities = ActivityType.allCases.filter { selectedActivities.contains($0) }
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}
