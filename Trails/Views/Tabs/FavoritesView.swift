//
//  AchievementsView.swift
//  Trails
//
//  Created by 孟祥伟 on 2025/8/20.
//

import SwiftUI

/// 成就视图 - 游戏化成就系统
/// 
/// 这个视图展示用户的运动成就和进度：
/// - 显示已解锁和未解锁的成就
/// - 提供成就描述和解锁条件
/// - 激励用户完成更多运动目标
/// - 游戏化的奖励反馈系统
/// 
/// 界面特色：
/// - 直观的成就列表展示
/// - 清晰的解锁状态标识
/// - 鼓励性的成就描述
/// - 黄色星星主题，突出成就感
struct AchievementsView: View {
    @State private var achievements: [Achievement] = [
        Achievement(title: "初次上路", description: "完成你的第一次运动", icon: "star.fill", isUnlocked: true, category: .special),
        Achievement(title: "晨鸟", description: "在早上 8 点前完成一次运动", icon: "sunrise.fill", isUnlocked: false, category: .time),
        Achievement(title: "持之以恒", description: "连续 7 天完成运动", icon: "flame.fill", isUnlocked: false, category: .streak),
        Achievement(title: "十公里俱乐部", description: "单次跑步或徒步超过 10 公里", icon: "figure.run", isUnlocked: false, category: .distance),
        Achievement(title: "卡路里杀手", description: "单次运动消耗超过 500 大卡", icon: "bolt.fill", isUnlocked: false, category: .calories),
        Achievement(title: "速度之星", description: "平均配速达到 5 分钟/公里", icon: "speedometer", isUnlocked: false, category: .special),
        Achievement(title: "马拉松勇士", description: "完成 42.195 公里的马拉松挑战", icon: "medal.fill", isUnlocked: false, category: .distance)
    ]

    var body: some View {
        NavigationView {
            List(achievements, id: \.id) { achievement in
                HStack(spacing: 15) {
                    // 成就图标
                    Image(systemName: achievement.isUnlocked ? achievement.icon : "lock.fill")
                        .foregroundColor(achievement.isUnlocked ? .yellow : .gray)
                        .font(.largeTitle)
                    
                    // 成就信息
                    VStack(alignment: .leading, spacing: 5) {
                        Text(achievement.title)
                            .font(.headline)
                            .foregroundColor(achievement.isUnlocked ? .primary : .secondary)
                        
                        Text(achievement.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    // 解锁状态标识
                    if achievement.isUnlocked {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                    } else {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                            .font(.title3)
                    }
                }
                .padding(.vertical, 8)
                .opacity(achievement.isUnlocked ? 1.0 : 0.6)
            }
            .navigationTitle("成就")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - 预览
struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView()
    }
}

// 为了保持向后兼容，保留 FavoritesView 的别名
typealias FavoritesView = AchievementsView
