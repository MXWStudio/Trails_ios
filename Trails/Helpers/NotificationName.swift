import Foundation

// 创建一个专门的地方管理通知名称，让代码更清晰
extension Notification.Name {
    static let userDidAuthenticate = Notification.Name("userDidAuthenticate")
    static let userDidSignOut = Notification.Name("userDidSignOut")
}
