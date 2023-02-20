" Load plug
call plug#begin('~/.config/nvim/bundle')

Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'chr4/nginx.vim'
Plug 'chriskempson/base16-vim'
Plug 'cohama/lexima.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'elixir-lang/vim-elixir', { 'for': 'elixir' }
Plug 'ElmCast/elm-vim', { 'for': 'elm' }
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
Plug 'itspriddle/vim-marked', { 'for': ['markdown', 'vimwiki'] }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-plug'
Plug 'kopischke/vim-fetch'
Plug 'machakann/vim-sandwich'
Plug 'mattn/emmet-vim', { 'for': ['html', 'erb', 'eruby', 'markdown', 'eelixir'] }
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
Plug 'mileszs/ack.vim'
Plug 'mustache/vim-mustache-handlebars', { 'for': ['javascript', 'handlebars'] }
Plug 'othree/csscomplete.vim', { 'for': 'css' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'slashmili/alchemist.vim', { 'for': 'elixir' }
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'vimwiki/vimwiki'
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'

call plug#end()

" Load plugins
filetype plugin indent on

"=============================================
" Options
"=============================================

" don't alter the terminal cursor
set guicursor=

" Color
set termguicolors
set background=dark
colorscheme base16-default-dark
syntax on

" Search
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,full
set wildignore=*.swp,*.o,*.so,*.exe,*.dll

" Scroll
set scrolloff=3

" Tab settings
set ts=2
set sw=2
set expandtab

" Hud
set ruler
set number
set nowrap
set fillchars=vert:\│
set colorcolumn=80

" Buffers
set hidden

" Backup Directories
set backupdir=~/.config/nvim/backups,.
set directory=~/.config/nvim/swaps,.
if exists('&undodir')
  set undodir=~/.config/nvim/undo,.
endif

" Neovim specific
set icm=nosplit

"=============================================
" Remaps
"=============================================

let mapleader=','
let maplocalleader=','

" Jump key
nnoremap ` '
nnoremap ' `

" Change pane
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Turn off search highlight
nnoremap <localleader>/ :nohlsearch<CR>

" Trim trailing whitespace
nnoremap <localleader>tw m`:%s/\s\+$//e<CR>:nohlsearch<CR>``

"=============================================
" Other Settings
"=============================================

" Use relative line numbers
set relativenumber

" Toggle paste mode
set pastetoggle=<leader>z

" Fancy tag lookup
set tags=./tags;/,tags;/

" Fancy macros
nnoremap Q @q
vnoremap Q :norm @q<cr>

" Visible whitespace
set listchars=tab:»·,trail:·
set list

" Soft-wrap for prose
command! -nargs=* Codewrap set wrap linebreak showbreak=\ ↪\
command! -nargs=* Wrap set wrap linebreak nolist spell showbreak

"=============================================
" Package Settings
"=============================================

" junegunn/fzf
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
let g:fzf_action = {
\ 'ctrl-s': 'split',
\ 'ctrl-v': 'vsplit'
\ }
let g:fzf_colors = {}
nnoremap <c-p> :FZF<cr>
nnoremap <localleader><space> :Buffers<cr>

function! GoyoBefore()
  silent !tmux set status off
  set tw=78
  Limelight
endfunction

function! GoyoAfter()
  silent !tmux set status on
  set tw=0
  Limelight!
endfunction

let g:goyo_callbacks = [function('GoyoBefore'), function('GoyoAfter')]
nnoremap <Leader>m :Goyo<CR>
nnoremap <Leader>n :Wrap<CR>

" junegunn/vim-easy-align
vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)

" mileszs/ack.vim
let g:ackprg = 'rg --vimgrep --no-heading'

" airline
let g:airline_theme='base16'
let g:airline_powerline_fonts=1
let g:airline_section_c = '%<%t%m'
let g:bufferline_echo = 0

" tpope/vim-markdown
let g:markdown_fenced_languages = ['css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml', 'html']

" vimwiki/vimwiki
let g:vimwiki_list = [{'path': '~/Dropbox/wiki/',
                     \ 'auto_toc': 1,
                     \ 'auto_tags': 1,
                     \ 'auto_generate_links': 1,
                     \ 'auto_generate_tags': 1,
                     \ 'syntax': 'markdown',
                     \ 'list_margin': 0,
                     \ 'ext': '.md'}]
let g:vimwiki_global_ext = 0

command! -bang -nargs=* WikiSearch
  \ call fzf#vim#grep(
  \  'rg --column --line-number --no-heading --color "always" '.shellescape(<q-args>).' '.$HOME.'/Dropbox/wiki/', 1,
  \  <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
  \          : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \  <bang>0)

nnoremap <localleader>w<Space> :WikiSearch!<cr>

map <M-Space> <Plug>VimwikiToggleListItem
nmap <A-n> <Plug>VimwikiNextLink
nmap <A-p> <Plug>VimwikiPrevLink

command! -nargs=1 VimwikiNewNote write ~/dropbox/wiki/notes/<args>
nnoremap <localleader>w<CR> :VimwikiNewNote

" w0rp/ale
let g:ale_lint_delay = 5000
let g:ale_javascript_eslint_use_global = 1
let g:ale_linters = {'javascript': ['eslint']}

" itspriddle/vim-marked
nnoremap <Leader>M :MarkedOpen<CR>

" Things 3
command! -nargs=* Things :silent !open "things:///add?show-quick-entry=true&title=%:t&notes=%<cr>"
nnoremap <Leader>T :Things<cr>

" vim-sandwich
let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
let g:sandwich#recipes += [
      \   {
      \     'buns'    : ['%{', '}'],
      \     'filetype': ['elixir'],
      \     'input'   : ['m'],
      \     'nesting' : 1,
      \   },
      \   {
      \     'buns'    : 'StructInput()',
      \     'filetype': ['elixir'],
      \     'kind'    : ['add', 'replace'],
      \     'action'  : ['add'],
      \     'input'   : ['M'],
      \     'listexpr'    : 1,
      \     'nesting' : 1,
      \   },
      \   {
      \     'buns'    : ['%\w\+{', '}'],
      \     'filetype': ['elixir'],
      \     'input'   : ['M'],
      \     'nesting' : 1,
      \     'regex'   : 1,
      \   },
      \   {
      \     'buns':     ['<%= ', ' %>'],
      \     'filetype': ['eruby', 'eelixir'],
      \     'input':    ['='],
      \     'nesting':  1
      \   },
      \   {
      \     'buns':     ['<% ', ' %>'],
      \     'filetype': ['eruby', 'eelixir'],
      \     'input':    ['-'],
      \     'nesting':  1
      \   },
      \   {
      \     'buns':     ['<%# ', ' %>'],
      \     'filetype': ['eruby', 'eelixir'],
      \     'input':    ['#'],
      \     'nesting':  1
      \   }
      \ ]

function! StructInput() abort
  let s:StructLast = input('Struct: ')
  if s:StructLast !=# ''
    let struct = printf('%%%s{', s:StructLast)
  else
    throw 'OperatorSandwichCancel'
  endif
  return [struct, '}']
endfunction
