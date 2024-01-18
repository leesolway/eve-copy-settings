<#
.SYNOPSIS
This script is used for managing EVE Online user profiles and character data.
.DESCRIPTION
The script copies settings from a source account and character to multiple target accounts and characters.
#>

$sourceAcc = "111-acc-id"
$sourceChar = "111-char-id"

$accountArr = @("222-acc-id", "333-acc-id")
$charArr = @("222-char-id", "333-char-id", "444-char-id")

$profileName = "settings_Default"
$basePath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "\CCP\EVE\c_program_files_(x86)_steam_steamapps_common_eve_online_sharedcache_tq_tranquility"

$profilePath = Join-Path -Path $basePath -ChildPath $profileName -Resolve
$profileBackupPath = Join-Path -Path $basePath -ChildPath "$profileName-$(Get-Date -format 'yyyy_MM_dd_hh_mm_ss')"

# Backup function
function Backup-Profiles {
    Write-Host "`n1. Backing up files.." -ForegroundColor Yellow
    try {
        Copy-Item -Path $profilePath -Destination $profileBackupPath -Recurse
        Write-Host "Backup Complete" -ForegroundColor Green
    } catch {
        Write-Host "Error during backup: $_" -ForegroundColor Red
    }
}

# Copy account data function
function Copy-AccountData {
    Write-Host "`n2. Copying accounts from: $sourceAcc" -ForegroundColor Yellow
    $progress = 0
    foreach ($accountNumber in $accountArr) {
        $progress++
        $sourceFileName = "core_user_$($sourceAcc).dat"
        $destFileName = "core_user_$($accountNumber).dat"

        $sourcePath = Join-Path -Path $profilePath -ChildPath $sourceFileName -Resolve
        $destPath = Join-Path -Path $profilePath -ChildPath $destFileName

        try {
            Write-Progress -Activity "Copying accounts" -Status "$progress of $($accountArr.Count)" -PercentComplete (($progress / $accountArr.Count) * 100)
            Copy-Item -Path $sourcePath -Destination $destPath
            Write-Host "  - Copied to $accountNumber" -ForegroundColor Green
        } catch {
            Write-Host "  - Error copying to ${accountNumber}: $_" -ForegroundColor Red
        }
    }
    Write-Host "Account Copy Complete`n" -ForegroundColor Green
}

# Copy character data function
function Copy-CharacterData {
    Write-Host "`n3. Copying characters from: $sourceChar" -ForegroundColor Yellow
    $progress = 0
    foreach ($charNumber in $charArr) {
        $progress++
        $sourceFileName = "core_char_$($sourceChar).dat"
        $destFileName = "core_char_$($charNumber).dat"

        $sourcePath = Join-Path -Path $profilePath -ChildPath $sourceFileName -Resolve
        $destPath = Join-Path -Path $profilePath -ChildPath $destFileName

        try {
            Write-Progress -Activity "Copying characters" -Status "$progress of $($charArr.Count)" -PercentComplete (($progress / $charArr.Count) * 100)
            Copy-Item -Path $sourcePath -Destination $destPath
            Write-Host "  - Copied to $charNumber" -ForegroundColor Green
        } catch {
            Write-Host "  - Error copying to ${charNumber}: $_" -ForegroundColor Red
        }
    }
    Write-Host "Character Copy Complete`n" -ForegroundColor Green
}

# Script execution
Backup-Profiles
Copy-AccountData
Copy-CharacterData
