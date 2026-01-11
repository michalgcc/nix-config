{ pkgs, ... }: {
  home.packages = with pkgs; [
    # dev
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
    unstable.streamlink
    unstable.yt-dlp
    imagemagick
  ];
}
