import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2).fontWeight(.bold).foregroundColor(.white)
            .frame(maxWidth: .infinity).padding().background(Color.blue)
            .cornerRadius(15).scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
