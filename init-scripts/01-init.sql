-- Casdoor PostgreSQL 初始化脚本
-- 此脚本在 PostgreSQL 容器首次启动时自动执行

-- 确保数据库使用 UTF-8 编码
-- 注意: 数据库已由 POSTGRES_DB 环境变量创建

-- 创建扩展 (如果需要)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- 授权
GRANT ALL PRIVILEGES ON DATABASE casdoor TO casdoor;

-- 打印初始化完成信息
DO $$
BEGIN
    RAISE NOTICE 'Casdoor PostgreSQL 初始化完成!';
END $$;

