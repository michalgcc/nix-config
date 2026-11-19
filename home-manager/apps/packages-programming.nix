{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Rust
    #clang
    # # llvmPackages.bintools
    # rustup
    python3
    uv
  ];
}
