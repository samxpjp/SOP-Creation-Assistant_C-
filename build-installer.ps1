param(
    [string]$Runtime = "win-x64"
)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
$publishDir = Join-Path $root "publish_installer"
$iscc = @(
    "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe",
    "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
    "$env:ProgramFiles\Inno Setup 6\ISCC.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $iscc) { throw "找不到 Inno Setup 6 (winget install JRSoftware.InnoSetup)" }

if (Test-Path $publishDir) { Remove-Item $publishDir -Recurse -Force }

# 不使用單檔自我解壓，降低防毒誤判機率
dotnet publish (Join-Path $root "SOPCreationAssistant.csproj") -c Release -r $Runtime --self-contained true -o $publishDir
if ($LASTEXITCODE -ne 0) { throw "dotnet publish 失敗" }

& $iscc (Join-Path $root "installer\SOPCreationAssistant.iss")
if ($LASTEXITCODE -ne 0) { throw "Inno Setup 編譯失敗" }

Write-Host (Join-Path $root "installer_output\SOP Creation Assistant Setup v2026.10.25.1.exe")
