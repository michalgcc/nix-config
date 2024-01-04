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

"  _                 
" | |                
" | |    _   _  __ _ 
" | |   | | | |/ _` |
" | |___| |_| | (_| |
" |______\__,_|\__,_|
"                    
"                    

lua << EOF
vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"
EOF

"   _____                             __ _      _                         __ _       
"  / ____|                           / _(_)    (_)                       / _(_)      
" | |     ___   ___   ___ _ __   ___| |_ _  ___ _  ___    ___ ___  _ __ | |_ _  __ _ 
" | |    / _ \ / __| / __| '_ \ / _ \  _| |/ __| |/ __|  / __/ _ \| '_ \|  _| |/ _` |
" | |___| (_) | (__  \__ \ |_) |  __/ | | | (__| | (__  | (_| (_) | | | | | | | (_| |
"  \_____\___/ \___| |___/ .__/ \___|_| |_|\___|_|\___|  \___\___/|_| |_|_| |_|\__, |
"                        | |                                                    __/ |
"                        |_|                                                   |___/ 

" Use gx to go to links inside a floating window
nmap <leader>fj <Plug>(coc-float-jump)
nmap <leader>fh <Plug>(coc-float-hide)


" Enter autocomplete
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" \f to format using coc language server
nmap <leader>fd :CocCommand editor.action.formatDocument<CR>

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Show diagnostics
nmap <leader>dd :CocList diagnostics<CR>

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
if CocAction('hasProvider', 'hover')
  call CocActionAsync('doHover')
else
  call feedkeys('K', 'in')
endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>qf <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>qs  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
" nmap <leader>qf  <Plug>(coc-fix-current)

nmap <leader>ac  <Plug>(coc-codelens-action)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)


