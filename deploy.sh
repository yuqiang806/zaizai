#!/usr/bin/env bash
# 一次性部署到 GitHub Pages。
# 前置：
#   1) 在 GitHub 新建一个空仓库（如 bench-gantt），不要勾选初始化 README。
#   2) 生成一个仅该仓库的 Fine-grained PAT（勾选 Contents: Read/Write）或 classic PAT（勾选 repo）。
# 用法（在本 gantt_site 目录执行）：
#   GITHUB_TOKEN=ghp_xxx  REPO=你的用户名/bench-gantt  bash deploy.sh
set -e
: "${GITHUB_TOKEN:?请设置环境变量 GITHUB_TOKEN=你的PAT}"
: "${REPO:?请设置环境变量 REPO=owner/repo名}"
REMOTE="https://x-access-token:${GITHUB_TOKEN}@github.com/${REPO}.git"

git add -A
git commit -q -m "台架试验甘特图（含云端数据 data/gantt_data.json）" || echo "（无新提交）"
git branch -M main
git remote remove origin 2>/dev/null || true
git remote add origin "$REMOTE"
git push -u origin main --force
git remote remove origin   # 推送后移除含 token 的 remote，避免凭据残留
echo "✅ 已推送至 ${REPO}。"
echo "👉 接下来在 GitHub 仓库 → Settings → Pages → Source 选择 'Deploy from a branch' / main / root，保存。"
echo "👉 稍候约 1 分钟，访问： https://${REPO%/*}.github.io/${REPO#*/}/"
echo "👉 打开页面后点『☁ 云端同步』填写 用户名/仓库/data路径/Token 并『保存配置』，之后点『💾 保存』即自动写回仓库。"
