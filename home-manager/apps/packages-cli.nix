{ pkgs, ... }: {
  home.packages = with pkgs; [
    # dev
    bintools
    dive
    fzf
    gdb
    grc
    jq
    lazygit
    nil
    nixpkgs-fmt
    patchelf
    ripgrep
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
    # media
    ffmpeg-full
    somafm-cli
  ];
}
