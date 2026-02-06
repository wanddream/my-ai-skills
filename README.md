# YYCLink AI Skills

YYCLink 的个人 AI Skill 集合，用于 Claude Code 等 AI 编程助手。

> 📋 **本仓库是技能索引中心**，每个技能都是独立仓库，可单独下载使用。

## 🎯 我的 Skills

| Skill | 说明 | 适用场景 | GitHub |
|-------|------|----------|--------|
| skill-miniprogram-ecosystem | 小程序开发生态 | 微信/抖音/支付宝小程序开发 | [GitHub](https://github.com/wanddream/skill-miniprogram-ecosystem) |
| skill-thesis-writer | 论文写作助手 | 学术论文写作 | [GitHub](https://github.com/wanddream/skill-thesis-writer) |
| skill-product-manager | 产品经理拷打 | 产品方案评审/从0到1打磨 | [GitHub](https://github.com/wanddream/skill-product-manager) |

## 🚀 快速开始

### 方式一：一键下载所有 Skills（推荐）

**Windows 用户：**

直接双击 **`run.bat`** 即可自动下载/更新所有 Skills。

> 如果双击没反应，可能是 PowerShell 执行策略限制，右键 `install.ps1` → 使用 PowerShell 运行。

**Linux/Mac:**
```bash
# 手动克隆
git clone https://github.com/wanddream/skill-miniprogram-ecosystem.git
git clone https://github.com/wanddream/skill-thesis-writer.git
```

### 方式二：手动克隆单个 Skill

```bash
# 小程序开发生态
git clone https://github.com/wanddream/skill-miniprogram-ecosystem.git

# 论文写作助手
git clone https://github.com/wanddream/skill-thesis-writer.git

# 产品经理拷打
git clone https://github.com/wanddream/skill-product-manager.git
```

### 方式三：让 AI 读取远程 SKILL.md

告诉 AI：
> "读取 https://github.com/wanddream/skill-xxx/raw/main/SKILL.md"

AI 会自动获取技能指令，无需下载到本地。

## 📁 目录结构

```
YYCLink-Skills/
├── README.md              # 本文件 - 技能总览
├── install.ps1            # Windows 一键下载/更新脚本
├── run.bat                # 双击运行入口
├── .gitignore             # 忽略下载的 skill-*/ 文件夹
├── skill-miniprogram-ecosystem/   # 小程序技能（下载后）
├── skill-thesis-writer/           # 论文技能（下载后）
└── skill-product-manager/         # 产品经理拷打（下载后）
```

## 🔄 更新所有 Skills

直接双击 **`run.bat`**，脚本会自动检测本地已存在的技能并执行 `git pull` 更新。

## ➕ 如何添加新 Skill

### 第 1 步：创建新技能仓库

1. 在 GitHub 创建新仓库，命名格式：`skill-<功能名>`
   - 例如：`skill-web-dev`、`skill-python-ml`

2. 本地创建技能结构：
```
skill-xxx/
├── SKILL.md          # 核心技能文件（必填）
├── README.md         # 技能说明文档
├── examples/         # 示例代码（可选）
└── .gitignore
```

### 第 2 步：编写 SKILL.md

`SKILL.md` 是 AI 读取的核心文件，告诉 AI 如何使用这个技能。

**⚠️ 重要：必须包含 `name` 字段**，否则 CodeBuddy 无法正确识别技能名称：

```markdown
---
name: skill-xxx
---

# Skill: 技能名称

## 描述
这个技能是做什么的...

## 触发词
当用户说以下关键词时触发此技能：
- "关键词1"
- "关键词2"

## 指令
当技能被触发时，AI 应该：
1. 第一步做什么
2. 第二步做什么

## 示例
用户：xxx
AI：xxx
```

> 💡 **提示**：开头的 YAML Front Matter `name: skill-xxx` 是 CodeBuddy 识别技能的关键，必须与仓库名保持一致。

### 第 3 步：添加到 install.ps1

打开 `install.ps1`，在 `$repos = @( ... )` 数组中添加新条目：

```powershell
$repos = @(
    @{
        name = "skill-miniprogram-ecosystem"
        url  = "https://github.com/wanddream/skill-miniprogram-ecosystem.git"
    },
    @{
        name = "skill-thesis-writer"
        url  = "https://github.com/wanddream/skill-thesis-writer.git"
    },
    # ====== 在这里添加新技能 ======
    @{
        name = "skill-web-dev"
        url  = "https://github.com/username/skill-web-dev.git"
    }
)
```

### 第 4 步：更新 README.md

1. 在 "我的 Skills" 表格中添加新技能：

```markdown
| skill-web-dev | Web开发指南 | 前端/后端开发 | [GitHub](https://github.com/username/skill-web-dev) |
```

2. 更新"目录结构"部分，删除 `skills.json` 的引用

### 第 5 步：提交并推送

```bash
git add .
git commit -m "添加新技能: skill-web-dev"
git push
```

### 完整示例流程

```bash
# 1. 创建新仓库
mkdir skill-web-dev
cd skill-web-dev
git init

# 2. 创建 SKILL.md
cat > SKILL.md << 'EOF'
# Skill: Web开发

## 描述
前端和后端开发最佳实践

## 触发词
- "web开发"
- "前端"
- "后端"

## 指令
1. 询问用户具体需求
2. 提供技术方案
EOF

# 3. 提交到 GitHub
git add .
git commit -m "init"
git remote add origin https://github.com/username/skill-web-dev.git
git push -u origin main

# 4. 在索引仓库更新配置
cd ../YYCLink-Skills
# 编辑 install.ps1 在 $repos 数组中添加新技能
# 编辑 README.md 添加表格行

git add .
git commit -m "添加 skill-web-dev"
git push
```

## 🔧 在 CodeBuddy 中使用

### 导入方式（推荐「用户 Skill」）

打开 CodeBuddy → 设置 → 技能 → 导入 Skill

| 类型 | 适用场景 | 特点 |
|------|----------|------|
| **用户 Skill** ⭐ | 个人通用技能 | 跨项目全局可用，切换项目自动继承 |
| 项目 Skill | 项目专属规范 | 仅当前项目有效，换项目需重新导入 |

> 💡 **建议**：个人开发的技能一律作为「用户 Skill」导入，这样在任何项目中都能使用，无需重复配置。

### 使用步骤

1. **下载 Skill**：通过本仓库的 `run.bat` 一键下载所有技能
2. **导入 CodeBuddy**：设置 → 技能 → 导入 Skill → 选择下载好的 `SKILL.md` 文件
3. **选择「用户 Skill」**：确保导入时选择「用户 Skill」类型
4. **开启使用**：在技能列表中开启对应的技能开关即可

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
