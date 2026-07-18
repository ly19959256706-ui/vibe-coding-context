# 为 heavy 档初始化独立规划目录。
# 所有模板路径均从本脚本所在的 skill 目录解析。

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TaskName,

    [string]$WorkingDirectory = (Get-Location).Path,

    [ValidateSet("Auto", "Project", "Standalone")]
    [string]$Mode = "Auto"
)

$ErrorActionPreference = "Stop"
$Utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$ScriptDir = $PSScriptRoot
$SkillDir = Split-Path -Parent $ScriptDir
$TemplateDir = Join-Path $SkillDir "templates\planning"

function ConvertTo-TaskSlug {
    param([string]$Value)

    $slug = $Value.Trim().ToLowerInvariant()
    $slug = [regex]::Replace($slug, "[^\p{L}\p{Nd}]+", "-")
    $slug = $slug.Trim("-")
    if ([string]::IsNullOrWhiteSpace($slug)) {
        return "任务"
    }
    return $slug
}

function Find-ProjectRoot {
    param([string]$StartPath)

    $resolved = (Resolve-Path -LiteralPath $StartPath).Path
    $git = Get-Command git -ErrorAction SilentlyContinue

    if ($git) {
        $previousPreference = $ErrorActionPreference
        $ErrorActionPreference = "SilentlyContinue"
        $gitRoot = & $git.Source -C $resolved rev-parse --show-toplevel 2>$null
        $gitExitCode = $LASTEXITCODE
        $ErrorActionPreference = $previousPreference

        if ($gitExitCode -eq 0 -and $gitRoot) {
            return (Resolve-Path -LiteralPath $gitRoot.Trim()).Path
        }
    }

    $markers = @(
        ".git", "pyproject.toml", "package.json", "Cargo.toml", "go.mod",
        "pom.xml", "build.gradle", "build.gradle.kts", "*.sln"
    )

    $current = [System.IO.DirectoryInfo]::new($resolved)
    while ($current) {
        foreach ($marker in $markers) {
            $found = Get-ChildItem -LiteralPath $current.FullName -Filter $marker -Force -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($found) {
                return $current.FullName
            }
        }
        $current = $current.Parent
    }

    return $null
}

function Write-PlanningFile {
    param(
        [string]$TemplateName,
        [string]$Destination,
        [hashtable]$Replacements
    )

    if (Test-Path -LiteralPath $Destination) {
        Write-Host "$(Split-Path -Leaf $Destination) 已存在，跳过"
        return
    }

    $templatePath = Join-Path $TemplateDir $TemplateName
    $content = Get-Content -Raw -Encoding UTF8 -LiteralPath $templatePath
    foreach ($entry in $Replacements.GetEnumerator()) {
        $content = $content.Replace($entry.Key, $entry.Value)
    }

    [System.IO.File]::WriteAllText($Destination, $content, $Utf8NoBom)
    Write-Host "已创建 $(Split-Path -Leaf $Destination)"
}

$workDir = (Resolve-Path -LiteralPath $WorkingDirectory).Path
$projectRoot = Find-ProjectRoot $workDir
$effectiveMode = $Mode

if ($Mode -eq "Auto") {
    $effectiveMode = if ($projectRoot) { "Project" } else { "Standalone" }
}

if ($effectiveMode -eq "Project" -and $projectRoot) {
    $baseDir = $projectRoot
} else {
    $baseDir = $workDir
}

$slug = ConvertTo-TaskSlug $TaskName
$planningRoot = Join-Path $baseDir ".planning"
$planningDir = Join-Path $planningRoot $slug
[System.IO.Directory]::CreateDirectory($planningDir) | Out-Null

$replacements = @{
    "[任务名称]" = $TaskName
    "[日期]" = (Get-Date -Format "yyyy-MM-dd")
}

Write-Host "正在初始化 heavy 规划文件：$TaskName"
Write-Host "规划目录：$planningDir"

Write-PlanningFile -TemplateName "plan.md" -Destination (Join-Path $planningDir "plan.md") -Replacements $replacements
Write-PlanningFile -TemplateName "progress.md" -Destination (Join-Path $planningDir "progress.md") -Replacements $replacements
Write-PlanningFile -TemplateName "findings.md" -Destination (Join-Path $planningDir "findings.md") -Replacements $replacements

Write-Host "规划文件初始化完成"
Write-Output "PLANNING_DIR=$planningDir"
