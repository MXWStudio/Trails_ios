import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @EnvironmentObject var userDataVM: UserDataViewModel
    // 新增：获取认证管理器以实现退出登录
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    // 头像更新回调
    var onAvatarUpdated: ((UIImage?) -> Void)?
    
    @State private var selectedActivities: Set<ActivityType> = []
    
    // 个人信息编辑状态
    @State private var editedName: String = ""
    @State private var editedAge: String = ""
    @State private var editedHeight: String = ""
    @State private var editedWeight: String = ""
    @State private var editedCustomTitle: String = ""
    @State private var showingImagePicker = false
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var avatarImage: UIImage? = nil

    var body: some View {
        NavigationView {
            Form {
                // 个人信息编辑 Section
                Section(header: Text("个人信息")) {
                    // 头像编辑
                    HStack {
                        if let avatarImage = avatarImage {
                            Image(uiImage: avatarImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("头像")
                                .font(.headline)
                            PhotosPicker(
                                selection: $selectedPhoto,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                Text("选择照片")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    
                    // 昵称编辑
                    HStack {
                        Text("昵称")
                        Spacer()
                        TextField("请输入昵称", text: $editedName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 150)
                    }
                    
                    // 年龄编辑
                    HStack {
                        Text("年龄")
                        Spacer()
                        TextField("请输入年龄", text: $editedAge)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(maxWidth: 150)
                    }
                    
                    // 身高编辑
                    HStack {
                        Text("身高 (cm)")
                        Spacer()
                        TextField("请输入身高", text: $editedHeight)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(maxWidth: 150)
                    }
                    
                    // 体重编辑
                    HStack {
                        Text("体重 (kg)")
                        Spacer()
                        TextField("请输入体重", text: $editedWeight)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(maxWidth: 150)
                    }
                    
                    // 自定义称号编辑
                    HStack {
                        Text("个人称号")
                        Spacer()
                        TextField("请输入称号（英文/数字）", text: $editedCustomTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 150)
                            .onChange(of: editedCustomTitle) { newValue in
                                // 只允许英文字母、数字和空格
                                let filtered = newValue.filter { $0.isLetter || $0.isNumber || $0.isWhitespace }
                                if filtered != newValue {
                                    editedCustomTitle = filtered
                                }
                            }
                    }
                }
                
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
                loadUserData()
            }
            .onChange(of: selectedPhoto) { _ in
                Task {
                    await loadSelectedPhoto()
                }
            }
            .navigationBarItems(
                leading: Button("取消") { presentationMode.wrappedValue.dismiss() },
                trailing: Button("保存") {
                    saveUserData()
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    
    // MARK: - 辅助方法
    
    private func loadUserData() {
        guard let user = userDataVM.user else { return }
        
        // 加载现有数据到编辑状态
        editedName = user.name
        editedAge = user.age != nil ? String(user.age!) : ""
        editedHeight = user.heightCM != nil ? String(user.heightCM!) : ""
        editedWeight = String(user.weightKG)
        editedCustomTitle = user.customTitle ?? ""
        selectedActivities = Set(user.favoriteActivities)
        
        // 如果用户有头像URL，尝试加载头像
        if let avatarURL = user.avatarURL, !avatarURL.isEmpty {
            // 这里可以添加从URL加载图片的逻辑
        }
    }
    
    private func saveUserData() {
        guard userDataVM.user != nil else { return }
        
        // 使用 Task 来执行异步的保存操作
        Task {
            // 准备更新的数据
            let name = editedName.isEmpty ? userDataVM.user?.name ?? "新用户" : editedName
            let age = Int(editedAge)
            let heightCM = Double(editedHeight)
            let weightKG = Double(editedWeight) ?? userDataVM.user?.weightKG ?? 70.0
            let customTitle = editedCustomTitle.isEmpty ? nil : editedCustomTitle
            let favoriteActivities = ActivityType.allCases.filter { selectedActivities.contains($0) }
            
            // 使用新的个人资料更新方法
            await userDataVM.updatePersonalInfo(
                name: name,
                age: age,
                heightCM: heightCM,
                weightKG: weightKG,
                customTitle: customTitle,
                favoriteActivities: favoriteActivities,
                newAvatar: avatarImage
            )
            
            print("💾 用户数据已保存：")
            print("👤 姓名: \(name)")
            print("🎂 年龄: \(age ?? 0)")
            print("📏 身高: \(heightCM ?? 0)")
            print("⚖️ 体重: \(weightKG)")
            print("🏷️ 称号: \(customTitle ?? "无")")
            print("💾 数据已保存到本地缓存并尝试同步到云端")
        }
    }
    
    @MainActor
    private func loadSelectedPhoto() async {
        guard let selectedPhoto = selectedPhoto else { return }
        
        do {
            if let data = try await selectedPhoto.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    avatarImage = uiImage
                    // 注意：这里需要实现头像上传到服务器的逻辑
                    // userDataVM.user?.avatarURL = "上传后的URL"
                }
            }
        } catch {
            print("加载照片失败: \(error)")
        }
    }
}
