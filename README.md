# YYCLink AI Skills

YYCLink 的个人 AI Skill 集合，用于 Claude Code 等 AI 编程助手。

> 📋 **本仓库是技能索引中心**，每个技能都是独立仓库，可单独下载使用。

## 🎯 我的 Skills

| Skill | 说明 | 适用场景 | 仓库链接 |
|-------|------|----------|----------|
| skill-miniprogram-ecosystem | 小程序开发生态 | 微信/抖音/支付宝小程序开发 | [Gitee](https://gitee.com/cheng-yanlin/skill-miniprogram-ecosystem) |
| skill-thesis-writer | 论文写作助手 | 学术论文写作 | [Gitee](https://gitee.com/cheng-yanlin/skill-thesis-writer) |

## 🚀 快速开始

### 方式一：一键下载所有 Skills（推荐）

**Windows:**
```powershell
.\install.ps1
```

**Linux/Mac:**
```bash
bash install.sh
```

### 方式二：手动克隆单个 Skill

```bash
# 小程序开发生态
git clone https://gitee.com/cheng-yanlin/skill-miniprogram-ecosystem.git

# 论文写作助手
git clone https://gitee.com/cheng-yanlin/skill-thesis-writer.git
```

### 方式三：让 AI 读取远程 SKILL.md

告诉 AI：
> "读取 https://gitee.com/cheng-yanlin/skill-xxx/raw/main/SKILL.md"

AI 会自动获取技能指令，无需下载到本地。

## 📁 目录结构

```
YYCLink-Skills/
├── README.md              # 本文件 - 技能总览
├── skills.json            # 技能配置文件
├── install.ps1            # Windows 一键下载脚本
├── install.sh             # Linux/Mac 一键下载脚本
├── .gitignore             # 忽略下载的 skill-*/ 文件夹
├── skill-miniprogram-ecosystem/   # 小程序技能（下载后）
└── skill-thesis-writer/           # 论文技能（下载后）
```

## 🔄 更新所有 Skills

```powershell
# Windows
.\install.ps1

# Linux/Mac  
bash install.sh
```

脚本会自动检测本地已存在的技能并执行 `git pull` 更新。

## 📝 添加新技能

1. 创建新的技能仓库，命名格式：`skill-xxx`
2. 在仓库根目录添加 `SKILL.md`，供 AI 识别
3. 在 `skills.json` 中添加配置
4. 更新本 README.md 的技能表格

## 🤖 AI 如何使用 Skills

### 方法 1：读取本地 SKILL.md（如果已下载）
```
用户：使用小程序技能
AI：读取 skill-miniprogram-ecosystem/SKILL.md 获取指令
```

### 方法 2：读取远程 SKILL.md（无需下载）
```
用户：使用小程序技能
AI：通过 HTTP 读取远程 SKILL.md 内容
```

---

**作者**: YYCLink  
**协议**: MIT License
