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

# skim: prefer fd over find (gitignore-aware, much faster on large trees).
# Exported here rather than through home-manager so Git Bash gets them too.
export SKIM_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export SKIM_CTRL_T_COMMAND="$SKIM_DEFAULT_COMMAND"
export SKIM_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

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
    PATH=$(echo "$PATH" | sed 's/:/\n/g' | grep -P '^(?!\/mnt\/c\/(?!.*scoop\/shims.*$|.*PowerShell.*$|.*VS.Code.*$)).*' | sed -z 's/\n/:/g;s/:$//')

    # Aliases are expanded when a function is defined, not when it runs, so
    # these have to stay above the commands that use them
    alias explorer.exe="/mnt/c/Windows/explorer.exe"
    alias cmd.exe="/mnt/c/Windows/system32/cmd.exe"
    alias ssh.exe="/mnt/c/Windows/System32/OpenSSH/ssh.exe"

    starship_precmd_user_func='prepend_or_remove_wsl_mnt_override_path'
    PROMPT_COMMAND='prepend_or_remove_wsl_mnt_override_path'
fi

# --- History ---

# Write each command to the history file as soon as it has run, not only when
# the shell exits. A killed shell (a closed Windows Terminal tab, a crash)
# then loses nothing, and new shells see commands from ones still open.
# Appended, so it keeps any hook set before it, and below the WSL block,
# which assigns PROMPT_COMMAND outright. starship, zoxide and direnv, set up
# after this, keep it and still see the right exit status.
if [[ $- == *i* ]]; then
    PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}history -a"
fi

# --- Git Bash ---

# No home-manager here to source the skim, starship and zoxide integrations; on
# Linux and WSL it does that later in the generated bashrc.
# Git Bash already provides coreutils, grep/sed/awk/find, ssh and curl; the only
# Windows prerequisites are:
#   scoop install skim fd starship zoxide     # bashrc requirements
#   scoop install yazi gitui                  # optional, matching the Nix side
# VS Code's `code` is expected on PATH for the c() helper.
if [[ $PLATFORM == gitbash && $- == *i* ]]; then
    # Git Bash defaults to a visible bell, which flashes the whole window
    bind 'set bell-style none'

    # Same history settings as home-manager generates on Linux and WSL
    HISTSIZE=10000
    HISTFILESIZE=100000
    shopt -s histappend

    # Git Bash does not count .bat, .cmd and .ps1 files as executable, so Tab
    # on a command skips them. Offer them as well, next to the directories
    # and executables bash would list anyway.
    _complete_windows_scripts() {
        local file
        COMPREPLY=()
        # Without a slash the command comes from PATH - leave that to bash
        [[ $2 == */* ]] || return 0
        while IFS= read -r file; do
            case ${file,,} in
            *.bat | *.cmd | *.ps1) COMPREPLY+=("$file") ;;
            *) [[ -d $file || -x $file ]] && COMPREPLY+=("$file") ;;
            esac
        done < <(compgen -f -- "$2")

        # .bat and .cmd run as they are, but bash cannot run a .ps1. Once one
        # is the only match, complete it to "pwsh <script>". That is inserted
        # as typed text, so it needs the quoting readline would have added.
        if [[ ${#COMPREPLY[@]} == 1 && ${COMPREPLY[0],,} == *.ps1 ]]; then
            compopt +o filenames
            printf -v file '%q' "${COMPREPLY[0]}"
            COMPREPLY=("pwsh $file")
        fi
    }
    complete -I -o bashdefault -o filenames -F _complete_windows_scripts

    command -v sk >/dev/null && source <(sk --shell bash --shell-bindings)
    command -v starship >/dev/null && eval "$(starship init bash)"
    command -v zoxide >/dev/null && eval "$(zoxide init bash)"
fi

# --- Commands ---

alias s='git status'
alias gu='gitui'

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

unlock_remote_server_luks() {
    while true; do
        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@192.168.8.121
        sleep 1
    done
}

# Secrets (bash port of the former ~/.scr.nu)
[ -f "$HOME/.scr.sh" ] && . "$HOME/.scr.sh"
