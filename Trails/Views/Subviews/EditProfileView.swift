import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userDataVM: UserDataViewModel
    
    @State private var tempName: String = ""
    @State private var tempWeight: String = ""
    @State private var tempHeight: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    TextField("姓名", text: $tempName)
                    TextField("体重 (kg)", text: $tempWeight)
                        .keyboardType(.decimalPad)
                    TextField("身高 (cm)", text: $tempHeight)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("运动偏好")) {
                    // 可以添加运动偏好设置
                }
            }
            .navigationTitle("编辑资料")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("保存") {
                    saveChanges()
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .onAppear {
            tempName = userDataVM.user.name
            tempWeight = String(userDataVM.user.weightKG)
            tempHeight = String(userDataVM.user.heightCM)
        }
    }
    
    private func saveChanges() {
        userDataVM.user.name = tempName
        if let weight = Double(tempWeight) {
            userDataVM.user.weightKG = weight
        }
        if let height = Double(tempHeight) {
            userDataVM.user.heightCM = height
        }
    }
}