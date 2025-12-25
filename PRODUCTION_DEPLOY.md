# Casdoor 生产环境部署指南

**生产环境访问地址**: https://iam.appsheild.net

---

## 📋 发布前检查清单

### 1. GitHub 仓库配置

在 GitHub 仓库的 **Settings → Secrets and variables → Actions** 中配置以下内容：

#### Secrets (必需)

| Secret 名称 | 说明 | 示例值 |
|-------------|------|--------|
| `IAM_SERVER_HOST` | 生产服务器 IP 或域名 | `123.45.67.89` |
| `IAM_SERVER_USER` | SSH 登录用户名 | `root` 或 `ubuntu` |
| `IAM_SERVER_SSH_KEY` | SSH 私钥 (完整内容) | `-----BEGIN OPENSSH PRIVATE KEY-----...` |
| `POSTGRES_PASSWORD` | PostgreSQL 数据库密码 | 建议使用强密码 (16+ 字符) |
| `GHCR_TOKEN` | GitHub Personal Access Token (需要 `read:packages` 权限) | `ghp_xxxxxxxxxxxx` |

#### Secrets (可选)

| Secret 名称 | 说明 | 默认值 |
|-------------|------|--------|
| `POSTGRES_USER` | PostgreSQL 用户名 | `casdoor` |
| `POSTGRES_DB` | PostgreSQL 数据库名 | `casdoor` |
| `RADIUS_SECRET` | Radius 服务密钥 | `secret` |

#### Variables (可选)

| Variable 名称 | 说明 | 推荐值 |
|---------------|------|--------|
| `CASDOOR_URL` | Casdoor 访问 URL (用于 Actions 显示) | `https://iam.appsheild.net` |

---

### 2. 服务器准备

在部署服务器上执行以下操作：

#### 2.1 安装 Docker 和 Docker Compose

```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER

# 验证安装
docker --version
docker compose version
```

#### 2.2 安装 Nginx

```bash
sudo apt update
sudo apt install -y nginx
sudo systemctl enable nginx
```

#### 2.3 配置防火墙

```bash
# 开放必要端口
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw allow 22/tcp    # SSH
sudo ufw enable
```

#### 2.4 配置 DNS

在域名服务商处添加 A 记录：

```
iam.appsheild.net  →  服务器IP地址
```

---

### 3. SSL 证书配置

使用 Let's Encrypt 获取免费 SSL 证书：

```bash
# 安装 Certbot
sudo apt install -y certbot python3-certbot-nginx

# 获取证书
sudo certbot --nginx -d iam.appsheild.net

# 设置自动续期
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer
```

---

### 4. Nginx 配置

```bash
# 复制 Nginx 配置文件
sudo cp /opt/casdoor/nginx/casdoor.conf /etc/nginx/sites-available/casdoor

# 创建软链接
sudo ln -s /etc/nginx/sites-available/casdoor /etc/nginx/sites-enabled/

# 测试配置
sudo nginx -t

# 重载配置
sudo systemctl reload nginx
```

---

### 5. 创建部署目录

```bash
sudo mkdir -p /opt/casdoor/{conf,backup,nginx}
sudo chown -R $USER:$USER /opt/casdoor
```

---

## 🚀 部署方式

### 方式一：GitHub Actions 自动部署 (推荐)

1. 完成上述所有 GitHub Secrets 配置
2. 推送代码到 `main` 分支或创建 `iam-v*` 标签
3. GitHub Actions 将自动构建并部署

```bash
# 推送代码触发部署
git add .
git commit -m "deploy: update casdoor configuration"
git push origin main

# 或创建版本标签触发部署
git tag iam-v1.0.0
git push origin iam-v1.0.0
```

### 方式二：手动部署

