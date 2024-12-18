{ pkgs, ... }: {
  home.packages = with pkgs; [
      # Rust
      clang
      # llvmPackages.bintools
      rustup
  ];
}
