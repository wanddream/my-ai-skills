#!/usr/bin/env pwsh
<#
.SYNOPSIS
    YYCLink AI Skills 一键下载/更新脚本 (Windows)
.DESCRIPTION
    自动从 Gitee 下载或更新所有 Skill 仓库
    如果本地已存在，则执行 git pull 更新
    如果不存在，则执行 git clone 克隆
.EXAMPLE
    .\install.ps1
#>

param(
    [switch]$Force,
    [string]$ConfigFile = "skills.json"
)

Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "   YYCLink AI Skills - 下载/更新工具" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# 检查配置文件
if (-not (Test-Path $ConfigFile)) {
    Write-Error "❌ 配置文件不存在: $ConfigFile"
    exit 1
}

# 读取配置
try {
    $config = Get-Content $ConfigFile | ConvertFrom-Json
} catch {
    Write-Error "❌ 配置文件解析失败: $_"
    exit 1
}

Write-Host "📋 发现 $($config.skills.Count) 个 Skills:" -ForegroundColor Yellow
foreach ($skill in $config.skills) {
    Write-Host "   • $($skill.name) - $($skill.description)" -ForegroundColor Gray
}
Write-Host ""

# 统计变量
$cloned = 0
$pulled = 0
$failed = 0

# 处理每个技能
foreach ($skill in $config.skills) {
    $skillName = $skill.name
    $repository = $skill.repository
    
    Write-Host "───────────────────────────────────────────────" -ForegroundColor DarkGray
    
    if (Test-Path $skillName) {
        # 已存在，执行更新
        Write-Host "📦 $skillName 已存在，正在更新..." -ForegroundColor Yellow
        
        # 检查是否是 git 仓库
        if (Test-Path "$skillName\.git") {
            try {
                Push-Location $skillName
                $result = git pull 2>&1
                Pop-Location
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "✅ 更新成功" -ForegroundColor Green
                    if ($result -match "Already up.to.date") {
                        Write-Host "   已经是最新版本" -ForegroundColor Gray
                    } else {
                        Write-Host "   $result" -ForegroundColor Gray
                    }
                    $pulled++
                } else {
                    Write-Host "⚠️  更新失败: $result" -ForegroundColor Red
                    $failed++
                }
            } catch {
                Write-Host "⚠️  更新异常: $_" -ForegroundColor Red
                $failed++
            }
        } else {
            Write-Host "⚠️  $skillName 不是 git 仓库，跳过" -ForegroundColor Red
            $failed++
        }
    } else {
        # 不存在，执行克隆
        Write-Host "📥 $skillName 下载中..." -ForegroundColor Cyan
        
        try {
            $result = git clone $repository $skillName 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ 下载成功" -ForegroundColor Green
                $cloned++
            } else {
                Write-Host "❌ 下载失败: $result" -ForegroundColor Red
                $failed++
            }
        } catch {
            Write-Host "❌ 下载异常: $_" -ForegroundColor Red
            $failed++
        }
    }
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "   完成统计" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "   新下载: $cloned" -ForegroundColor Green
Write-Host "   已更新: $pulled" -ForegroundColor Yellow
Write-Host "   失败:   $failed" -ForegroundColor $(if ($failed -gt 0) { "Red" } else { "Gray" })
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan

# 列出本地 Skills
Write-Host ""
Write-Host "📁 本地 Skills:" -ForegroundColor Yellow
Get-ChildItem -Directory -Filter "skill-*" | ForEach-Object {
    $size = (Get-ChildItem $_.FullName -Recurse -File | Measure-Object -Property Length -Sum).Sum
    $sizeMB = [math]::Round($size / 1MB, 2)
    Write-Host "   📂 $($_.Name) (${sizeMB} MB)" -ForegroundColor Gray
}

exit $failed