```bash
# 1. 登录到服务器
ssh user@your-server

# 2. 进入部署目录
cd /opt/casdoor

# 3. 创建环境变量文件
cat > .env << EOF
DOCKER_IMAGE=ghcr.io/fengyily/casdoor-iam
IMAGE_TAG=latest
POSTGRES_USER=casdoor
POSTGRES_PASSWORD=your_strong_password
POSTGRES_DB=casdoor
EOF

# 4. 复制 docker-compose.prod.yml
# (从仓库复制或下载)

# 5. 复制并编辑配置文件
cp conf/app.prod.conf conf/app.conf
# 编辑 app.conf，替换密码占位符

# 6. 启动服务
docker compose -f docker-compose.prod.yml up -d

# 7. 检查服务状态
docker compose -f docker-compose.prod.yml ps
docker logs casdoor-server
```

---

## 🔍 验证部署

### 1. 健康检查

```bash
# 本地检查
curl http://localhost:8000/api/health

# 外部检查
curl https://iam.appsheild.net/api/health
```

### 2. 访问 Web 界面

打开浏览器访问: https://iam.appsheild.net

**默认管理员账号**: `admin` / `123`

> ⚠️ **重要**: 首次登录后请立即修改管理员密码！

---

## 📁 文件结构

部署后的服务器目录结构：

```
/opt/casdoor/
├── docker-compose.yml       # Docker Compose 配置
├── .env                      # 环境变量 (不要提交到 Git)
├── conf/
│   └── app.conf              # Casdoor 配置文件
├── backup/                   # 数据库备份目录
└── nginx/
    └── casdoor.conf          # Nginx 配置
```

---

## 🔧 运维命令

### 查看日志

```bash
# 查看所有服务日志
docker compose -f docker-compose.prod.yml logs -f

# 仅查看 Casdoor 日志
docker logs -f casdoor-server

# 查看 PostgreSQL 日志
docker logs -f casdoor-postgres
```

### 重启服务

```bash
docker compose -f docker-compose.prod.yml restart
```

### 停止服务

```bash
docker compose -f docker-compose.prod.yml down
```

### 更新镜像

```bash
docker compose -f docker-compose.prod.yml pull
docker compose -f docker-compose.prod.yml up -d
```

### 数据库备份

```bash
# 备份
docker exec casdoor-postgres pg_dump -U casdoor casdoor > /opt/casdoor/backup/casdoor_$(date +%Y%m%d_%H%M%S).sql

# 恢复
cat backup/casdoor_YYYYMMDD_HHMMSS.sql | docker exec -i casdoor-postgres psql -U casdoor -d casdoor
```

---

## ⚠️ 安全建议

1. **修改默认密码**: 首次登录后立即修改 `admin` 账户密码
2. **使用强密码**: PostgreSQL 密码应使用 16+ 字符的强密码
3. **限制 SSH 访问**: 使用密钥登录，禁用密码登录
4. **定期备份**: 设置定时任务自动备份数据库
5. **监控日志**: 定期检查访问日志和错误日志
6. **更新镜像**: 定期更新 Docker 镜像以获取安全补丁

---

## 🆘 故障排除

### 服务无法启动

```bash
# 检查容器状态
docker compose -f docker-compose.prod.yml ps -a

# 查看错误日志
docker logs casdoor-server --tail 100
```

### 数据库连接失败

```bash
# 检查 PostgreSQL 是否运行
docker exec casdoor-postgres pg_isready -U casdoor

# 检查网络连接
docker network ls
docker network inspect casdoor_casdoor-network
```

### SSL 证书问题

```bash
# 检查证书状态
sudo certbot certificates

# 手动续期
sudo certbot renew --dry-run
```

### Nginx 502 Bad Gateway

```bash
# 检查 Casdoor 是否运行
curl http://localhost:8000/api/health

# 检查 Nginx 配置
sudo nginx -t

# 查看 Nginx 错误日志
sudo tail -f /var/log/nginx/casdoor_error.log
```

---

## 📞 支持

如有问题，请提交 GitHub Issue 或联系管理员。

