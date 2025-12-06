{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Rust
    #clang
    # # llvmPackages.bintools
    # rustup
    ollama
    python3
    uv
  ];
  programs.opencode = {
    package = pkgs.unstable.opencode;
    enable = true;
    settings =
      {
        autoshare = false;
        autoupdate = false;
        provider = {
          nanogpt = {
            npm = "@ai-sdk/openai-compatible";
            name = "NanoGPT";
            options = {
              name = "nanogpt";
              baseURL = "https://nano-gpt.com/api/v1";
              apiKey = "{env:NANOGPT_API_KEY}";
            };
            models = {
              "glm-4.6:thinking" = {
                name = "glm-4.6:thinking";
                limit = {
                  context = 200000;
                  output = 65536;
                };
              };
            };
          };
        };
        model = "nanogpt/glm-4.6:thinking";
        # Additional options you might want:
        # apiKey = "your-api-key";  # If needed
        # maxTokens = 4096;
        # temperature = 0.7;
      };
  };
}
