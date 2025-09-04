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
    }
}
