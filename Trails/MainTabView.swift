//
//  MainTabView.swift
//  Trails
//
//  Created by 孟祥伟 on 2025/8/20.
//

import SwiftUI

// 主 Tab 视图 (登录后显示)
struct MainTabView: View {
    var body: some View {
        TabView {
            // 第一个 Tab: 探索 (主页)
            ExploreView()
                .tabItem {
                    Image(systemName: "safari.fill")
                    Text("探索")
                }

            // 第二个 Tab: 社区
            CommunityView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("社区")
                }

            // 第三个 Tab: 收藏
            FavoritesView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("收藏")
                }

            // 第四个 Tab: 个人
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("个人")
                }
        }
    }
}

// MARK: - 探索视图
struct ExploreView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Image(systemName: "safari.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .padding()
                
                Text("探索")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Text("发现精彩路线和目的地")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .navigationTitle("探索")
        }
    }
}

// MARK: - 社区视图
struct CommunityView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Image(systemName: "person.3.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                    .padding()
                
                Text("社区")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
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

// MARK: - 收藏视图
struct FavoritesView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Image(systemName: "star.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.yellow)
                    .padding()
                
                Text("收藏")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Text("保存您喜欢的路线和地点")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .navigationTitle("收藏")
        }
    }
}

// MARK: - 个人资料视图
struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                // 用户头像
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .padding()
                
                // 用户信息
                VStack(spacing: 8) {
                    Text(authViewModel.userName ?? "用户")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(authViewModel.userEmail ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                Spacer()
                
                // 退出登录按钮
                Button(action: {
                    authViewModel.signOut()
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("退出登录")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
            .navigationTitle("个人")
        }
    }
}

// MARK: - 预览
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AuthenticationViewModel())
    }
}