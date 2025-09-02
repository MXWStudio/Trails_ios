import SwiftUI

struct FirstsCollectionView: View {
    @EnvironmentObject var userDataVM: UserDataViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                ForEach(userDataVM.user.firsts) { record in
                    VStack {
                        Image(systemName: record.icon)
                            .font(.system(size: 40))
                            .foregroundColor(.purple)
                        Text(record.title)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        Text(record.date)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(15)
                }
            }
            .padding()
        }
        .navigationTitle("我的第一次")
    }
}
