-- Trails 应用数据库诊断和修复脚本
-- 在 Supabase 控制台的 SQL Editor 中执行此脚本

-- 第一步：检查 profiles 表是否存在及其结构
DO $$ 
BEGIN
    -- 检查 profiles 表是否存在
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'profiles') THEN
        RAISE NOTICE '❌ profiles 表不存在，需要创建';
        -- 创建 profiles 表
        CREATE TABLE profiles (
            id UUID REFERENCES auth.users NOT NULL PRIMARY KEY,
            name TEXT,
            total_xp INTEGER DEFAULT 0,
            join_year INTEGER,
            followers INTEGER DEFAULT 0,
            following INTEGER DEFAULT 0,
            streak_days INTEGER DEFAULT 0,
            league TEXT DEFAULT '青铜',
            coins INTEGER DEFAULT 50,
            weight_kg DECIMAL,
            preferred_intensity TEXT,
            favorite_activities JSONB,
            firsts JSONB,
            team JSONB,
            companion JSONB,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        );
        RAISE NOTICE '✅ profiles 表已创建';
    ELSE
        RAISE NOTICE '✅ profiles 表已存在';
    END IF;
END $$;

-- 第二步：检查并添加缺失的字段
DO $$
BEGIN
    -- 检查 age 字段
    IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'age') THEN
        ALTER TABLE profiles ADD COLUMN age INTEGER;
        RAISE NOTICE '✅ 已添加 age 字段';
    ELSE
        RAISE NOTICE '✅ age 字段已存在';
    END IF;

    -- 检查 height_cm 字段
    IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'height_cm') THEN
        ALTER TABLE profiles ADD COLUMN height_cm DECIMAL;
        RAISE NOTICE '✅ 已添加 height_cm 字段';
    ELSE
        RAISE NOTICE '✅ height_cm 字段已存在';
    END IF;

    -- 检查 avatar_url 字段
    IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'avatar_url') THEN
        ALTER TABLE profiles ADD COLUMN avatar_url TEXT;
        RAISE NOTICE '✅ 已添加 avatar_url 字段';
    ELSE
        RAISE NOTICE '✅ avatar_url 字段已存在';
    END IF;

    -- 检查 custom_title 字段
    IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'custom_title') THEN
        ALTER TABLE profiles ADD COLUMN custom_title TEXT;
        RAISE NOTICE '✅ 已添加 custom_title 字段';
    ELSE
        RAISE NOTICE '✅ custom_title 字段已存在';
    END IF;

    -- 检查 owned_decorations 字段
    IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'owned_decorations') THEN
        ALTER TABLE profiles ADD COLUMN owned_decorations JSONB DEFAULT '[]';
        RAISE NOTICE '✅ 已添加 owned_decorations 字段';
    ELSE
        RAISE NOTICE '✅ owned_decorations 字段已存在';
    END IF;
END $$;

-- 第三步：检查 activities 表
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'activities') THEN
        RAISE NOTICE '❌ activities 表不存在，需要创建';
        -- 创建 activities 表
        CREATE TABLE activities (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            user_id UUID NOT NULL REFERENCES auth.users(id),
            activity_type TEXT NOT NULL,
            distance_meters DECIMAL NOT NULL,
            duration_seconds INTEGER NOT NULL,
            calories_burned DECIMAL NOT NULL,
            route JSONB NOT NULL DEFAULT '[]',
            created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        );
        
        -- 创建索引以提高查询性能
        CREATE INDEX idx_activities_user_id ON activities(user_id);
        CREATE INDEX idx_activities_created_at ON activities(created_at);
        CREATE INDEX idx_activities_type ON activities(activity_type);
        
        RAISE NOTICE '✅ activities 表已创建（包含索引）';
    ELSE
        RAISE NOTICE '✅ activities 表已存在';
    END IF;
END $$;

-- 第四步：显示当前表结构
DO $$
BEGIN
    RAISE NOTICE '📊 当前 profiles 表结构：';
END $$;

SELECT column_name, data_type, is_nullable, column_default 
FROM information_schema.columns 
WHERE table_name = 'profiles' 
ORDER BY ordinal_position;

-- 第五步：显示数据统计
DO $$
DECLARE
    profile_count INTEGER;
    activity_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO profile_count FROM profiles;
    SELECT COUNT(*) INTO activity_count FROM activities;
    
    RAISE NOTICE '📈 数据统计：';
    RAISE NOTICE '👥 profiles 表记录数: %', profile_count;
    RAISE NOTICE '🏃 activities 表记录数: %', activity_count;
END $$;

-- 完成提示
DO $$
BEGIN
    RAISE NOTICE '🎉 数据库诊断和修复完成！';
    RAISE NOTICE '💡 如果仍有问题，请检查 Supabase 权限设置';
    RAISE NOTICE '📱 现在可以重启 Trails 应用进行测试';
END $$;
