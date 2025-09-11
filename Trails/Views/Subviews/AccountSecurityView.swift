import SwiftUI

struct AccountSecurityView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var userDataViewModel: UserDataViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showChangePassword = false
    @State private var showDeleteAccount = false
    @State private var showLogoutAllDevices = false
    
    // 密码修改相关状态
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    // 用户邮箱信息
    @State private var userEmail: String = "获取中..."
    
    var body: some View {
        NavigationView {
            List {
                accountInfoSection
                securitySettingsSection
                dataManagementSection
                dangerZoneSection
            }
            .navigationTitle("账号与安全")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("完成") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .onAppear {
            Task {
                await fetchUserEmail()
            }
        }
        .alert("修改密码", isPresented: $showChangePassword) {
            TextField("当前密码", text: $currentPassword)
            TextField("新密码", text: $newPassword)
            TextField("确认新密码", text: $confirmPassword)
            Button("取消", role: .cancel) {
                // 重置密码字段
                currentPassword = ""
                newPassword = ""
                confirmPassword = ""
            }
            Button("确认") {
                // 处理密码修改逻辑
                // TODO: 实现密码修改功能
                currentPassword = ""
                newPassword = ""
                confirmPassword = ""
            }
        } message: {
            Text("请输入当前密码和新密码")
        }
        .alert("退出所有设备", isPresented: $showLogoutAllDevices) {
            Button("取消", role: .cancel) {}
            Button("确认", role: .destructive) {
                // 处理退出所有设备逻辑
            }
        } message: {
            Text("这将使所有设备上的登录会话失效，需要重新登录")
        }
        .alert("删除账号", isPresented: $showDeleteAccount) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) {
                // 处理账号删除逻辑
            }
        } message: {
            Text("删除账号将永久删除您的所有数据，此操作不可恢复")
        }
    }
    
    // MARK: - 账号信息部分
    private var accountInfoSection: some View {
        Section(header: Text("账号信息")) {
            accountInfoRow(
                icon: "envelope.fill",
                iconColor: .blue,
                title: "登录邮箱",
                subtitle: userEmail
            )
            
            accountInfoRow(
                icon: "person.circle.fill",
                iconColor: .green,
                title: "用户名",
                subtitle: userDataViewModel.user?.name ?? "未获取到用户信息"
            )
            
            accountInfoRow(
                icon: "calendar",
                iconColor: .orange,
                title: "注册时间",
                subtitle: registrationDateText
            )
        }
    }
    
    // MARK: - 安全设置部分
    private var securitySettingsSection: some View {
        Section(header: Text("安全设置")) {
            securityButton(
                icon: "key.fill",
                iconColor: .blue,
                title: "修改密码",
                action: { showChangePassword = true }
            )
            
            securityButton(
                icon: "iphone.and.arrow.forward",
                iconColor: .orange,
                title: "退出所有设备",
                action: { showLogoutAllDevices = true }
            )
        }
    }
    
    // MARK: - 数据管理部分
    private var dataManagementSection: some View {
        Section(header: Text("数据管理")) {
            dataManagementRow(
                icon: "icloud.and.arrow.down",
                iconColor: .green,
                title: "数据同步",
                subtitle: "最后同步：刚刚",
                action: "立即同步"
            )
            
            dataManagementRow(
                icon: "square.and.arrow.down",
                iconColor: .purple,
                title: "导出数据",
                subtitle: "下载您的运动数据",
                action: nil
            )
        }
    }
    
    // MARK: - 危险操作部分
    private var dangerZoneSection: some View {
        Section(header: Text("危险操作")) {
            securityButton(
                icon: "trash.fill",
                iconColor: .red,
                title: "删除账号",
                action: { showDeleteAccount = true }
            )
        }
    }
    
    // MARK: - 辅助方法
    
    /// 获取当前用户的邮箱
    private func fetchUserEmail() async {
        do {
            let session = try await SupabaseManager.shared.client.auth.session
            await MainActor.run {
                self.userEmail = session.user.email ?? "未获取到邮箱信息"
            }
        } catch {
            await MainActor.run {
                self.userEmail = "获取邮箱失败"
            }
            print("❌ 获取用户邮箱失败: \(error.localizedDescription)")
        }
    }
    
    private var registrationDateText: String {
        if let createdAt = userDataViewModel.user?.createdAt {
            return DateFormatter.localizedString(from: createdAt, dateStyle: .medium, timeStyle: .none)
        } else {
            return "未知"
        }
    }
    
    private func accountInfoRow(icon: String, iconColor: Color, title: String, subtitle: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    private func securityButton(icon: String, iconColor: Color, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .foregroundColor(iconColor == .red ? .red : .primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func dataManagementRow(icon: String, iconColor: Color, title: String, subtitle: String, action: String?) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if let action = action {
                Button(action) {
                    // 触发数据同步
                }
                .font(.caption)
                .foregroundColor(.blue)
            } else {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    AccountSecurityView()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(UserDataViewModel())
}
