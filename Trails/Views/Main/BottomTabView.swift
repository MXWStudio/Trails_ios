//
//  BottomTabView.swift
//  Trails
//
//  Created by 孟祥伟 on 2025/8/20.
//

import SwiftUI

/// 可重用的底部导航栏组件
/// 
/// 这个组件提供四个核心功能模块的快速导航：
/// - 今日目标: 运动目标设定和追踪
/// - 社区: 与其他旅行者交流分享  
/// - 成就: 查看运动成就和奖励
/// - 个人: 用户信息管理和设置
/// 
/// 使用方法：
/// - 通过 selectedTab 绑定当前选中的标签页
/// - 通过 onTabChanged 回调处理标签页切换
/// 
/// 设计特点：
/// - 可重用的模块化设计
/// - 统一的UI风格和交互体验
/// - 支持高亮显示当前页面
enum TabItem: Int, CaseIterable {
    case todayGoal = 0
    case community = 1
    case achievements = 2
    case profile = 3
    
    var title: String {
        switch self {
        case .todayGoal: return "今日目标"
        case .community: return "社区"
        case .achievements: return "成就"
        case .profile: return "个人"
        }
    }
    
    var iconName: String {
        switch self {
        case .todayGoal: return "flag.checkered"
        case .community: return "person.3.fill"
        case .achievements: return "star.fill"
        case .profile: return "person.fill"
        }
    }
}

struct BottomTabView: View {
    @Binding var selectedTab: TabItem
    let onTabChanged: (TabItem) -> Void
    
    var body: some View {
        HStack {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                    onTabChanged(tab)
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: 20))
                            .foregroundColor(selectedTab == tab ? .blue : .gray)
                        
                        Text(tab.title)
                            .font(.caption)
                            .foregroundColor(selectedTab == tab ? .blue : .gray)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.separator)),
            alignment: .top
        )
    }
}

// MARK: - 预览
struct BottomTabView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            Text("页面内容区域")
                .font(.largeTitle)
                .foregroundColor(.gray)
            Spacer()
            
            BottomTabView(selectedTab: .constant(.todayGoal)) { selectedTab in
                print("切换到: \(selectedTab.title)")
            }
        }
        .environmentObject(AuthenticationViewModel())
    }
}
