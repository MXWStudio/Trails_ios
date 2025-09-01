import SwiftUI

struct CreatePostView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // 发布帖子的回调函数
    var onPostCreated: ((CommunityPost) -> Void)?
    
    // 表单状态
    @State private var caption = ""
    @State private var selectedActivityType: ActivityType = .hiking
    @State private var routeDistance = ""
    @State private var tags = ""
    @State private var selectedImage = "hiking_cover_placeholder" // 默认占位符
    
    // 预设的运动类型选项（用于生成彩色占位符）
    private let availableActivityTypes = ActivityType.allCases
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 选择封面图片
                    VStack(alignment: .leading) {
                        Text("选择封面图片")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(availableActivityTypes, id: \.self) { activityType in
                                    ZStack {
                                        // 彩色背景
                                        Rectangle()
                                            .fill(LinearGradient(
                                                gradient: Gradient(colors: [activityType.themeColor.opacity(0.6), activityType.themeColor]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ))
                                            .frame(width: 100, height: 60)
                                            .cornerRadius(8)
                                        
                                        // 图标和文字
                                        VStack(spacing: 2) {
                                            Image(systemName: activityType.illustrationName)
                                                .font(.title3)
                                                .foregroundColor(.white)
                                            Text(activityType.rawValue)
                                                .font(.caption2)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(selectedActivityType == activityType ? Color.blue : Color.clear, lineWidth: 3)
                                    )
                                    .onTapGesture {
                                        selectedActivityType = activityType
                                        selectedImage = "\(activityType.rawValue)_cover_placeholder"
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // 运动类型选择
                    VStack(alignment: .leading) {
                        Text("运动类型")
                            .font(.headline)
                        
                        Picker("运动类型", selection: $selectedActivityType) {
                            ForEach(ActivityType.allCases) { type in
                                HStack {
                                    Image(systemName: type.illustrationName)
                                    Text(type.rawValue)
                                }
                                .tag(type)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // 路线距离
                    VStack(alignment: .leading) {
                        Text("距离")
                            .font(.headline)
                        
                        TextField("例如：5.2 km", text: $routeDistance)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // 文案输入
                    VStack(alignment: .leading) {
                        Text("分享你的运动感受")
                            .font(.headline)
                        
                        TextEditor(text: $caption)
                            .frame(minHeight: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // 标签输入
                    VStack(alignment: .leading) {
                        Text("标签 (用空格分隔)")
                            .font(.headline)
                        
                        TextField("例如：#户外 #健康 #运动", text: $tags)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("发布新动态")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("取消") { 
                    presentationMode.wrappedValue.dismiss() 
                },
                trailing: Button("发布") { 
                    publishPost()
                }
                .disabled(caption.isEmpty || routeDistance.isEmpty)
            )
        }
    }
    
    private func publishPost() {
        // 处理标签：分割字符串并添加#号
        let processedTags = tags
            .split(separator: " ")
            .map { String($0) }
            .filter { !$0.isEmpty }
            .map { $0.hasPrefix("#") ? $0 : "#\($0)" }
        
        // 创建用户生成的内容
        let userContent = UserGeneratedContent(
            coverImage: selectedImage,
            photos: [], // 暂时为空，未来可以扩展
            caption: caption,
            tags: processedTags,
            activityType: selectedActivityType,
            routeInfo: routeDistance
        )
        
        // 创建新帖子
        let newPost = CommunityPost(
            userName: "我", // 可以从用户数据获取
            userAvatar: "person.crop.circle.fill.badge.checkmark",
            timestamp: "刚刚",
            likes: 0,
            comments: 0,
            content: .userPost(userContent)
        )
        
        // 调用回调函数
        onPostCreated?(newPost)
        
        // 关闭视图
        presentationMode.wrappedValue.dismiss()
    }
}
