"  _____  _             _                          __ _         _                    _                   _
" |  __ \| |           (_)                        / _(_)       (_)                  (_)                 (_)
" | |__) | |_   _  __ _ _ _ __     ___ ___  _ __ | |_ _  __ _   _ _ __    _ ____   ___ _ __ ___    _ __  ___  __
" |  ___/| | | | |/ _` | | '_ \   / __/ _ \| '_ \|  _| |/ _` | | | '_ \  | '_ \ \ / / | '_ ` _ \  | '_ \| \ \/ /
" | |    | | |_| | (_| | | | | | | (_| (_) | | | | | | | (_| | | | | | | | | | \ V /| | | | | | |_| | | | |>  <
" |_|    |_|\__,_|\__, |_|_| |_|  \___\___/|_| |_|_| |_|\__, | |_|_| |_| |_| |_|\_/ |_|_| |_| |_(_)_| |_|_/_/\_\
"                  __/ |                                 __/ |
"                 |___/                                 |___/

set nobackup
set noswapfile
set number relativenumber
set termguicolors
set shiftwidth=4 smarttab expandtab

" Disable automatic comment insertion
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Autocomplete
set wildmode=longest,list
set wildmenu

" Map Ctrl + V to paste from the system clipboard
" nnoremap <C-v> "+p
" vnoremap <C-v> "+p

" Map Ctrl + C to copy to the system clipboard
nnoremap <C-c> "+y
vnoremap <C-c> "+y

" TAB key mapping for :bnext
nnoremap <TAB> :bnext<CR>
nnoremap <S-TAB> :bprev<CR>

" TAB key mapping for :bnext
nnoremap <TAB> :bnext<CR>

" Shift-TAB key mapping for :bprev
nnoremap <S-TAB> :bprev<CR>

" Enter autocomplete
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" Close all buffers except current
nnoremap <leader>cab :up <bar> %bd <bar> e# <bar> bd# <CR> <CR>

lua << EOF
vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"
EOF
