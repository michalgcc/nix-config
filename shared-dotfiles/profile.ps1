# Initial setup:
# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm

# Windows when repo is inside WSL:
# Edit profile.ps1 "code $PROFILE.CurrentUserAllHosts"
# Add the following, remember to replace <uname>
# # cp \\wsl.localhost\Ubuntu\home\<uname>\workspace\nix-config\shared-dotfiles\profile.ps1 ~/current.ps1
# # . ~/current.ps1

Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineOption -BellStyle None

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