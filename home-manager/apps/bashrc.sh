# Must be on start
source "$(blesh-share)"/ble.sh --attach=none # does not work currently

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
    link_wsl_exe "rg.exe" "rg"
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

PROMPT_COMMAND='prepend_or_remove_wsl_mnt_override_path && PS1="$(powerline-go -hostname-only-if-ssh; [ -n "$container" ] && echo "📦 \n"; [ -z "$container" ] && echo "\n")"; echo -ne "\033]0;$(pwd)\007"'

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
        code "$@" &>/dev/null
    else
        command codium "$@" &>/dev/null
    fi
}

s() {
    if is_wsl; then
        explorer.exe "$(wslpath -aw "$@")"
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

# Native functions

search() {
    nix search nixpkgs "$@"
}

clipboard() {
    wl-copy
}

git_add_rebase_i() {
    git add -A && git commit -m "x" && git rebase -i HEAD~2
}

git_add_amend_no_edit_force_push() {
    git add -A && git commit --no-verify --amend --no-edit && git push --force-with-lease
}

git_reset_hard() {
    git reset --hard "@{u}"
}

git_fetch_reset() {
    git fetch
    git reset --hard "@{u}"
}

git_pull_all() {
    find . -maxdepth 2 -type d -name .git -execdir git pull \;
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

# For direnv with ble-sh
if ! is_wsl; then
    eval "$(direnv hook bash)"
fi

# Must be at the end
[[ ${BLE_VERSION-} ]] && ble-attach
