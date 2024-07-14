# Must be on start
source "$(blesh-share)"/ble.sh --attach=none # does not work currently

is_wsl() {
    grep -qi Microsoft /proc/version
}

is_windows_filesystem() {
    pwd -P | grep -q "^/mnt/c/*"
}

if is_wsl; then
    . ~/.nix-profile/etc/profile.d/nix.sh
fi

# PROMPT_COMMAND='PS1="$(powerline-go -newline -hostname-only-if-ssh)"; echo -ne "\033]0;$(pwd)\007"'
PROMPT_COMMAND='PS1="$(powerline-go -hostname-only-if-ssh; [ -n "$container" ] && echo "📦 \n"; [ -z "$container" ] && echo "\n")"; echo -ne "\033]0;$(pwd)\007"'

[ -z "$TMUX" ] && tmux new -A -s dflt

cp() {
    rsync -ah --progress $@
}

ii() {
    (nautilus . &>/dev/null &)
}

c() {
    if [ -z "$*" ]; then
        set -- "."
    fi

    command codium "$@" &>/dev/null
}

s() {
    if is_wsl; then
        explorer.exe "$(wslpath -aw "$@")"
    else
        echo "Not implemented. Implement when there is a use case."
    fi
}

git() {
    if is_windows_filesystem; then
        git.exe "$@"
    else
        command git "$@"
    fi
}

rg() {
    if is_windows_filesystem; then
        rg.exe "$@"
    else
        command rg "$@"
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
