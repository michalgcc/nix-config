{ pkgs, ... }: {
  home.packages = with pkgs; [
    # core cli tools (moved from the removed nushell.nix)
    bat
    dust
    fd
    ouch
    ripgrep
    yazi

    # dev
    bintools
    detox
    distrobox
    gdb
    gitui
    jq
    nil
    nixfmt
    nodejs
    patchelf
    podman-compose
    steam-run
    powershell
    rename
    libnotify

    tree
    wget
    wl-clipboard
    shfmt
    # troubleshooting
    dnsutils
    iperf
    ntp
    # non dev
    btop
    gocryptfs
    fastfetch
    wireguard-tools
    lynx
    pdfgrep
    # media
    ffmpeg-full
    unstable.yt-dlp
    imagemagick
    # disk
    parted
    e2fsprogs
  ];
}
