{ pkgs, ... }: {
  home.packages = with pkgs; [
    # dev
    bintools
    detox
    dive
    fzf
    gdb
    grc
    jq
    lazygit
    nil
    nixpkgs-fmt
    nodejs
    patchelf
    podman-compose
    powershell
    rename
    ripgrep
    tmuxp
    tree
    wget
    wl-clipboard
    yq
    # troubleshooting
    dnsutils
    iperf
    iftop
    ntp
    traceroute
    # non dev
    btop
    gocryptfs
    neofetch
    qrencode
    vifm
    wireguard-tools
    yt-dlp
    lynx
    pdfgrep
    # media
    ffmpeg-full
    somafm-cli
  ];
}
