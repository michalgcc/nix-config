{ pkgs, ... }: {
  home.packages = with pkgs; [
    # dev
    blesh
    bintools
    detox
    dive
    distrobox
    fzf
    gdb
    grc
    jq
    lazygit
    mtr
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
    yt-dlp
    lynx
    pdfgrep
    # media
    ffmpeg-full
    somafm-cli
  ];
}
