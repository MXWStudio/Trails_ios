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
            VStack {
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
                
                Spacer()
            }
            .navigationTitle("社区")
        }
    }
}

// MARK: - 预览
struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}
