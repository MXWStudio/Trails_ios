import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var userDataVM: UserDataViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedActivities: Set<ActivityType> = []
    @State private var selectedIntensity: Intensity = .moderate
    @State private var showSaveAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                // 运动种类选择
                Section(header: Text("我的运动 (最多选择4项)")) {
                    ForEach(ActivityType.allCases) { activity in
                        Button(action: {
                            toggleActivity(activity)
                        }) {
                            HStack {
                                Image(systemName: activity.illustrationName)
                                    .foregroundColor(activity.themeColor)
                                    .frame(width: 24, height: 24)
                                
                                Text(activity.rawValue)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if selectedActivities.contains(activity) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                // 运动强度偏好
                Section(header: Text("运动强度偏好")) {
                    ForEach(Intensity.allCases) { intensity in
                        Button(action: {
                            selectedIntensity = intensity
                        }) {
                            HStack {
                                Text(intensity.rawValue)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if selectedIntensity == intensity {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                // 其他偏好设置
                Section(header: Text("其他设置")) {
                    HStack {
                        Text("每日目标提醒")
                        Spacer()
                        Toggle("", isOn: .constant(true))
                    }
                    
                    HStack {
                        Text("运动完成庆祝")
                        Spacer()
                        Toggle("", isOn: .constant(true))
                    }
                    
                    HStack {
                        Text("数据自动同步")
                        Spacer()
                        Toggle("", isOn: .constant(true))
                    }
                }
            }
            .navigationTitle("偏好设置")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("保存") {
                    savePreferences()
                }
                .disabled(selectedActivities.isEmpty)
            )
        }
        .onAppear {
            loadCurrentPreferences()
        }
        .alert("设置已保存", isPresented: $showSaveAlert) {
            Button("确定") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("您的偏好设置已成功保存")
        }
    }
    
    private func toggleActivity(_ activity: ActivityType) {
        if selectedActivities.contains(activity) {
            selectedActivities.remove(activity)
        } else {
            if selectedActivities.count < 4 {
                selectedActivities.insert(activity)
            }
        }
    }
    
    private func loadCurrentPreferences() {
        guard let user = userDataVM.user else { return }
        
        selectedActivities = Set(user.favoriteActivities)
        selectedIntensity = user.preferredIntensity
    }
    
    private func savePreferences() {
        guard !selectedActivities.isEmpty else { return }
        
        Task {
            let favoriteActivities = ActivityType.allCases.filter { selectedActivities.contains($0) }
            
            await userDataVM.updatePersonalInfo(
                name: userDataVM.user?.name ?? "新用户",
                age: userDataVM.user?.age,
                heightCM: userDataVM.user?.heightCM,
                weightKG: userDataVM.user?.weightKG ?? 70.0,
                customTitle: userDataVM.user?.customTitle,
                favoriteActivities: favoriteActivities,
                preferredIntensity: selectedIntensity,
                newAvatar: nil
            )
            
            await MainActor.run {
                showSaveAlert = true
            }
        }
    }
}

#Preview {
    PreferencesView()
        .environmentObject(UserDataViewModel())
}
