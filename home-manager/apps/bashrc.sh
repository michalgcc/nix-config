# Must be on start
source "$(blesh-share)"/ble.sh --attach=none # does not work currently
set -o vi

# Better ctrl + backspace line erase
stty werase undef
bind '\C-w:unix-filename-rubout'

wsl_mnt_override="$HOME/.config/wsl_mnt_override/"

link_wsl_exe() {
    local windows_exe="$1"
    local linux_exe="$2"

    local windows_exe_path
    windows_exe_path=$(type -a -P "$windows_exe")

    if [[ -z "$windows_exe_path" ]]; then
        echo "Error: $windows_exe not found"
        return 1
    fi

    mkdir -p "$wsl_mnt_override"

    local symlink_path="$wsl_mnt_override$(basename "$linux_exe")"

    if [[ -L "$symlink_path" ]]; then
        return 0
    fi

    ln -s "$windows_exe_path" "$symlink_path"
}

is_wsl() {
    grep -qi Microsoft /proc/version
}

is_windows_filesystem() {
    pwd -P | grep -q "^/mnt/c/*"
}

prepend_path_if_not_found() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1:$PATH"
    fi
}

remove_path() {
    PATH=$(echo "$PATH" | awk -v RS=: -v ORS=: '$0 != "'"$1"'"' | sed 's/:$//')
}

if is_wsl; then
    . ~/.nix-profile/etc/profile.d/nix.sh
    link_wsl_exe "git.exe" "git"
    link_wsl_exe "gitk.exe" "gitk"
    link_wsl_exe "rg.exe" "rg"
    PATH=$(echo $PATH | sed 's/:/\n/g' | grep -P '^(?!\/mnt\/c\/(?!.*scoop\/shims.*$|.*PowerShell.*$|.*VS.Code.*$)).*' | sed -z 's/\n/:/g;s/:$//')

    alias explorer.exe="/mnt/c/Windows/explorer.exe"
    alias cmd.exe="/mnt/c/Windows/system32/cmd.exe"
fi

prepend_or_remove_wsl_mnt_override_path() {
    if is_wsl; then
        if is_windows_filesystem; then
            prepend_path_if_not_found $wsl_mnt_override
        else
            remove_path $wsl_mnt_override
        fi
    fi
}

starship_precmd_user_func='prepend_or_remove_wsl_mnt_override_path'
PROMPT_COMMAND='prepend_or_remove_wsl_mnt_override_path'

[ -z "$TMUX" ] && tmux new -A -s dflt

cp() {
    rsync -ah --progress $@
}

ii() {
    if [ -z "$*" ]; then
        set -- "."
    fi

    if is_wsl; then
        explorer.exe "$@"
    else
        (dolphin "$@" &>/dev/null &)
    fi
}

c() {
    if [ -z "$*" ]; then
        set -- "."
    fi

    if is_wsl; then
        if is_windows_filesystem; then
            cmd.exe /c code.cmd $(wslpath -aw "$@")
        else
            code "$@" &>/dev/null
        fi
    else
        command codium "$@" &>/dev/null
    fi
}

e() {
    if is_wsl; then
        explorer.exe "$(wslpath -aw "$@")" || return 0
    else
        echo "Not implemented. Implement when there is a use case."
    fi
}

ssh() {
    if is_wsl; then
        ssh.exe "$@"
    else
        command ssh "$@"
    fi
}

s() {
    git status
}

pwsh() {
    if is_wsl; then
        pwsh.exe "$@"
    else
        command pwsh "$@"
    fi
}

# Native functions

search() {
    nix search nixpkgs "$@"
}

clipboard() {
    wl-copy
}

qransiencode() {
    echo "Paste what you want to generate as QR and confirm with Enter + CTRL + D"
    qrencode -t ansiutf8
}

unlock_remote_server_luks() {
    while true; do
        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@192.168.8.121
        sleep 1
    done
}

eval "$(starship init bash)"
# For direnv with ble-sh
if ! is_wsl; then
    eval "$(direnv hook bash)"
fi

# Must be at the end
[[ ${BLE_VERSION-} ]] && ble-attach
