import Foundation

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    var isUnlocked: Bool
    var iconName: String // e.g., "star.fill"
}
