-- 更新 profiles 表，添加缺失的字段
-- 在 Supabase 控制台的 SQL Editor 中执行此脚本

-- 添加年龄字段
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS age INTEGER;

-- 添加身高字段（厘米）
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS height_cm DECIMAL;

-- 添加自定义称号字段
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS custom_title TEXT;

-- 添加头像URL字段
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS avatar_url TEXT;

-- 添加拥有的装饰品字段
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS owned_decorations JSONB;

-- 更新已有记录的默认值（可选）
UPDATE profiles 
SET 
    age = NULL,
    height_cm = NULL,
    custom_title = NULL,
    avatar_url = NULL,
    owned_decorations = '[]'::jsonb
WHERE 
    age IS NULL 
    AND height_cm IS NULL 
    AND custom_title IS NULL 
    AND avatar_url IS NULL 
    AND owned_decorations IS NULL;

-- 验证表结构
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'profiles' 
ORDER BY ordinal_position;
