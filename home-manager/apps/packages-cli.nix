{ pkgs, ... }: {
  home.packages = with pkgs; [
    # core cli tools (moved from the removed nushell.nix)
    bat
    dust
    fd
    ouch
    ripgrep

    # dev
    bintools
    detox
    dive
    distrobox
    gdb
    gitui
    grc
    jq
    lazygit
    mtr
    nil
    nixfmt
    nodejs
    patchelf
    podman-compose
    steam-run
    powershell
    rename
    libnotify

    tmuxp
    tree
    wget
    wl-clipboard
    yq
    shfmt
    # troubleshooting
    dnsutils
    iperf
    iftop
    ntp
    traceroute
    # non dev
    btop
    gocryptfs
    fastfetch
    qrencode
    vifm
    wireguard-tools
    lynx
    pdfgrep
    # media
    ffmpeg-full
    somafm-cli
    unstable.yt-dlp
    imagemagick
    # disk
    parted
    e2fsprogs
  ];
}
