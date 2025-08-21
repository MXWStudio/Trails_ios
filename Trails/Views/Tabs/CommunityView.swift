//
//  CommunityView.swift
//  Trails
//
//  Created by 孟祥伟 on 2025/8/20.
//

import SwiftUI

/// 社区视图 - 与其他旅行者交流分享
/// 
/// 这个视图提供社交功能，让用户可以：
/// - 与其他旅行者互动交流
/// - 分享旅行经验和照片
/// - 查看社区动态和推荐
/// - 参与讨论和评论
/// 
/// 界面特色：
/// - 绿色主题设计，体现社交和交流的友好氛围
/// - 注重用户体验，便于浏览和参与
/// - 支持多种互动方式
struct CommunityView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                // 主图标
                Image(systemName: "person.3.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                    .padding()
                
                // 标题
                Text("社区")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                // 描述文字
                Text("与其他旅行者交流分享")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                // 功能按钮
                VStack(spacing: 15) {
                    Button("浏览动态") {
                        // TODO: 实现浏览动态功能
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button("发布运动成果") {
                        // TODO: 实现发布功能
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button("寻找运动伙伴") {
                        // TODO: 实现寻找伙伴功能
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding()
                
                Spacer()
                
                // 为底部导航栏预留空间
                Color.clear
                    .frame(height: 60)
            }
            .navigationTitle("社区")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - 预览
struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}
