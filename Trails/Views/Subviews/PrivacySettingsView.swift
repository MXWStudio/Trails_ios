import SwiftUI

struct PrivacySettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var locationPermission = true
    @State private var healthDataSharing = true
    @State private var analyticsData = false
    @State private var personalizedAds = false
    @State private var dataRetention = "1年"
    @State private var showDataRetentionOptions = false
    
    let dataRetentionOptions = ["30天", "6个月", "1年", "3年", "永久"]
    
    var body: some View {
        NavigationView {
            List {
                // 位置权限
                Section(header: Text("位置权限"), footer: Text("用于记录运动轨迹和提供位置相关功能")) {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                            .frame(width: 24, height: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("位置服务")
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Text("允许应用访问位置信息")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $locationPermission)
                    }
                    .padding(.vertical, 4)
                }
                
                // 健康数据
                Section(header: Text("健康数据"), footer: Text("与Apple Health同步运动数据")) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .frame(width: 24, height: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("健康数据共享")
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Text("同步到Apple Health")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $healthDataSharing)
                    }
                    .padding(.vertical, 4)
                }
                
                // 数据收集
                Section(header: Text("数据收集"), footer: Text("帮助我们改进应用体验")) {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.green)
                            .frame(width: 24, height: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("使用分析")
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Text("匿名使用数据收集")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $analyticsData)
                    }
                    .padding(.vertical, 4)
                    
                    HStack {
                        Image(systemName: "target")
                            .foregroundColor(.purple)
                            .frame(width: 24, height: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("个性化广告")
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Text("基于兴趣的广告推荐")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $personalizedAds)
                    }
                    .padding(.vertical, 4)
                }
                
                // 数据保留
                Section(header: Text("数据保留"), footer: Text("选择数据在服务器上的保留时间")) {
                    Button(action: { showDataRetentionOptions = true }) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.orange)
                                .frame(width: 24, height: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("数据保留期限")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                
                                Text("当前设置：\(dataRetention)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // 隐私控制
                Section(header: Text("隐私控制")) {
                    HStack {
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(.gray)
                            .frame(width: 24, height: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("隐身模式")
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Text("隐藏在线状态和活动")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: .constant(false))
                    }
                    .padding(.vertical, 4)
                    
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.blue)
                            .frame(width: 24, height: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("公开个人资料")
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Text("允许其他用户查看您的资料")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: .constant(true))
                    }
                    .padding(.vertical, 4)
                }
                
                // 数据导出
                Section(header: Text("数据管理")) {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.green)
                                .frame(width: 24, height: 24)
                            
                            Text("导出我的数据")
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .frame(width: 24, height: 24)
                            
                            Text("删除我的数据")
                                .foregroundColor(.red)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("隐私设置")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("完成") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .actionSheet(isPresented: $showDataRetentionOptions) {
            ActionSheet(
                title: Text("选择数据保留期限"),
                message: Text("数据将在指定时间后自动删除"),
                buttons: dataRetentionOptions.map { option in
                    .default(Text(option)) {
                        dataRetention = option
                    }
                } + [.cancel(Text("取消"))]
            )
        }
    }
}

#Preview {
    PrivacySettingsView()
}
