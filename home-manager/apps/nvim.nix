{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = builtins.readFile ./nvim/init.vim;

    coc.enable = true;
    coc.settings = builtins.fromJSON (builtins.readFile ./nvim/nvim-coc.json);

    plugins = with pkgs; [
      # Coc plugins
      vimPlugins.coc-css
      vimPlugins.coc-html
      vimPlugins.coc-json
      vimPlugins.coc-prettier
      vimPlugins.coc-eslint
      vimPlugins.coc-tsserver
      vimPlugins.coc-rust-analyzer
      # Language plugins
      vimPlugins.purescript-vim
      # Regular plugins
      vimPlugins.nvim-web-devicons
      {
        plugin = vimPlugins.nvim-treesitter.withAllGrammars;
        config = '' 
          lua << EOF
          require("nvim-treesitter.configs").setup{
            highlight = {
              enable = true
            }
          }
          EOF
          '';
      }
      {
        plugin = vimPlugins.bufferline-nvim;
        config = '' 
          lua << EOF
          require("bufferline").setup{}
          EOF
          '';
      }
      {
        plugin = vimPlugins.telescope-nvim;
        config = '' 
          " Find files using Telescope command-line sugar.
          nnoremap <leader>ff <cmd>Telescope find_files<cr>
          nnoremap <leader>fg <cmd>Telescope live_grep<cr>
          nnoremap <leader>fb <cmd>Telescope buffers<cr>
          nnoremap <leader>fh <cmd>Telescope help_tags<cr>
          '';
      }
      {
        plugin = vimPlugins.indent-blankline-nvim;
        config =
          '' 
          lua << EOF
          require("bufferline").setup{}
          EOF
          '';
      }
      {
        plugin = vimPlugins.gruvbox-material;
        config =
          ''
            let g:gruvbox_material_background = 'hard'
            colorscheme gruvbox-material
          '';
      }
      {
        plugin = vimPlugins.gitsigns-nvim;
        config =
          '' 
          lua << EOF
          require('gitsigns').setup{
            on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end

            -- Actions
            map('n', '<leader>gb', gs.toggle_current_line_blame)
            -- map('n', '<leader>gd', gs.diffthis)

            end
          }
          EOF
          '';
      }
      {
        plugin = vimPlugins.lualine-nvim;
        config =
          '' 
          lua << EOF
          require('lualine').setup()
          EOF
          '';
      }
      # Search and replace
      {
        plugin = vimPlugins.nvim-spectre;
        config =
          '' 
          lua << EOF
          require('spectre').setup()
          EOF
          '';
      }
      # Shows keys
      {
        plugin = vimPlugins.which-key-nvim;
        config =
          '' 
          lua << EOF
          require('which-key').setup()
          EOF
          '';
      }
      {
        plugin = unstable.vimPlugins.neo-tree-nvim;
        config =
          '' 
          lua << EOF
          require("neo-tree").setup({
            enable_diagnostics = true,
            close_if_last_window = true,
            filesystem = {
              filtered_items = {
                hide_by_name = {
                  "target"
                }
              }
            }
          })
          -- To enable auto open:
          -- https://github.com/AstroNvim/AstroNvim/issues/648
          EOF

          nnoremap <leader>ee <cmd>Neotree toggle<cr>
          '';
      }
      {
        plugin = vimPlugins.comment-nvim;
        config =
          '' 
          lua << EOF
          require('Comment').setup()
          EOF
          '';
      }
      {
        plugin = vimPlugins.diffview-nvim;
        config =
          '' 
          lua << EOF
          EOF
          nnoremap <leader>dvo <cmd>DiffviewOpen<cr>
          nnoremap <leader>dvc <cmd>DiffviewClose<cr>
          '';
      }
      {
        plugin = vimPlugins.markdown-preview-nvim;
        config =
          '' 
          lua << EOF
          EOF
          '';
      }
      {
        plugin = vimPlugins.leap-nvim;
        config =
          '' 
          lua << EOF
          require('leap').add_default_mappings()
          vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
          EOF
          '';
      }
      {
        # Ctrl + n - start
        # Ctrl down - up - add more cursors
        # i a r A - insert
        plugin = vimPlugins.vim-visual-multi;
        config =
          '' 
          lua << EOF
          EOF
          '';
      }
      {
        # Rust to keep track of cargo versions
        plugin = vimPlugins.crates-nvim;
        config =
          '' 
          lua << EOF
          require('crates').setup({})
          EOF
          '';
      }
    ];
  };
}
