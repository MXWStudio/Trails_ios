import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userDataVM: UserDataViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showPreferences = false
    @State private var showAccountSecurity = false
    @State private var showPrivacySettings = false
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationView {
            List {
                // 偏好设置
                Section {
                    SettingsRow(
                        icon: "heart.fill",
                        iconColor: .pink,
                        title: "偏好设置",
                        subtitle: "运动种类、强度偏好等",
                        action: { showPreferences = true }
                    )
                }
                
                // 账号与安全
                Section {
                    SettingsRow(
                        icon: "person.badge.shield.checkmark",
                        iconColor: .blue,
                        title: "账号与安全",
                        subtitle: "登录信息、密码设置",
                        action: { showAccountSecurity = true }
                    )
                }
                
                // 隐私设置
                Section {
                    SettingsRow(
                        icon: "hand.raised.fill",
                        iconColor: .green,
                        title: "隐私设置",
                        subtitle: "数据隐私、位置权限等",
                        action: { showPrivacySettings = true }
                    )
                }
                
                // 其他设置
                Section {
                    SettingsRow(
                        icon: "bell.fill",
                        iconColor: .orange,
                        title: "通知设置",
                        subtitle: "推送通知、提醒设置"
                    )
                    
                    SettingsRow(
                        icon: "questionmark.circle.fill",
                        iconColor: .gray,
                        title: "帮助与反馈",
                        subtitle: "常见问题、意见反馈"
                    )
                    
                    SettingsRow(
                        icon: "info.circle.fill",
                        iconColor: .blue,
                        title: "关于应用",
                        subtitle: "版本信息、开源许可"
                    )
                }
                
                // 危险操作
                Section {
                    Button(action: { showLogoutAlert = true }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                                .frame(width: 24, height: 24)
                            
                            Text("退出登录")
                                .foregroundColor(.red)
                            
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("完成") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .sheet(isPresented: $showPreferences) {
            PreferencesView()
                .environmentObject(userDataVM)
        }
        .sheet(isPresented: $showAccountSecurity) {
            AccountSecurityView()
                .environmentObject(authViewModel)
        }
        .sheet(isPresented: $showPrivacySettings) {
            PrivacySettingsView()
        }
        .alert("确认退出", isPresented: $showLogoutAlert) {
            Button("取消", role: .cancel) {}
            Button("退出", role: .destructive) {
                Task {
                    await authViewModel.signOut()
                }
            }
        } message: {
            Text("退出登录后需要重新登录才能使用应用")
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let action: (() -> Void)?
    
    init(icon: String, iconColor: Color, title: String, subtitle: String, action: (() -> Void)? = nil) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
    
    var body: some View {
        Button(action: action ?? {}) {
            HStack(spacing: 12) {
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
                
                if action != nil {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserDataViewModel())
        .environmentObject(AuthenticationViewModel())
}
