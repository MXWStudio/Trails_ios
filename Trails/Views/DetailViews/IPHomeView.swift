import SwiftUI

struct IPHomeView: View {
    @EnvironmentObject var userDataVM: UserDataViewModel
    @State private var feedbackMessage: String = ""

    var body: some View {
        ZStack {
            // 背景可以换成一张营地的图片
            LinearGradient(colors: [.cyan.opacity(0.2), .blue.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // 新增：情感化反馈气泡
                if !feedbackMessage.isEmpty {
                    Text(feedbackMessage)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .transition(.scale.animation(.spring()))
                        .onAppear {
                            // 3秒后自动消失
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    feedbackMessage = ""
                                }
                            }
                        }
                }
                // 伙伴IP
                Image(systemName: userDataVM.user?.companion.appearanceName ?? "pawprint.fill")
                    .font(.system(size: 150))
                    .foregroundColor(.orange)
                    .padding()
                    .shadow(radius: 10)
                
                Text(userDataVM.user?.companion.name ?? "小伙伴")
                    .font(.largeTitle).bold()
                
                Spacer()
                
                // 装饰品栏
                VStack(alignment: .leading) {
                    Text("我的装饰品")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(userDataVM.user?.ownedDecorations ?? []) { item in
                                VStack {
                                    Image(systemName: item.imageName)
                                        .font(.largeTitle)
                                        .frame(width: 60, height: 60)
                                        .background(Color.white.opacity(0.5))
                                        .cornerRadius(10)
                                    Text(item.name)
                                        .font(.caption)
                                }
                            }
                        }
                        .padding()
                    }
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(15)
                }
                .padding()
            }
        }
        .navigationTitle("我的伙伴")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // 视图出现时，显示一句问候
            withAnimation {
                feedbackMessage = userDataVM.user?.companion.getFeedback(for: .appOpened) ?? "欢迎来到伙伴家园！"
            }
        }
    }
}
