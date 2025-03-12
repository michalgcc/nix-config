# Initial setup:
# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm
# PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force

# Windows when repo is inside WSL:
# Edit profile.ps1 "code $PROFILE.CurrentUserAllHosts"
# Add the following, remember to replace <uname> and make sure the distro is ok

# # # $sourcePath = "\\wsl.localhost\Ubuntu-24.04\home\<uname>\workspace\nix-config\shared-dotfiles\profile.ps1"
# # # $destPath = "~/current.ps1"
# # # $sourceHash = (Get-FileHash -Path $sourcePath -Algorithm SHA256).Hash
# # # $destHash = (Get-FileHash -Path $destPath -Algorithm SHA256 -ErrorAction SilentlyContinue).Hash
# # # if ($sourceHash -ne $destHash) {
# # #     Copy-Item -Path $sourcePath -Destination $destPath
# # #     Write-Host "profile.ps1 has been updated."
# # # }
# # # . ~/current.ps1

Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineOption -BellStyle None
Import-Module posh-git

function C {
    param (
        [Parameter(ValueFromRemainingArguments=$true)]
        $args
    )

    if ($args.Count -eq 0) {
        $args = "."
    }

    code $args
}

if ($IsWindows) {
    Remove-Alias -Force ii
}

function ii {
    param (
        [Parameter(ValueFromRemainingArguments=$true)]
        $args
    )

    if ($args.Count -eq 0) {
        $args = "."
    }

    Invoke-Item $args
}

# function GitAddAmendNoEditForcePush {
#     git add -A && git commit --no-verify --amend --no-edit && git push --force-with-lease 
# }

# function GitPullWithSubmodules {
#     git pull --recurse-submodules
# }

# function GitFetchSrcToDstAndRebase {
#     param (
#         [ArgumentCompletions('develop', 'main')]
#         [string]$branchName
#     )

#     git fetch origin ${branchName}:${branchName}
#     git rebase ${branchName}
# }

# function GitCleanCheckout {
#     git clean -f
#     git checkout -- $(git ls-files -m)
# }

if ($IsWindows) {
    function KillWSL {
        wsl --shutdown
    }
}

if ($IsWindows) {
    Remove-Alias rm
    function rm {
        Remove-Item -Recurse -Force $args
    }
}

function cdw {
    # Set env variable PsCdwDir - Change Directory Work
    # [Environment]::SetEnvironmentVariable("PsCdwDir", "C:\workspace", [System.EnvironmentVariableTarget]::User)
    cd $Env:PsCdwDir
}

if ($IsWindows) {
    function DisableDeviceWake {
        $devices = powercfg /DEVICEQUERY wake_armed

        foreach ($device in $devices)
        {
            powercfg /DEVICEDISABLEWAKE "$device"
        }
    }
}

function lg {
    lazygit
}