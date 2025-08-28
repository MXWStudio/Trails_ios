import SwiftUI

struct InfoCardView: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - 预览代码
struct InfoCardView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            InfoCardView(icon: "arrow.left.arrow.right", value: "5.2 km", label: "距离")
            InfoCardView(icon: "clock.fill", value: "~45 min", label: "预计用时")
            InfoCardView(icon: "chart.bar.fill", value: "中等", label: "难度")
        }
        .padding()
    }
}
