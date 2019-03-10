set nocompatible

" Input Devices
" ===== =======
set ttimeoutlen=64
set mouse=a


" Searching
" =========
set incsearch hlsearch nowrapscan
set smartcase "ignorecase
set tags+=../tags,../../tags,../../../tags


" UI
" ==
syntax on
filetype indent on
filetype plugin on
"set foldmethod=syntax foldcolumn=1 nofoldenable
set list listchars=tab:\ \  " Make cursor rest on first column of Tab
"set cursorline
set showcmd
set number
set wrap linebreak
set laststatus=2
set title titlestring=%f\ -\ vim
set statusline=%3p%%\ /%L\ %f\ %<%y%m%r%=
              \%l,%-5.(%c%V%)\ [%{&l:fileformat},\ %{&l:fileencoding}]


" Color scheme.
" ===== =======
set background=dark
if match(&term, "-256color$") > -1
    set t_Co=256
endif
colorscheme plain
highlight Visual cterm=reverse ctermfg=None ctermbg=None
highlight Search cterm=reverse ctermfg=None ctermbg=None
" Swap PmenuSel and Pmenu; default highlight can be very misleading...
highlight PmenuSel ctermbg=13  guibg=Magenta
"highlight Pmenu    ctermbg=242 guibg=DarkGrey


" Code Formatting
" ==== ==========
set expandtab
set tabstop=4 shiftwidth=4
set textwidth=78
set formatoptions=tmqBc
set whichwrap=b,s,<,>,[,]
set backspace=indent,eol,start
set nostartofline
set virtualedit=block
set cinoptions=:0
set nojoinspaces


" Window Control
" ====== =======
set splitright splitbelow

set wildmenu wildmode=list:longest


" Mappings
" ========
let mapleader='\'
" Manipulating the system clipboard
" ------------ --- ------ ---------
for k in ['d', 'D', 'x', 'y', 'p', 'P']
    execute printf('noremap <Leader>%s "+%s', k, k)
endfor
noremap Y y$
noremap <Leader>Y "+y$
noremap <Space> i<Space><Esc>l
" Movements
" ---------
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
" Arrow keys moves the view window rather than the cursor.
nnoremap <Down> <C-E>
nnoremap <Up> <C-Y>
inoremap <Down> <C-O>gj
inoremap <Up> <C-O>gk
nnoremap <Left> zh
nnoremap <Right> zl
" Windows and tabs.
" ------- --- -----
for k in ['-', '+', '_']
    execute printf('noremap %s <C-W>%s', k, k)
endfor
for k in ['h', 'j', 'k', 'l']
    execute printf('noremap <C-%s> <C-W>%s', k, k)
endfor
" Various.
" --------
noremap <Leader>ev :edit $MYVIMRC<Cr>
noremap <Leader>gq "+p:set nolbr<Cr>ggVGgq:%y+<Cr>
noremap <Cr> :nohl<Cr>:set nopaste<Cr>
noremap Q gq
noremap <C-D> :qa<Cr>
set pastetoggle=<F2>


" User commands.
" ==== =========
command! C :w | :execute "!chmod +x " . expand("%")


" Filetype options
" ======== =======
let g:pyindent_continue = '&sw'
let g:pyindent_nested_paren = '&sw'
let g:pyindent_open_paren = '&sw'

" Misc.
" =====
set autoread
set fileencodings=utf-8,gb18030,euc-jp,latin1
set viminfo+=f10
au BufNewFile,BufRead *.html se ft=htmljinja ai
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
set shell=/bin/sh

nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Plugins
" =======
call plug#begin()
Plug 'fatih/vim-go'
Plug 'Shougo/neocomplete.vim'
"Plug 'Shougo/deoplete.nvim'
"Plug 'roxma/nvim-yarp'
"Plug 'roxma/vim-hug-neovim-rpc'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mileszs/ack.vim'
Plug 'racer-rust/vim-racer'
Plug 'leafgarland/typescript-vim'
Plug 'sjl/tslime.vim'
call plug#end()

" Go
let g:go_fmt_command = 'goimports'
let g:go_gocode_unimported_packages = 1

" Completion
set completeopt=menuone,noinsert,noselect
"let g:neocomplete#enable_at_startup = 1
"let g:neocomplete#force_omni_input_patterns = {}
"let g:neocomplete#force_omni_input_patterns.javascript = '[^. \t]\.\w*'
let g:deoplete#enable_at_startup = 1

" Airline
let g:airline_theme = 'cool'

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" tslime
let g:tslime_normal_mapping = '<C-X>'
let g:tslime_visual_mapping = '<C-X>'
