import SwiftUI

struct IPHomeView: View {
    @EnvironmentObject var userDataVM: UserDataViewModel

    var body: some View {
        ZStack {
            // 背景可以换成一张营地的图片
            LinearGradient(colors: [.cyan.opacity(0.2), .blue.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // 伙伴IP
                Image(systemName: userDataVM.user.companion.appearanceName)
                    .font(.system(size: 150))
                    .foregroundColor(.orange)
                    .padding()
                    .shadow(radius: 10)
                
                Text(userDataVM.user.companion.name)
                    .font(.largeTitle).bold()
                
                Spacer()
                
                // 装饰品栏
                VStack(alignment: .leading) {
                    Text("我的装饰品")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(userDataVM.user.ownedDecorations) { item in
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
    }
}
