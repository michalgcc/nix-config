# For Windows:
# Use autoload C:\Users\<u>\AppData\Roaming\nushell\autoload\autoload.nu to load all things related to plugins and work config
# scoop instal nu
# scoop install extras/carapace-bin
# scoop install zoxide - Need to add something to env.nu on Windows, check their github
# scoop install starship

# Load secrets if the file exists
if ("~/.scr.nu" | path exists) {
    source ~/.scr.nu
}


# --- Helper Functions ---

# Checks if running in Windows Subsystem for Linux (WSL) by looking for an
# environment variable that WSL sets. This is a robust method.
def is_wsl [] {
    'WSL_DISTRO_NAME' in $env
}

# Checks if the current path is a mounted Windows drive (e.g., /mnt/c/...).
def is_windows_filesystem_in_wsl [] {
    pwd | str starts-with '/mnt/c/'
}

def is_windows [] {
    $nu.os-info.name == "windows"
}

let carapace_completer = { |spans|
  carapace $spans.0 nushell ...$spans | from json
}

$env.config = {
  show_banner: false
  completions: {
    case_sensitive: false # case-insensitive completions
    quick: true # set to false to prevent auto-selecting completions
    partial: true # set to false to prevent partial filling of the prompt
    algorithm: "fuzzy" # prefix or fuzzy
    external: {
      # set to false to prevent nushell looking into $env.PATH to find more suggestions
      enable: true
      # set to lower can improve completion performance at the cost of omitting some options
      max_results: 100
      completer: $carapace_completer # check 'carapace_completer'
    }
  }
}

if ((is_windows) or (is_wsl) or (is_windows_filesystem_in_wsl)) {
    $env.config.shell_integration.osc133 = false
}

if (not ((is_windows) or (is_wsl) or (is_windows_filesystem_in_wsl))) {
    $env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend $"($env.HOME)/.npm-global/bin"
    | prepend /home/mg/.apps
    | append /usr/bin/env
    )
}



# --- Main Commands ---

def ii [...paths] {
    let targets = if ($paths | is-empty) { ["."] } else { $paths }

    if ((is_windows) or (is_wsl) or (is_windows_filesystem_in_wsl)) {
        explorer.exe ...$targets
    } else {
        job spawn { dolphin ...$targets | complete | ignore } | ignore
    }
}

def c [...paths] {
    let targets = if ($paths | is-empty) { ["."] } else { $paths }

    if ((is_windows) or (is_wsl)) {
        if (is_windows_filesystem_in_wsl) {
            let windows_paths = ($targets | each { |p| wslpath -aw $p | str trim })
            cmd.exe /c code.cmd ...$windows_paths
        } else {
            code ...$targets | complete | ignore
        }
    } else {
        ^codium ...$targets | complete | ignore
    }
}

# Chooses the correct ssh executable based on the environment (WSL or Linux).
def ssh [...args] {
    if ((is_windows) or (is_wsl)) {
        ssh.exe ...$args
    } else {
        ^ssh ...$args
    }
}

# Chooses the correct pwsh executable based on the environment.
def pwsh [...args] {
    if ((is_windows) or (is_wsl)) {
        pwsh.exe ...$args
    } else {
        ^pwsh ...$args
    }
}

# Repeatedly attempts to SSH into a server, useful for unlocking a LUKS-encrypted drive on boot.
def unlock_remote_server_luks [] {
    loop {
        # Use ^ssh to ensure we call the external command, not our custom ssh function above.
        ^ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@192.168.8.121
        sleep 1sec
    }
}

# A simple wrapper for lazygit that forwards all arguments.
def lg [...args] {
    lazygit ...$args
}

# opencode alias
alias opencode = steam-run opencode