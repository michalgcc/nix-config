# Initial setup:
# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm
# PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force

# Windows when repo is inside WSL:
# Edit profile.ps1 "code $PROFILE.CurrentUserAllHosts"
# Add the following, remember to replace <uname>
# # cp \\wsl.localhost\Ubuntu\home\<uname>\workspace\nix-config\shared-dotfiles\profile.ps1 ~/current.ps1
# # . ~/current.ps1

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

function GitAddAmendNoEditForcePush {
    git add -A && git commit --no-verify --amend --no-edit && git push --force-with-lease 
}

function KillWSL {
    wsl --shutdown
}