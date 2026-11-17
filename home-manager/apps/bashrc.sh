# set -o vi

# Prefer a readline-enabled bash when the environment provides a crippled one
# (e.g. nix devshells put stdenv's build bash in PATH)
if [ -x "$HOME/.nix-profile/bin/bash" ]; then
    alias bash="$HOME/.nix-profile/bin/bash"
fi

# Better ctrl + backspace line erase
if type -t bind >/dev/null 2>&1; then
    stty werase undef
    bind '\C-w:unix-filename-rubout'
fi

# fzf: prefer fd over find (gitignore-aware, much faster on large trees).
# Exported here so this file also works on Git Bash (Windows), where
# home-manager is absent. Windows prerequisites: scoop install fzf fd
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Git Bash has no home-manager to source the fzf integration - do it here.
# On Linux/WSL home-manager sources it later in the generated bashrc.
if [[ $- == *i* ]] && [[ $OSTYPE == msys || $OSTYPE == cygwin ]] && command -v fzf >/dev/null; then
    eval "$(fzf --bash)"
fi

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

# WSL detection cannot change within a session - evaluate once at startup
if grep -qi Microsoft /proc/version 2>/dev/null; then
    IS_WSL=1
else
    IS_WSL=0
fi

is_wsl() {
    [[ $IS_WSL == 1 ]]
}

is_windows_filesystem() {
    # $PWD is the logical path; a symlink into /mnt/c would not match here
    [[ $PWD == /mnt/c/* ]]
}

prepend_path_if_not_found() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1:$PATH"
    fi
}

remove_path() {
    local out="" entry
    local IFS=:
    for entry in $PATH; do
        [ -n "$entry" ] && [ "$entry" != "$1" ] && out+="$entry:"
    done
    PATH="${out%:}"
}

# Add npm global packages to PATH
prepend_path_if_not_found "$HOME/.npm-global/bin"

if is_wsl; then
    . ~/.nix-profile/etc/profile.d/nix.sh
    link_wsl_exe "git.exe" "git"
    link_wsl_exe "gitk.exe" "gitk"
    link_wsl_exe "rg.exe" "rg"
    link_wsl_exe "lazygit.exe" "lazygit"
    PATH=$(echo $PATH | sed 's/:/\n/g' | grep -P '^(?!\/mnt\/c\/(?!.*scoop\/shims.*$|.*PowerShell.*$|.*VS.Code.*$)).*' | sed -z 's/\n/:/g;s/:$//')

    alias explorer.exe="/mnt/c/Windows/explorer.exe"
    alias cmd.exe="/mnt/c/Windows/system32/cmd.exe"
    alias ssh.exe="/mnt/c/Windows/System32/OpenSSH/ssh.exe"
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

tmuxd() {
    [ -z "$TMUX" ] && tmux new -A -s dflt
}

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

lg() {
    lazygit
}

# opencode alias
alias opencode="steam-run opencode"

# Secrets (bash port of the former ~/.scr.nu)
[ -f "$HOME/.scr.sh" ] && . "$HOME/.scr.sh"
