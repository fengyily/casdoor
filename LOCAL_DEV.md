# Casdoor 本地开发环境

本文档介绍如何使用 Docker Compose 在本地运行 Casdoor (使用 PostgreSQL 数据库)。

## 前置要求

- Docker 20.10+
- Docker Compose v2.0+

## 快速开始

### 1. 配置环境变量

```bash
# 复制环境变量示例文件
cp env.example .env

# 根据需要编辑配置
vim .env
```

### 2. 启动服务

```bash
# 启动 Casdoor 和 PostgreSQL
docker-compose -f docker-compose.local.yml up -d

# 查看服务状态
docker-compose -f docker-compose.local.yml ps

# 查看日志
docker-compose -f docker-compose.local.yml logs -f
```

### 3. 访问服务

- **Casdoor**: http://localhost:8000
- **默认管理员账号**: `admin` / `123`

### 4. 使用 pgAdmin (可选)

如果需要数据库管理工具:

```bash
# 启动包含 pgAdmin 的完整环境
docker-compose -f docker-compose.local.yml --profile tools up -d
```

- **pgAdmin**: http://localhost:5050
- **默认登录**: `admin@casdoor.local` / `admin123`

## 常用命令

```bash
# 停止服务
docker-compose -f docker-compose.local.yml down

# 停止并清除数据
docker-compose -f docker-compose.local.yml down -v

# 重新构建镜像
docker-compose -f docker-compose.local.yml build --no-cache

# 查看容器日志
docker-compose -f docker-compose.local.yml logs casdoor
docker-compose -f docker-compose.local.yml logs postgres

# 进入 Casdoor 容器
docker exec -it casdoor-server sh

# 进入 PostgreSQL 容器
docker exec -it casdoor-postgres psql -U casdoor -d casdoor
```

## 配置说明

### 数据库配置

PostgreSQL 连接信息 (默认值):

| 配置项 | 默认值 |
|--------|--------|
| Host | postgres (容器内) / localhost:5432 (外部访问) |
| User | casdoor |
| Password | casdoor123 |
| Database | casdoor |

### 端口映射

| 服务 | 端口 |
|------|------|
| Casdoor | 8000 |
| PostgreSQL | 5432 |
| pgAdmin | 5050 |

## 文件结构

```
casdoor/
├── docker-compose.local.yml  # 本地开发 Docker Compose 配置
├── conf/
│   ├── app.conf              # 生产配置 (MySQL)
│   └── app.local.conf        # 本地开发配置 (PostgreSQL)
├── env.example               # 环境变量示例
├── init-scripts/
│   └── 01-init.sql           # PostgreSQL 初始化脚本
└── LOCAL_DEV.md              # 本文档
```

## 故障排除

### 容器无法启动

1. 检查端口是否被占用:
   ```bash
   lsof -i :8000
   lsof -i :5432
   ```

2. 查看容器日志:
   ```bash
   docker-compose -f docker-compose.local.yml logs
   ```

### 数据库连接失败

1. 确认 PostgreSQL 容器已启动:
   ```bash
   docker-compose -f docker-compose.local.yml ps postgres
   ```

2. 测试数据库连接:
   ```bash
   docker exec -it casdoor-postgres pg_isready -U casdoor -d casdoor
   ```

### 清理重建

```bash
# 完全清理并重新开始
docker-compose -f docker-compose.local.yml down -v --rmi local
docker-compose -f docker-compose.local.yml up -d --build
```

## GitHub Actions 部署

项目包含 GitHub Actions 工作流 (`.github/workflows/iam-deploy.yml`)，支持自动化部署到服务器。

### 配置 Secrets

在 GitHub 仓库设置中添加以下 Secrets:

| Secret 名称 | 说明 |
|-------------|------|
| `IAM_SERVER_HOST` | 部署服务器地址 |
| `IAM_SERVER_USER` | SSH 用户名 |
| `IAM_SERVER_SSH_KEY` | SSH 私钥 |
| `POSTGRES_PASSWORD` | PostgreSQL 密码 |
| `GHCR_TOKEN` | GitHub Container Registry Token |

### 配置 Variables

| Variable 名称 | 说明 |
|---------------|------|
| `CASDOOR_URL` | Casdoor 访问地址 |
| `CASDOOR_ORIGIN` | Casdoor 后端 Origin |
| `CASDOOR_FRONTEND_ORIGIN` | Casdoor 前端 Origin |

