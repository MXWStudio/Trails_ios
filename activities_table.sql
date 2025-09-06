-- 创建 activities 表
-- 在 Supabase 控制台的 SQL Editor 中执行此脚本

CREATE TABLE IF NOT EXISTS activities (
    -- 主键，UUID 类型，自动生成
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- 用户ID，关联到 auth.users 表
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    
    -- 运动类型（跑步、骑行、徒步、羽毛球等）
    activity_type TEXT NOT NULL,
    
    -- 距离（米）
    distance_meters DECIMAL NOT NULL CHECK (distance_meters >= 0),
    
    -- 持续时间（秒）
    duration_seconds INTEGER NOT NULL CHECK (duration_seconds >= 0),
    
    -- 燃烧卡路里
    calories_burned DECIMAL NOT NULL CHECK (calories_burned >= 0),
    
    -- GPS 轨迹数据，存储为 JSONB 数组
    -- 每个元素包含 latitude 和 longitude
    route JSONB NOT NULL DEFAULT '[]',
    
    -- 创建时间，自动生成
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- 更新时间，自动更新
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_activities_user_id ON activities(user_id);
CREATE INDEX IF NOT EXISTS idx_activities_activity_type ON activities(activity_type);
CREATE INDEX IF NOT EXISTS idx_activities_created_at ON activities(created_at DESC);

-- 创建更新时间戳的触发器
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 应用触发器到 activities 表
DROP TRIGGER IF EXISTS update_activities_updated_at ON activities;
CREATE TRIGGER update_activities_updated_at 
    BEFORE UPDATE ON activities 
    FOR EACH ROW 
    EXECUTE PROCEDURE update_updated_at_column();

-- 验证表结构
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'activities' 
ORDER BY ordinal_position;

-- 示例查询：获取用户的所有运动记录
-- SELECT * FROM activities WHERE user_id = 'your-user-id' ORDER BY created_at DESC;
