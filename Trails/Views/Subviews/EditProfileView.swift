import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var userDataVM: UserDataViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var height: Double = 180.0
    @State private var weight: Double = 75.0
    @State private var preferredIntensity: Intensity = .moderate

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("身体数据")) {
                    Stepper("身高: \(height, specifier: "%.0f") cm", value: $height, in: 100...250)
                    Stepper("体重: \(weight, specifier: "%.1f") kg", value: $weight, in: 30...200, step: 0.5)
                }
                
                // 新增：默认运动强度选择
                Section(header: Text("运动偏好")) {
                    Picker("默认运动强度", selection: $preferredIntensity) {
                        ForEach(Intensity.allCases) { intensity in
                            Text(intensity.rawValue).tag(intensity)
                        }
                    }
                }
            }
            .navigationTitle("编辑个人资料")
            .onAppear {
                // 视图出现时，从 ViewModel 加载当前数据到 @State 变量
                self.height = userDataVM.user.heightCM
                self.weight = userDataVM.user.weightKG
                self.preferredIntensity = userDataVM.user.preferredIntensity
            }
            .navigationBarItems(
                leading: Button("取消") { presentationMode.wrappedValue.dismiss() },
                trailing: Button("保存") {
                    // 保存数据回 ViewModel
                    userDataVM.user.heightCM = height
                    userDataVM.user.weightKG = weight
                    userDataVM.user.preferredIntensity = preferredIntensity
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

// MARK: - 预览
struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
            .environmentObject(UserDataViewModel())
    }
}