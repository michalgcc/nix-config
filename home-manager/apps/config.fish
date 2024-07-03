 # __          _______ _         _____      _   _   _                 
 # \ \        / / ____| |       / ____|    | | | | (_)                
 #  \ \  /\  / / (___ | |      | (___   ___| |_| |_ _ _ __   __ _ ___ 
 #   \ \/  \/ / \___ \| |       \___ \ / _ \ __| __| | '_ \ / _` / __|
 #    \  /\  /  ____) | |____   ____) |  __/ |_| |_| | | | | (_| \__ \
 #     \/  \/  |_____/|______| |_____/ \___|\__|\__|_|_| |_|\__, |___/
 #                                                           __/ |    
 #                                                          |___/     

function is_wsl
    grep -qi Microsoft /proc/version
end

function is_windows_filesystem
    pwd -P | grep -q "^/mnt/c/*"
end

if is_wsl
    . ~/.nix-profile/etc/profile.d/nix.fish
end

 #   _____      _   _   _                 
 #  / ____|    | | | | (_)                
 # | (___   ___| |_| |_ _ _ __   __ _ ___ 
 #  \___ \ / _ \ __| __| | '_ \ / _` / __|
 #  ____) |  __/ |_| |_| | | | | (_| \__ \
 # |_____/ \___|\__|\__|_|_| |_|\__, |___/
 #                               __/ |    
 #                              |___/     

 # Powerline-go prompt
function fish_prompt
    eval powerline-go -error $status -jobs (count (jobs -p))

    if test -n "$container"
        echo -n "📦 "
    end
end

# Disable greeting
set -g fish_greeting

function work_tmux
    tmuxp load -y wsl
end

# Run tmux if not already running
[ -z "$TMUX" ] && tmux new -A -s dflt

 #  ______                _   _                 
 # |  ____|              | | (_)                
 # | |__ _   _ _ __   ___| |_ _  ___  _ __  ___ 
 # |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
 # | |  | |_| | | | | (__| |_| | (_) | | | \__ \
 # |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
 #                                              
 #                                              

# Adjusted for WSL functions

# Start on Windows
function s
    if is_wsl
        explorer.exe (wslpath -aw $argv)
    else
        echo "Not implemented. Implement when there is a use case."
    end
end

function c
    if [ (count $argv) -eq 0 ]
        set argv "."
    end

    if is_wsl
        code $argv &>/dev/null
    else
        codium $argv &>/dev/null
    end
end

function ii
    if is_wsl
        /mnt/c/Windows/explorer.exe .
    else
        nautilus . &>/dev/null &
    end
end

function git
    if is_windows_filesystem
        git.exe $argv
    else 
        command git $argv
    end
end

function rg
    if is_windows_filesystem
        rg.exe $argv
    else 
        command rg $argv
    end
end

function ssh
    if is_wsl
        ssh.exe $argv
    else 
        command ssh $argv
    end
end

# Native functions

function cp
    rsync -ah --progress $argv
end

function search
    nix search nixpkgs $argv
end

function clipboard
    wl-copy
end

function git_add_rebase_i
    git add -A && git commit -m "x" && git rebase -i HEAD~2
end

function git_add_amend_no_edit_force_push
    git add -A && git commit --no-verify --amend --no-edit && git push --force-with-lease
end

function git_reset_hard
    git reset --hard @{u}
end

function git_fetch_reset
    git fetch
    git reset --hard @{u}
end

function git_pull_all
    find -maxdepth 2 -type d -name .git -execdir git pull \;
end

function qransiencode
    echo "Paste what you want to generate as QR and confirm with Enter + CTRL + D"
    qrencode -t ansiutf8
end

function unlock_remote_server_luks
    while true; ssh  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@192.168.8.121; sleep 1; end
end

function battery_conservation
    if test -z "$argv[1]"
        echo "battery_conservation command options:"
        echo "'show': Display the current conservation mode status"
        echo "'on': Enable the battery conservation mode"
        echo "'off': Disable the battery conservation mode"
    else
        switch $argv[1]
        case "show"
            set conservation_mode (cat /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode)
            if test "$conservation_mode" = "1"
                echo "Conservation mode is on (1)"
            else
                echo "Conservation mode is off (0)"
            end
            ;;
        case "on"
            echo 1 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode >/dev/null
            ;;
        case "off"
            echo 0 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode >/dev/null
            ;;
        case "*"
            echo "Invalid command. Available commands are: 'show', 'on', 'off'"
            ;;
        end
    end
end


function notes
    pushd ~/Nextcloud/Notes
    vim
    popd
end

function tvim
    tmux send-keys 'vim' C-m \; \
    split-window -v -l 5 -c '#{pane_current_path}' \; \
    # Depends on numbering, in default config it should be 0
    select-pane -t 1
end

function tvi
    tvim
end

alias rm "rm -rf"
