#!/bin/bash

# 下载 cdn.casbin.org 的静态资源到本地
# 用于完全本地化部署，避免依赖外部 CDN

set -e

CDN_BASE="https://cdn.casbin.org"
PUBLIC_DIR="$(dirname "$0")/../web/public"

# 创建目录结构
mkdir -p "$PUBLIC_DIR/img/casbin"
mkdir -p "$PUBLIC_DIR/flag-icons"

echo "开始下载 CDN 资源到 $PUBLIC_DIR ..."

# 基础图片
echo "下载基础图片..."
curl -sSL "$CDN_BASE/img/casbin.svg" -o "$PUBLIC_DIR/img/casbin.svg"
curl -sSL "$CDN_BASE/img/casbin/favicon.ico" -o "$PUBLIC_DIR/img/casbin/favicon.ico"
curl -sSL "$CDN_BASE/img/favicon.png" -o "$PUBLIC_DIR/img/favicon.png"
curl -sSL "$CDN_BASE/img/casdoor-logo_1185x256.png" -o "$PUBLIC_DIR/img/casdoor-logo_1185x256.png"
curl -sSL "$CDN_BASE/img/casdoor-logo_1185x256_dark.png" -o "$PUBLIC_DIR/img/casdoor-logo_1185x256_dark.png"
curl -sSL "$CDN_BASE/img/casdoor.png" -o "$PUBLIC_DIR/img/casdoor.png"

# 社交/提供商图标
echo "下载提供商图标..."
SOCIAL_ICONS=(
    "social_aliyun.png"
    "social_aws.png"
    "social_azure.png"
    "social_infobip.png"
    "social_tencent_cloud.jpg"
    "social_baidu_cloud.png"
    "social_volc_engine.jpg"
    "social_huawei.png"
    "social_ucloud.png"
    "social_twilio.svg"
    "social_smsbao.png"
    "social_submail.svg"
    "social_msg91.ico"
    "social_osonsms.svg"
    "social_default.png"
    "social_recaptcha.png"
    "social_hcaptcha.png"
    "social_geetest.png"
    "social_cloudflare.png"
    "social_openai.svg"
    "social_metamask.svg"
    "social_web3onboard.svg"
    "social_telegram.png"
    "social_dingtalk.png"
    "social_lark.png"
    "social_teams.png"
    "social_bark.png"
    "social_pushover.png"
    "social_pushbullet.png"
    "social_slack.png"
    "social_discord.png"
    "social_google_chat.png"
    "social_line.png"
    "social_matrix.png"
    "social_twitter.png"
    "social_reddit.png"
    "social_rocket_chat.png"
    "social_viber.png"
    "social_file.png"
    "social_minio.png"
    "social_qiniu_cloud.png"
    "social_google_cloud.png"
    "social_synology.png"
    "social_cucloud.png"
    "social_keycloak.png"
    "social_custom.png"
    "social_stripe.png"
    "social_google.png"
    "social_github.png"
    "social_qq.png"
    "social_wechat.png"
    "social_facebook.png"
    "social_weibo.png"
    "social_gitee.png"
    "social_linkedin.png"
    "social_wecom.png"
    "social_gitlab.png"
    "social_adfs.png"
    "social_baidu.png"
    "social_alipay.png"
    "social_casdoor.png"
    "social_infoflow.png"
    "social_apple.png"
    "social_azuread.png"
    "social_steam.png"
    "social_bilibili.png"
    "social_okta.png"
    "social_douyin.png"
    "social_kwai.png"
    "social_amazon.png"
    "social_auth0.png"
    "social_battlenet.png"
    "social_bitbucket.png"
    "social_box.png"
    "social_cloudfoundry.png"
    "social_dailymotion.png"
    "social_deezer.png"
    "social_digitalocean.png"
    "social_dropbox.png"
    "social_eveonline.png"
    "social_fitbit.png"
    "social_gitea.png"
    "social_heroku.png"
    "social_influxcloud.png"
    "social_instagram.png"
    "social_intercom.png"
    "social_kakao.png"
    "social_lastfm.png"
    "social_mailru.png"
    "social_meetup.png"
    "social_microsoftonline.png"
    "social_naver.png"
    "social_nextcloud.png"
    "social_onedrive.png"
    "social_oura.png"
    "social_patreon.png"
    "social_paypal.png"
    "social_salesforce.png"
    "social_shopify.png"
    "social_soundcloud.png"
    "social_spotify.png"
    "social_strava.png"
    "social_tiktok.png"
    "social_tumblr.png"
    "social_twitch.png"
    "social_typetalk.png"
    "social_uber.png"
    "social_vk.png"
    "social_wepay.png"
    "social_xero.png"
    "social_yahoo.png"
    "social_yammer.png"
    "social_yandex.png"
    "social_zoom.png"
)

for icon in "${SOCIAL_ICONS[@]}"; do
    curl -sSL "$CDN_BASE/img/$icon" -o "$PUBLIC_DIR/img/$icon" 2>/dev/null || echo "警告: 无法下载 $icon"
done

# 邮件/支付/验证码图标
echo "下载其他图标..."
OTHER_ICONS=(
    "email_default.png"
    "email_mailtrap.png"
    "email_sendgrid.png"
    "captcha_default.png"
    "payment_paypal.png"
    "payment_balance.svg"
    "payment_alipay.png"
    "payment_wechat_pay.png"
    "payment_airwallex.svg"
    "payment_gc.png"
    "cucloud.png"
)

for icon in "${OTHER_ICONS[@]}"; do
    curl -sSL "$CDN_BASE/img/$icon" -o "$PUBLIC_DIR/img/$icon" 2>/dev/null || echo "警告: 无法下载 $icon"
done

# 下载国旗图标
echo "下载国旗图标..."
COUNTRY_CODES=(
    "US" "ES" "FR" "DE" "GB" "CN" "JP" "KR" "VN" "ID" "SG" "IN"
    "PT" "IT" "MY" "TR" "SA" "IL" "NL" "PL" "FI" "SE" "UA" "KZ"
    "IR" "CZ" "SK" "AZ" "RU"
)

for code in "${COUNTRY_CODES[@]}"; do
    curl -sSL "$CDN_BASE/flag-icons/$code.svg" -o "$PUBLIC_DIR/flag-icons/$code.svg" 2>/dev/null || echo "警告: 无法下载 $code.svg"
done

# 创建 manifest.json
echo "创建 manifest.json..."
cat > "$PUBLIC_DIR/manifest.json" << 'EOF'
{
  "short_name": "App Shield",
  "name": "App Shield - Identity and Access Management",
  "icons": [
    {
      "src": "img/favicon.png",
      "sizes": "64x64 32x32 24x24 16x16",
      "type": "image/png"
    },
    {
      "src": "img/favicon.png",
      "type": "image/png",
      "sizes": "192x192"
    },
    {
      "src": "img/favicon.png",
      "type": "image/png",
      "sizes": "512x512"
    }
  ],
  "start_url": ".",
  "display": "standalone",
  "theme_color": "#000000",
  "background_color": "#ffffff"
}
EOF

echo ""
echo "✅ 下载完成！"
echo ""
echo "资源已保存到: $PUBLIC_DIR"
echo ""
echo "下一步: 重新构建前端"
echo "  cd casdoor/web && yarn build"
echo ""

