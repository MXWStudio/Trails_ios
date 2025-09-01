import SwiftUI
import PhotosUI

struct CreatePostView: View {
    @Environment(\.presentationMode) var presentationMode
    // 回调函数，用于将新帖子传回给主列表
    var onPost: (CommunityPost) -> Void
    
    // 表单状态
    @State private var selectedActivity: ActivityType = .cycling
    @State private var distance: String = ""
    @State private var caption: String = ""
    @State private var tags: String = ""
    
    // 图片选择相关
    @State private var selectedImage: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var showingImagePicker = false
    
    // 验证和UI状态
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    // 用户管理器
    @StateObject private var userManager = UserManager.shared
    
    var body: some View {
        NavigationView {
            Form {
                photoSection
                activityTypeSection
                distanceSection
                captionSection
                tagsSection
            }
            .navigationTitle("发布新动态")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("取消") { 
                    presentationMode.wrappedValue.dismiss() 
                },
                trailing: Button(action: { publishPost() }) {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Text("发布")
                            .fontWeight(.semibold)
                    }
                }
                .disabled(isLoading || !isFormValid)
                .foregroundColor(isFormValid && !isLoading ? .blue : .gray)
            )
            .alert("提示", isPresented: $showingAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .overlay(
                Group {
                    if isLoading {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        ProgressView("正在发布...")
                            .foregroundColor(.white)
                    }
                }
            )
        }
    }
    
    // MARK: - 计算属性
    
    /// 表单是否有效
    private var isFormValid: Bool {
        !caption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !distance.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        isValidDistance(distance)
    }
    
    /// 照片选择部分
    private var photoSection: some View {
        Section(header: Text("选择封面图片")) {
            PhotosPicker(selection: $selectedImage, matching: .images) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 150)
                    
                    if let selectedImageData = selectedImageData,
                       let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 150)
                            .cornerRadius(10)
                            .clipped()
                    } else {
                        VStack {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            Text("点击选择照片")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                        }
                    }
                }
            }
            .onChange(of: selectedImage) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
        }
    }
    
    /// 运动类型选择部分
    private var activityTypeSection: some View {
        Section(header: Text("运动类型")) {
            Picker("运动类型", selection: $selectedActivity) {
                ForEach(ActivityType.allCases) { activity in
                    Text(activity.rawValue).tag(activity)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    /// 距离输入部分
    private var distanceSection: some View {
        Section(header: Text("距离")) {
            TextField("例如: 5.2 km", text: $distance)
                .keyboardType(.decimalPad)
            
            if !distance.isEmpty && !isValidDistance(distance) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("请输入有效的距离格式（如：5.2 或 5.2km）")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
    }
    
    /// 感受输入部分
    private var captionSection: some View {
        Section(
            header: Text("分享你的运动感受"),
            footer: HStack {
                Spacer()
                Text("\(caption.count)/280")
                    .font(.caption)
                    .foregroundColor(caption.count > 280 ? .red : .gray)
            }
        ) {
            TextEditor(text: $caption)
                .frame(height: 100)
                .onChange(of: caption) { oldValue, newValue in
                    // 限制字符数
                    if newValue.count > 280 {
                        caption = String(newValue.prefix(280))
                    }
                }
        }
    }
    
    /// 标签输入部分
    private var tagsSection: some View {
        Section(header: Text("标签 (用空格分隔)")) {
            TextField("例如: #户外 #健康 #运动", text: $tags)
        }
    }
    
    // MARK: - 私有方法
    
    /// 验证距离格式
    private func isValidDistance(_ distance: String) -> Bool {
        let trimmedDistance = distance.trimmingCharacters(in: .whitespacesAndNewlines)
        // 支持格式: "5.2", "5.2km", "5.2 km", "5.2 公里"
        let pattern = #"^\d+(\.\d+)?\s*(km|公里|千米)?$"#
        return trimmedDistance.range(of: pattern, options: .regularExpression) != nil
    }
    
    /// 格式化距离文本
    private func formatDistance(_ distance: String) -> String {
        let trimmed = distance.trimmingCharacters(in: .whitespacesAndNewlines)
        // 如果没有单位，自动添加 km
        if trimmed.range(of: #"\d+(\.\d+)?$"#, options: .regularExpression) != nil {
            return "\(trimmed) km"
        }
        return trimmed
    }
    
    /// 处理标签文本
    private func processTags(_ tagsText: String) -> [String] {
        let components = tagsText.components(separatedBy: .whitespacesAndNewlines)
        return components
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { tag in
                // 自动添加 # 前缀
                return tag.hasPrefix("#") ? tag : "#\(tag)"
            }
    }
    
    /// 发布帖子
    private func publishPost() {
        guard isFormValid else {
            alertMessage = "请确保所有必填项都已正确填写"
            showingAlert = true
            return
        }
        
        isLoading = true
        
        // 模拟网络请求延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            guard let user = userManager.currentUser else {
                alertMessage = "用户信息获取失败，请重新登录"
                showingAlert = true
                isLoading = false
                return
            }
            
            // 创建新帖子
            let newPost = CommunityPost(
                userName: user.displayName,
                userAvatar: user.avatar,
                createdAt: Date(),
                likes: 0,
                comments: 0,
                content: .userPost(UserGeneratedContent(
                    coverImage: selectedImageData != nil ? "user_selected_image" : selectedActivity.defaultCoverImage,
                    photos: selectedImageData != nil ? ["user_selected_image"] : [],
                    caption: caption.trimmingCharacters(in: .whitespacesAndNewlines),
                    tags: processTags(tags),
                    activityType: selectedActivity,
                    routeInfo: formatDistance(distance)
                ))
            )
            
            // 通过回调函数传出新帖子
            onPost(newPost)
            isLoading = false
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    /// 获取当前时间戳
    private func getCurrentTimestamp() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        return "刚刚"
    }
}

// MARK: - ActivityType 扩展

extension ActivityType {
    /// 为每种运动类型提供默认封面图片
    var defaultCoverImage: String {
        switch self {
        case .cycling:
            return "cycling_cover_placeholder"
        case .hiking:
            return "hiking_cover_placeholder"
        case .running:
            return "running_cover_placeholder"
        case .badminton:
            return "badminton_cover_placeholder"
        }
    }
}
