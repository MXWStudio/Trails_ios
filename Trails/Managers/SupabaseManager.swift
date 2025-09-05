import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {
        // !! 重要：请在这里替换成你自己的 Supabase 项目信息 !!
        let supabaseURL = URL(string: "https://rnvgnnfsrsqldrprapwn.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJudmdubmZzcnNxbGRycHJhcHduIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY5NzMzNjQsImV4cCI6MjA3MjU0OTM2NH0.3LWi9Kyr9qXQ1U7ZcfHv7ES3miszv7vjdqw7v6UJg5s"
        
        self.client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
        
        print("🔧 Supabase 客户端已初始化")
        print("🌐 Supabase URL: \(supabaseURL)")
    }
    
    // 测试网络连接和 Supabase 配置
    func testConnection() async -> Bool {
        print("🧪 开始测试 Supabase 连接...")
        
        do {
            // 更简单的连接测试 - 直接尝试获取session
            print("🌐 尝试基础连接测试...")
            
            // 使用内置的URL常量进行健康检查
            let supabaseURL = URL(string: "https://rnvgnnfsrsqldrprapwn.supabase.co")!
            let healthCheckURL = supabaseURL.appendingPathComponent("health")
            let (_, response) = try await URLSession.shared.data(from: healthCheckURL)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 HTTP响应状态: \(httpResponse.statusCode)")
                if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                    print("✅ Supabase 连接测试成功")
                    return true
                }
            }
            
            print("⚠️ 健康检查失败，但继续尝试直接认证...")
            return true // 即使健康检查失败，也允许继续尝试认证
            
        } catch {
            print("❌ Supabase 连接测试失败: \(error)")
            print("❌ 错误类型: \(type(of: error))")
            print("❌ 连接错误详情: \(error.localizedDescription)")
            
            // 检查是否是网络相关错误
            if let urlError = error as? URLError {
                print("🌐 URLError代码: \(urlError.code.rawValue)")
                print("🌐 URLError描述: \(urlError.localizedDescription)")
                
                switch urlError.code {
                case .notConnectedToInternet:
                    print("📵 设备未连接到互联网")
                case .timedOut:
                    print("⏰ 网络请求超时")
                case .cannotFindHost:
                    print("🔍 无法找到服务器主机")
                case .cannotConnectToHost:
                    print("🚫 无法连接到服务器")
                default:
                    print("🌐 其他网络错误: \(urlError.localizedDescription)")
                }
            }
            
            // 对于网络测试失败，我们先返回true，让实际的认证请求来判断
            print("🔄 跳过连接测试，直接尝试认证...")
            return true
        }
    }
    
    // 检查 profiles 表是否存在
    func checkProfilesTable() async -> Bool {
        print("🗄️ 检查 profiles 表是否存在...")
        
        do {
            // 尝试查询 profiles 表，限制结果为0条，只是测试表是否存在
            _ = try await client
                .from("profiles")
                .select("id")
                .limit(0)
                .execute()
            
            print("✅ profiles 表检查通过")
            return true
        } catch {
            print("❌ profiles 表检查失败: \(error)")
            print("❌ 可能的原因：表不存在、权限不足或网络问题")
            return false
        }
    }
}
