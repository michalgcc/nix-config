# Shared bash config. On Linux and WSL home-manager embeds it in the generated
# ~/.bashrc (see bash.nix); on Windows the Git Bash ~/.bashrc sources it.

# --- Platform ---

# Cannot change within a session - evaluate once at startup
if grep -qi Microsoft /proc/version 2>/dev/null; then
    PLATFORM=wsl
elif [[ $OSTYPE == msys || $OSTYPE == cygwin ]]; then
    PLATFORM=gitbash
else
    PLATFORM=linux
fi

# --- PATH ---

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

# --- Shell ---

# Prefer a readline-enabled bash when the environment provides a crippled one
# (e.g. nix devshells put stdenv's build bash in PATH)
if [ -x "$HOME/.nix-profile/bin/bash" ]; then
    alias bash="$HOME/.nix-profile/bin/bash"
fi

# Better ctrl + backspace line erase
if [[ $- == *i* ]]; then
    stty werase undef
    bind '\C-w:unix-filename-rubout'
fi

# fzf: prefer fd over find (gitignore-aware, much faster on large trees).
# Exported here rather than through home-manager so Git Bash gets them too.
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# --- WSL ---

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

is_windows_filesystem() {
    # $PWD is the logical path; a symlink into /mnt/c would not match here
    [[ $PWD == /mnt/c/* ]]
}

# Runs before every prompt: the Windows executables linked above come first in
# PATH while inside /mnt/c, and are taken out again everywhere else
prepend_or_remove_wsl_mnt_override_path() {
    if is_windows_filesystem; then
        prepend_path_if_not_found "$wsl_mnt_override"
    else
        remove_path "$wsl_mnt_override"
    fi
}

if [[ $PLATFORM == wsl ]]; then
    . ~/.nix-profile/etc/profile.d/nix.sh
    link_wsl_exe "git.exe" "git"
    link_wsl_exe "gitk.exe" "gitk"
    link_wsl_exe "rg.exe" "rg"
    link_wsl_exe "lazygit.exe" "lazygit"
    PATH=$(echo "$PATH" | sed 's/:/\n/g' | grep -P '^(?!\/mnt\/c\/(?!.*scoop\/shims.*$|.*PowerShell.*$|.*VS.Code.*$)).*' | sed -z 's/\n/:/g;s/:$//')

    # Aliases are expanded when a function is defined, not when it runs, so
    # these have to stay above the commands that use them
    alias explorer.exe="/mnt/c/Windows/explorer.exe"
    alias cmd.exe="/mnt/c/Windows/system32/cmd.exe"
    alias ssh.exe="/mnt/c/Windows/System32/OpenSSH/ssh.exe"

    starship_precmd_user_func='prepend_or_remove_wsl_mnt_override_path'
    PROMPT_COMMAND='prepend_or_remove_wsl_mnt_override_path'
fi

# --- Git Bash ---

# No home-manager here to source the fzf, starship and zoxide integrations; on
# Linux and WSL it does that later in the generated bashrc.
# Windows prerequisites: scoop install fzf fd starship zoxide
if [[ $PLATFORM == gitbash && $- == *i* ]]; then
    # Git Bash defaults to a visible bell, which flashes the whole window
    bind 'set bell-style none'

    command -v fzf >/dev/null && eval "$(fzf --bash)"
    command -v starship >/dev/null && eval "$(starship init bash)"
    command -v zoxide >/dev/null && eval "$(zoxide init bash)"
fi

# --- Commands ---

alias s='git status'
alias lg='lazygit'

# opencode alias
alias opencode="steam-run opencode"

# rsync as cp, for the progress display. Git Bash has no rsync.
if [[ $PLATFORM != gitbash ]]; then
    cp() {
        rsync -ah --progress "$@"
    }
fi

# Open paths in the file manager, the current directory by default
ii() {
    if [ -z "$*" ]; then
        set -- "."
    fi

    # explorer.exe wants Windows paths, takes one at a time and exits 1 even
    # on success
    local path
    case $PLATFORM in
    wsl)
        for path in "$@"; do
            explorer.exe "$(wslpath -aw "$path")"
        done
        return 0
        ;;
    gitbash)
        for path in "$@"; do
            explorer.exe "$(cygpath -w "$path")"
        done
        return 0
        ;;
    linux)
        (dolphin "$@" &>/dev/null &)
        ;;
    esac
}

# Open paths in the editor, the current directory by default
c() {
    if [ -z "$*" ]; then
        set -- "."
    fi

    case $PLATFORM in
    wsl)
        if is_windows_filesystem; then
            local path windows_paths=()
            for path in "$@"; do
                windows_paths+=("$(wslpath -aw "$path")")
            done
            cmd.exe /c code.cmd "${windows_paths[@]}"
        else
            code "$@" &>/dev/null
        fi
        ;;
    gitbash)
        code "$@" &>/dev/null
        ;;
    linux)
        command codium "$@" &>/dev/null
        ;;
    esac
}

ssh() {
    case $PLATFORM in
    wsl) ssh.exe "$@" ;;
    *) command ssh "$@" ;;
    esac
}

pwsh() {
    case $PLATFORM in
    wsl) pwsh.exe "$@" ;;
    *) command pwsh "$@" ;;
    esac
}

tmuxd() {
    [ -z "$TMUX" ] && tmux new -A -s dflt
}

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

# Secrets (bash port of the former ~/.scr.nu)
[ -f "$HOME/.scr.sh" ] && . "$HOME/.scr.sh"
