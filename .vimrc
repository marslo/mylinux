" =============================================================================
"      FileName: .vimrc
"        Author: marslo.jiao@gmail.com
"       Created: 2010-10
"       Version: 1.0.2
"    LastChange: 2024-01-09 23:40:38
" =============================================================================

set nocompatible
set maxmempattern=5000
set history=1000
set diffopt=filler,context:3
set spell spelllang=en_us
set spellcapcheck=1
set spellfile=~/.vim/spell/en.utf-8.add
set lazyredraw
set shell=/usr/local/bin/bash
runtime macros/matchit.vim
runtime defaults.vim

let performance_mode = 1
set mouse=c
set mousemodel=popup_setpos
set fileformat=unix
set fileformats=unix
set nowrap                                                          " no wrap lines
set viminfo=%,<800,'10,/50,:100,h,f0,n~/.vim/cache/.viminfo
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set tags=tags

if empty( glob('~/.vim/cache/') ) | execute 'silent !mkdir -p ~/.vim/cache' | endif
if empty( glob('~/.vim/undo/')  ) | execute 'silent !mkdir -p ~/.vim/undo'  | endif

" /**************************************************************
"                                  _
"  _ __  _ __ ___  _ __   ___ _ __| |_ _   _
" | '_ \| '__/ _ \| '_ \ / _ \ '__| __| | | |
" | |_) | | | (_) | |_) |  __/ |  | |_| |_| |
" | .__/|_|  \___/| .__/ \___|_|   \__|\__, |
" |_|             |_|                  |___/
"
" **************************************************************/
let pluginHome     = expand( '~/.vim/plugged' ) . '/'
let mapleader      = ','
let g:mapleader    = ','
let maplocalleader = '\\'
let g:plug_shallow = 0

filetype off
set runtimepath+=~/.vim/plugged
set runtimepath+=~/.vim/plugged/YouCompleteMe
set runtimepath+=/usr/local/opt/fzf                                         " $ brew install fzf
call plug#begin( '~/.vim/plugged' )

Plug 'junegunn/vim-plug'
Plug 'tpope/vim-pathogen'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-repeat'
Plug 'Yggdroot/indentLine'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'sjl/gundo.vim'
Plug 'preservim/tagbar'
Plug 'marslo/vim-devicons', { 'branch': 'sandbox/marslo' }
Plug 'marslo/authorinfo'
Plug 'LunarWatcher/auto-pairs', { 'branch': 'develop' }
Plug 'tomtom/tlib_vim'
Plug 'yegappan/mru'
Plug 'fracpete/vim-large-files'
Plug 'Konfekt/FastFold'
Plug 'dhruvasagar/vim-table-mode'
Plug 'vim-autoformat/vim-autoformat'
Plug 'mbbill/undotree'
Plug 'marslo/MarsloFunc'
Plug 'vim-syntastic/syntastic'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 install.py --all' }
Plug 'ycm-core/lsp-examples',  { 'do': 'python3 install.py --all' }
Plug 'tpope/vim-commentary'
Plug 'preservim/vim-markdown'                                       " markdown
Plug 'valloric/MatchTagAlways'                                      " web design
Plug 'tpope/vim-fugitive'                                           " ╮
Plug 'airblade/vim-gitgutter'                                       " │
Plug 'APZelos/blamer.nvim'                                          " ├ git
Plug 'tpope/vim-git'                                                " │
Plug 'junegunn/gv.vim'                                              " │
Plug 'zivyangll/git-blame.vim'                                      " ╯
Plug 'pearofducks/ansible-vim'
Plug 'morhetz/gruvbox'                                              " theme
Plug 'luochen1990/rainbow'                                          " ╮ color
Plug 'marslo/vim-coloresque'                                        " ╯ 'ap/vim-css-color'
Plug 'amadeus/vim-css'
Plug 'stephpy/vim-yaml'                                             " ╮
Plug 'pedrohdz/vim-yaml-folds'                                      " ├ yaml
Plug 'dense-analysis/ale'                                           " ╯
Plug 'modille/groovy.vim'                                           " /usr/local/vim/share/vim/vim90/syntax/groovy.vim
Plug 'vim-scripts/vim-gradle'
Plug 'marslo/Jenkinsfile-vim-syntax'                                " jenkinfile
Plug 'ekalinin/Dockerfile.vim'                                      " dockerfile
Plug 'rizzatti/dash.vim'
" Plug 'ap/vim-css-color'                                           " cause issue in groovy.vim
" Plug 'parkr/vim-jekyll'                                           " github page

call plug#end()
call pathogen#infect( '~/.vim/plugged/{}' )
call pathogen#helptags()
filetype plugin indent on
syntax enable on

" /**************************************************************
"   __                  _   _
"  / _|_   _ _ __   ___| |_(_) ___  _ __
" | |_| | | | '_ \ / __| __| |/ _ \| '_ \
" |  _| |_| | | | | (__| |_| | (_) | | | |
" |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|
"
" **************************************************************/
function! GetPlug()                                                 " GetPlug() inspired by: http://pastebin.com/embed_iframe.php?i=C9fUE0M3
  if has( 'win32' ) || has( 'win64' )
    let pluginHome=$VIM . '\autoload'
    let pluginFile=pluginHome . '\plug.vim'
  else
    let pluginHome=$HOME . '/.vim/autoload'
    let pluginFile=pluginHome . '/plug.vim'
  endif

  if filereadable( pluginFile )
    echo "vim-plug has existed at " . expand( pluginFile )
  else
    echo "download vim-plug to " . expand( pluginFile ) . '...'
    echo ""
    if isdirectory( expand(pluginHome) ) == 0
      call mkdir( expand(pluginHome), 'p' )
    endif
    execute 'silent !curl --create-dirs https://github.com/junegunn/vim-plug/raw/master/plug.vim -kfLo "' . expand( pluginFile ) . '"'
  endif
endfunction
command! GetPlug :call GetPlug()

if has( 'unix' ) || has( 'macunix' )
  if empty( glob('~/.vim/autoload/plug.vim') ) || empty( glob($VIM . 'autoload\plug.vim') )
    execute 'silent exec "GetPlug"'
  endif
endif

if isdirectory( expand(pluginHome . 'MarsloFunc') )
  command! GetVim :call marslofunc#GetVim()<CR>
  xnoremap *      :<C-u>call marslofunc#VSetSearch()<CR>/<C-R>=@/<CR><CR>
  xnoremap #      :<C-u>call marslofunc#VSetSearch()<CR>?<C-R>=@/<CR><CR>
  nnoremap <F12>  :call marslofunc#UpdateTags()<CR>

  augroup resCur
    autocmd!
    autocmd BufWinEnter * call marslofunc#ResCur()
  augroup END

  set foldtext=v:folddashes.substitute(getline(v:foldstart),'/\\*\\\|\\*/\\\|{{{\\d\\=','','g')
  set foldtext=marslofund#MyFoldText()<CR>
endif

" twiddle case : https://vim.fandom.com/wiki/Switching_case_of_characters#Twiddle_case
function! TwiddleCase(str)
  if a:str ==# toupper( a:str )
    let result = tolower( a:str )
  elseif a:str ==# tolower( a:str )
    let result = substitute( a:str,'\(\<\w\+\>\)', '\u\1', 'g' )
  else
    let result = toupper( a:str )
  endif
  return result
endfunction
vnoremap ~ y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv

function! IgnoreSpells()                                            " ignore CamelCase words when spell checking
  syntax      match   CamelCase /\<[A-Z][a-z]\+[A-Z].\{-}\>/ contains=@NoSpell transparent
  syntax      cluster Spell add=CamelCase
  syntax      match   mixedCase /\<[a-z]\+[A-Z].\{-}\>/      contains=@NoSpell transparent
  syntax      cluster Spell add=mixedCase
  " or syntax match   myExNonWords +\<\p*[^A-Za-z \t]\p*\>+  contains=@NoSpell
  " or syntax match   myExCapitalWords +\<\w*[A-Z]\K*\>\|'s+ contains=@NoSpell
  " syntax    match   Url "\w\+:\/\/[:/?#[\]@!$&'()*+,;=0-9[:lower:][:upper:]_\-.~]\+" contains=@NoSpell containedin=@AllSpell transparent
  " syntax    cluster Spell add=Url
  " syntax    match   UrlNoSpell '\w\+:\/\/[^[:space:]]\+'   contains=@NoSpell transparent
  " syntax    cluster Spell add=UrlNoSpell
endfunction
autocmd BufRead,BufNewFile * :call IgnoreSpells()
set spellcapcheck=                                                  " ignore capital check

" redir into new tab: https://vim.fandom.com/wiki/Capture_ex_command_outputhttps://vim.fandom.com/wiki/Capture_ex_command_output
" `gt`, `:tabfirst`, `:tabnext`, `:tablast` ... to switch tabs : https://vim.fandom.com/wiki/Alternative_tab_navigation
function! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty( message )
    echoerr "no output"
  else
    tabnew                                                          " use `new` instead of `tabnew` below if you prefer split windows instead of tabs
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

" file is large from 10mb                                           " https://vim.fandom.com/wiki/Faster_loading_of_large_files
function LargeFile()
  set eventignore    += FileType                                    " no syntax highlighting etc
  setlocal bufhidden  = unload                                      " save memory when other file is viewed
  setlocal buftype    = nowrite                                     " is read-only (write with :w new_filename)
  setlocal undolevels = -1                                          " no undo possible
  " display message
  autocmd VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details)."
endfunction
let g:LargeFile = 1024 * 1024 * 10
augroup LargeFile
  autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
augroup END

function! BSkipQuickFix( command )                                  " switch avoid quickfix : https://vi.stackexchange.com/a/19420/7389
  let start_buffer = bufnr('%')
  execute a:command
  while &buftype ==# 'quickfix' && bufnr('%') != start_buffer
    execute a:command
  endwhile
endfunction
nnoremap <Tab>      :call BSkipQuickFix("bn")<CR>
nnoremap <S-Tab>    :call BSkipQuickFix("bp")<CR>
nnoremap <leader>bp :call BSkipQuickFix("bn")<CR>
nnoremap <leader>bn :call BSkipQuickFix("bp")<CR>

" set spellcamelcase=1
fun! IgnoreCamelCaseSpell()                                         " Ignore CamelCase words when spell checking
  syn match CamelCase /\<[A-Z][a-z]\+[A-Z].\{-}\>/ contains=@NoSpell transparent
  syn match mixedCase /\<[a-z]\+[A-Z].\{-}\>/ contains=@NoSpell transparent
  syn cluster Spell add=CamelCase
  syn cluster Spell add=mixedCase
endfun
autocmd BufRead,BufNewFile * :call IgnoreCamelCaseSpell()
syn match UrlNoSpell '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell

if exists( ":Tabularize" )                                          " 'godlygeek/tabular'
  function! s:table_auto_align()
    let p = '^\s*|\s.*\s|\s*$'
    if exists( ':Tabularize' ) && getline('.') =~# '^\s*|'
      \ && (getline(line('.')-1) =~# p || getline( line('.')+1 ) =~# p)
      let column   = strlen( substitute(getline('.')[0:col('.')],'[^|]','','g') )
      let position = strlen( matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*') )
      Tabularize/|/l1
      normal! 0
      call search( repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.') )
    endif
  endfunction
endif

" /**************************************************************
"                                                _
"                                               | |
"   ___ ___  _ __ ___  _ __ ___   __ _ _ __   __| |___
"  / __/ _ \| '_ ` _ \| '_ ` _ \ / _` | '_ \ / _` / __|
" | (_| (_) | | | | | | | | | | | (_| | | | | (_| \__ \
"  \___\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_|___/
"
" **************************************************************/
" reverse the lines of the whole file or a visually highlighted block.
    " :Rev is a shorter prefix you can use.
    " Adapted from http://tech.groups.yahoo.com/group/vim/message/34305
    " reference : https://superuser.com/a/387869/112396
command! -nargs=0 -bar -range=% Reverse
    \       let save_mark_t = getpos("'t")
    \<bar>      <line2>kt
    \<bar>      exe "<line1>,<line2>g/^/m't"
    \<bar>  call setpos("'t", save_mark_t)
nnoremap <Leader>r :Reverse <bar> nohlsearch<CR>
xnoremap <Leader>r :Reverse <bar> nohlsearch<CR>

command! -nargs=0 DocTocUpdate execute 'silent !/usr/local/bin/doctoc --notitle --update-only --github --maxlevel 3 %' | execute 'redraw!'
command! -nargs=0 DocTocCreate execute 'silent !/usr/local/bin/doctoc --notitle --github --maxlevel 3 %' | execute 'redraw!'
command! -nargs=1        First execute                           'Tabularize /^[^' . escape(<q-args>, '\^$.[?*~') . ']*\zs' . escape(<q-args>, '\^$.[?*~')
command! -nargs=1 -range First execute <line1> . ',' . <line2> . 'Tabularize /^[^' . escape(<q-args>, '\^$.[?*~') . ']*\zs' . escape(<q-args>, '\^$.[?*~')
command! -nargs=0        Iname execute 'echo expand("%:p")'

" /**************************************************************
"  _       _             __                     __  _   _
" (_)_ __ | |_ ___ _ __ / _| __ _  ___ ___     / / | |_| |__   ___ _ __ ___   ___
" | | '_ \| __/ _ \ '__| |_ / _` |/ __/ _ \   / /  | __| '_ \ / _ \ '_ ` _ \ / _ \
" | | | | | ||  __/ |  |  _| (_| | (_|  __/  / /   | |_| | | |  __/ | | | | |  __/
" |_|_| |_|\__\___|_|  |_|  \__,_|\___\___| /_/     \__|_| |_|\___|_| |_| |_|\___|
"
" **************************************************************/
if has('gui_running')
  set go=                                                           " hide everything (go = guioptions)
  set cpoptions+=n
  set guifont=Agave\ Nerd\ Font\ Mono:h32
  " set guifont=JetBrainsMono\ Nerd\ Font\ Mono:h26
  " set guifont=Rec\ Mono\ Casual:h24
  " set guifontwide=NSimsun:h16
  set renderoptions=type:directx,renmode:5
  set lines=30                                                      " the initialize size
  set columns=106
endif

if exists( '$TMUX' )         | set term=screen-256color | endif
if 'xterm-256color' == $TERM | set t_Co=256             | endif

if has( 'gui_running' ) || 'xterm-256color' == $TERM
  set background=dark
  let psc_style='cool'

  " colorscheme marslo                                              " marslo
  colorscheme gruvbox                                               " gruvbox

  """ terminal : `:help terminal-info`
  set term=xterm
  let &t_AB = "\e[48;5;%dm"
  let &t_AF = "\e[38;5;%dm"
  let &t_Co = 256
  set t_Co=256
  "" italic
  let &t_ZH = "\e[3m"
  let &t_ZR = "\e[23m"
else
  set t_Co=8
  set t_Sb=^[[4%dm
  set t_Sf=^[[3%dm
  colorscheme marslo16
endif

"" cursor settings:                                                 " https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
"    block        : 1 -> blinking block        |  2 -> solid block
"    underscore   : 3 -> blinking underscore   |  4 -> solid underscore
"    vertical bar : 5 -> blinking vertical bar |  6 -> solid vertical bar
if $TERM_PROGRAM =~ "iTerm"
  let &t_SI = "\<Esc>]50;CursorShape=4\x7"                          " INSERT MODE  : solid underscore
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"                          " REPLACE MODE : solid block
  let &t_EI = "\<Esc>]50;CursorShape=3\x7"                          " NORMAL MODE  : blinking underscore
else
  let &t_SI .= "\e[4 q"                                             " SI = INSERT mode
  let &t_SR .= "\e[4 q"                                             " SR = REPLACE mode
  let &t_EI .= "\e[3 q"                                             " EI = NORMAL mode (ELSE)
endif

" /**************************************************************
"           _   _   _
"  ___  ___| |_| |_(_)_ __   __ _
" / __|/ _ \ __| __| | '_ \ / _` |
" \__ \  __/ |_| |_| | | | | (_| |
" |___/\___|\__|\__|_|_| |_|\__, |
"                           |___/
"
" **************************************************************/
set ttimeout
set ttimeoutlen=1
set ttyfast                                                         " enable fast terminal connection.
set clipboard+=unnamed                                              " copy the content to system clipboard by using y/p
set clipboard+=unnamedplus
set iskeyword-=.
set autochdir
set encoding=utf-8                                                  " input chinese (=cp936)
set termencoding=utf-8
let &termencoding=&encoding
set fileencoding=utf-8
set fileencodings=utf-8,latin1,ucs-bom,gbk,cp936,gb2312,gb18030     " code format
scriptencoding utf-8                                                " set after encoding
set rop=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
set selection=exclusive                                             " mouse settings
set selectmode=mouse,key
set nobackup noswapfile nowritebackup noundofile noendofline nobuflisted
set number                                                          " line number
set report=0
set autoread                                                        " set auto read when a file is changed by outside
set showmatch                                                       " show matching bracets (shortly jump to the other bracets)
set matchtime=1                                                     " the shortly time
set tabstop=2                                                       " tab width
set softtabstop=2                                                   " width for backspace
set shiftwidth=2                                                    " the tab width by using >> & <<
set autoindent smartindent expandtab
set cindent
set cinoptions=(0,u0,U0
set smarttab                                                        " smarttab: the width of <Tab> in first line would refer to 'shiftwidth' parameter
set linebreak
set modifiable
set write
set incsearch hlsearch ignorecase smartcase                         " search
set magic                                                           " regular expression
set linespace=0
set wildmenu
set wildmode=longest,list,full                                      " completion mode that is used for the character
set noerrorbells novisualbell visualbell                            " ╮ turn off
set belloff=all                                                     " ├ beep/flash
set t_vb=                                                           " ╯ error beep/flash
" set list listchars=tab:\→\ ,tab:▸,trail:·,extends:»,precedes:«,nbsp:·,eol:¬
set list
set listchars=tab:\→\ ,trail:·,extends:»,precedes:«,nbsp:·
set cursorline                                                      " highlight the current line
set cursorcolumn
set guicursor=a:hor10-Cursor-blinkon0
set guicursor+=i-r-c-ci-cr-o:hor10-iCursor-blinkon0
set guicursor+=n:hor10-Cursor-blinkwait700-blinkon400-blinkoff250
set guicursor+=v-ve:block-Cursor
set virtualedit=onemore                                             " allow for cursor beyond last character
set scrolloff=3                                                     " scroll settings
set sidescroll=1
set sidescrolloff=5
set imcmdline                                                       " fix context menu messing
set complete+=kspell
set completeopt=longest,menuone                                     " supper tab
set foldenable                                                      " enable fold
set foldcolumn=1
set foldexpr=1                                                      " shown line number after fold
set foldlevel=100                                                   " not fold while vim set up
set shortmess+=filmnrxoOtTc                                         " abbrev. of messages (avoids 'hit enter')
set viewoptions=folds
set backspace=indent,eol,start                                      " make backspace h, l, etc wrap to
set whichwrap+=<,>,h,l
set go+=a                                                           " visual selection automatically copied to the clipboard
set hidden                                                          " switch between buffers with unsaved change
set equalalways
set formatoptions=tcrqn
set formatoptions+=rnmMB                                            " remove the backspace for combine lines (only for chinese)
set matchpairs+=<:>
set thesaurus+=~/.vim/spell/dictionary/thesaurii.txt                " ╮
set thesaurus+=~/.vim/spell/dictionary/mthesaur.txt                 " ├ spell and grammars
set dictionary=/usr/share/dict/words                                " ╯
" set autowrite
if has('cmdline_info')
  set ruler                                                         " ruler: show line and column number
  set showcmd                                                       " show (partial) command in status line
endif
set laststatus=2                                                    " set status bar
" set synmaxcol=128
" set binary
set exrc
set secure

if has('persistent_undo') | set noundofile            | endif
if version > 74399        | set cryptmethod=blowfish2 | endif

" /**************************************************************
"      _                _             _
"  ___| |__   ___  _ __| |_ ___ _   _| |_
" / __| '_ \ / _ \| '__| __/ __| | | | __|
" \__ \ | | | (_) | |  | || (__| |_| | |_
" |___/_| |_|\___/|_|   \__\___|\__,_|\__|
"
" **************************************************************/
" :help map-overview : https://vimhelp.org/map.txt.html#map-overview
noremap <leader>v    :e ~/.vimrc<CR>
noremap <F1>         <ESC>
inoremap <F1>        <ESC>a
nnoremap j           gj
nnoremap gj          j
nnoremap k           gk
nnoremap gk          k
nnoremap n           nzzzv
nnoremap N           Nzzzv
nnoremap <leader>bd  :bd<CR>
nnoremap <C-k>       <C-w>k
nnoremap <C-j>       <C-w>j
" nnoremap <C-l>     <C-w>l                                         " conflict with redraw shortcut : https://vimhelp.org/various.txt.html#CTRL-L
nnoremap <C-h>       <C-w>h
nnoremap <C-a>       <ESC>^
inoremap <C-a>       <ESC>I
cnoremap <C-a>       <Home>
nnoremap <C-e>       <ESC>$
inoremap <C-e>       <ESC>A
cnoremap <C-e>       <End>
nnoremap Y           y$
nnoremap <Del>       "_x
xnoremap <Del>       "_d
nnoremap <space>     za
nnoremap &           :&&<CR>
xnoremap &           :&&<CR>
vnoremap s           <Plug>VSurround
vnoremap //          y/\V<C-R>=escape(@",'/\')<CR><CR>

cnoreabbrev W        w
cnoreabbrev W!       w!
cnoreabbrev Q        q
cnoreabbrev Q!       q!
cnoreabbrev X        x
cnoreabbrev X!       x!
cnoreabbrev XA       xa
cnoreabbrev XA!      xa!
cnoreabbrev WQ       wq
cnoreabbrev WQ!      wq!
cnoreabbrev QA       qa
cnoreabbrev QA!      qa!
cnoreabbrev WA       wa
cnoreabbrev WA!      wa!
cnoreabbrev NOH      noh
cnoreabbrev Noh      noh
cnoreabbrev %Y       %y
cnoreabbrev %D       %d
cnoremap    sudow!!  w !sudo tee > /dev/null %
cnoremap    sw!!     execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

inoremap <leader>tt  <C-R>=strftime("%d/%m/%y %H:%M:%S")<cr>
inoremap <leader>fn  <C-R>=expand("%:t:r")<CR>
inoremap <leader>fe  <C-R>=expand("%:t")<CR>
inoremap <leader>w   <C-O>:w<CR>
nnoremap <leader>G   :%s///gn<CR>

nnoremap <leader>zil :g/^/ s//\=line('.').' '/<CR>                  " [i]nsert [l]ine number
nnoremap <leader>zcm :%s/<C-v><CR>/\r/g<CR>                         " [c]onvert [m] to new line
nnoremap <leader>zdm :%s/<C-v><CR>//ge<CR>                          " [d]elete [m]()
nnoremap <leader>zdb :%s/\s\+$//<CR>                                " [d]elete [b]lank ( trailing ) space
nnoremap <leader>zbl :g/^\s*$/d<CR>                                 " [d]elete [b]lank [l]ine
nnoremap <leader>zd2 :%s/​//g<CR>                              " [d]elete <200b>
nnoremap <leader>zdd :%s/ / /g<CR>                                  " [d]elete [d]ot( ) 0xAO
nnoremap <leader>zds :%s/^<span.*span>//g<CR>                       " [d]elete [s]pan tag
nnoremap <leader>zdi :%s/^\s\+//<CR>                                " [d]elete [i]ndent spaces
nnoremap <leader>zid i•<ESC>                                        " [i]nsert [d]ot(•) 0x2022
" count expr
nnoremap <leader>cr  0yt=A<C-r>=<C-r>"<CR><Esc>
" count expr
nnoremap <leader>*   *<C-O>:%s///gn<CR>
" count the matches numbers ( [w]c -[l] )
nnoremap <leader>zwl :%s///gn<CR>

iabbrev <leader>/*   /*********************************
iabbrev <leader>*/   *********************************/
iabbrev <leader>#-   #------------------

" /**************************************************************
"        _             _                  _   _   _
"  _ __ | |_   _  __ _(_)_ __    ___  ___| |_| |_(_)_ __   __ _ ___
" | '_ \| | | | |/ _` | | '_ \  / __|/ _ \ __| __| | '_ \ / _` / __|
" | |_) | | |_| | (_| | | | | | \__ \  __/ |_| |_| | | | | (_| \__ \
" | .__/|_|\__,_|\__, |_|_| |_| |___/\___|\__|\__|_|_| |_|\__, |___/
" |_|            |___/                                    |___/
"
" **************************************************************/
nnoremap <leader>tb :TagbarToggle<CR>
let g:tagbar_width       = 30
let g:tagbar_type_groovy = {
    \ 'ctagstype' : 'groovy',
    \ 'kinds'     : [
        \ 'p:package:1',
        \ 'c:classes',
        \ 'i:interfaces',
        \ 't:traits',
        \ 'e:enums',
        \ 'm:methods',
        \ 'd:def',
        \ 'f:fields:1'
    \ ]
\ }

" tpope/vim-commentary
map  <C-/>     gcc
map  <leader>x gcc
imap <C-/>     <Esc><Plug>CommentaryLineA
xmap <C-/>     <Plug>Commentary

noremap <leader>aid :AuthorInfoDetect<CR>
let g:vimrc_author = 'marslo'
let g:vimrc_email  = 'marslo.jiao@gmail.com'

" most recently used(mru)
noremap <leader>re :MRU<CR>
let MRU_Auto_Close    = 1
let MRU_Max_Entries   = 10
let MRU_Exclude_Files = '^/tmp/.*\|^/temp/.*\|^/media/.*\|^/mnt/.*\|^/private/.*'

noremap <Leader>u :GundoToggle<CR>
set undodir=~/.vim/undo/
set undofile

" luochen1990/rainbow
" for i in '75' '147' '108' '196' '208' '66' '106' '172' '115' '129'; do echo -e "\e[38;05;${i}m${i}"; done | column -c 250 -s ' '; echo -e "\e[m"
let g:rainbow_active    = 1
let g:rainbow_operators = 1
let g:rainbow_conf      = {
\   'guifgs' : [ '#6A5ACD', '#ff6347', '#b58900', '#9acd32', '#EEC900', '#9A32CD', '#EE7600', '#268bd2', '#183172' ],
\   'ctermfgs' : 'xterm-256color' == $TERM ? [ '75', '147', '108', '196', '208', '66', '106', '172', '115', '129' ] : [ 'lightblue', 'lightgreen', 'yellow', 'red', 'magenta' ],
\   'parentheses': [ ['(',')'], ['\[','\]'], ['{','}'] ],
\   'separately': {
\     '*': {},
\     'markdown': {
\       'parentheses_options': 'containedin=markdownCode contained',
\     },
\     'css': {
\       'parentheses': [ ['(',')'], ['\[','\]'] ],
\     },
\     'scss': {
\       'parentheses': [ ['(',')'], ['\[','\]'] ],
\     },
\     'html': {
\       'parentheses': [ ['(',')'], ['\[','\]'], ['{','}'] ],
\     },
\     'stylus': {
\       'parentheses': [ 'start=/{/ end=/}/ fold contains=@colorableGroup' ],
\     }
\   }
\}

" Yggdroot/indentLine
let g:indentLine_enabled              = 1
let g:indentLine_color_gui            = "#282828"
let g:indentLine_color_term           = 239
let g:indentLine_indentLevel          = 20
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_color_tty            = 0
let g:indentLine_faster               = 1
let g:indentLine_concealcursor        = 'inc'
let g:indentLine_conceallevel         = 2
let g:indentLine_char                 = '¦'

" LunarWatcher/auto-pairs
let g:AutoPairs                             = autopairs#AutoPairsDefine({ '<': '>' })
let g:AutoPairsMapBS                        = 1
let g:AutoPairsFlyMode                      = 0
let g:AutoPairsCompleteOnlyOnSpace          = 1
let g:AutoPairsNoJump                       = 0
let g:AutoPairsSpaceCompletionRegex         = '\w'
" let g:AutoPairsJumpBlacklist              = [ '<', '>' ]
" to avoid impact with ctrl-p ( :Files )
let g:AutoPairsShortcutToggleMultilineClose = 0
let g:AutoPairsShortcutBackInsert           = '<M-b>'
let g:AutoPairsPrefix                       = '<M-j>'
let g:AutoPairsShortcutJump                 = '<M-n>'
let g:AutoPairsShortcutToggle               = '<M-j>'

" vim-airline/vim-airline
let g:airline_powerline_fonts                      = 1
let g:airline_highlighting_cache                   = 1
let g:airline_detect_spelllang                     = 0              " disable spelling language
let g:airline_exclude_preview                      = 0              " disable in preview window
let g:airline_theme                                = 'base16_embers'" 'apprentice', 'base16', 'gruvbox', 'zenburn', 'base16_atelierheath'
let g:Powerline_symbols                            = 'fancy'
let g:airline_section_y                            = ''             " fileencoding
let g:airline_section_x                            = ''
let g:airline_section_z                            = "%3p%% %l/%L:%c [%B]"
let g:airline_skip_empty_sections                  = 1
let g:airline_detect_modified                      = 1
let g:airline_detect_paste                         = 1
let g:airline#extensions#wordcount#enabled         = 1
let g:airline#extensions#wordcount#filetypes       = '\vtext|nroff|plaintex'
let g:airline#extensions#quickfix#enabled          = 0
let g:airline#extensions#quickfix#quickfix_text    = 'Quickfix'
let g:airline_stl_path_style                       = 'short'
let g:airline#extensions#tabline#enabled           = 1              " ╮ enable airline tabline
let g:airline#extensions#tabline#fnamemod          = ':t'           " │
let g:airline#extensions#tabline#show_close_button = 0              " │ remove 'X' at the end of the tabline
let g:airline#extensions#tabline#show_buffers      = 1              " │
let g:airline#extensions#tabline#show_splits       = 0              " │ disables the buffer name that displays on the right of the tabline
let g:airline#extensions#tabline#tab_min_count     = 2              " │ minimum of 2 tabs needed to display the tabline
let g:airline#extensions#tabline#show_tabs         = 0              " │
let g:airline#extensions#tabline#tab_nr_type       = 1              " ╯ tab number
let g:airline#extensions#branch#format             = 2
let g:airline#extensions#ale#enabled               = 1              " ╮
let airline#extensions#ale#error_symbol            = ' ᓆ :'         " │
let airline#extensions#ale#warning_symbol          = ' ᣍ :'         " ├ ale
let airline#extensions#ale#show_line_numbers       = 1              " │
let airline#extensions#ale#open_lnum_symbol        = '(␊:'          " │
let airline#extensions#ale#close_lnum_symbol       = ')'            " ╯
let g:airline_mode_map                             = { '__': '-', 'n' : 'N', 'i' : 'I', 'R' : 'R', 'c' : 'C', 'v' : 'V', 'V' : 'V', '': 'V', 's' : 'S', 'S' : 'S', '': 'S', }
if !exists('g:airline_symbols') | let g:airline_symbols = {} | endif
let g:airline_symbols.dirty                        = ' ♪'
let g:airline_left_sep                             = ''
let g:airline_right_sep                            = ''
function! AirlineInit()
  let g:airline_section_a = airline#section#create([ '[', 'mode', ']' ])
  let g:airline_section_y = airline#section#create([ '%{strftime("%H:%M %b-%d %a")} ', '['.&ff.']' ])
  let g:airline_section_c = '%<' . airline#section#create([ '%F' ]) " let g:airline_section_c = '%<' . '%{expand(%:p:~)}'
endfunction
autocmd User AirlineAfterInit call AirlineInit()

" preservim/vim-markdown
let g:vim_markdown_toc_autofit          = 1
let g:vim_markdown_conceal              = 0
let g:vim_markdown_conceal_code_blocks  = 0
let g:vim_markdown_strikethrough        = 1
let g:vim_markdown_folding_disabled     = 1                         " =1 to disable folding
let g:vim_markdown_new_list_item_indent = 2

" dhruvasagar/vim-table-mode
noremap <Leader>tm :TableModeToggle<CR>
let g:table_mode_corner          = '|'
let g:table_mode_header_fillchar = '-'
let g:table_mode_align_char      = ":"
let g:table_mode_corner          = "|"
let g:table_mode_align_char      = ":"

" godlygeek/tabular
if exists( ":Tabularize" )
  noremap  <Leader>a= :Tabularize /=<CR>
  vnoremap <Leader>a= :Tabularize /=<CR>
  noremap  <leader>a: :Tabularize /:\zs<CR>
  vnoremap <leader>a: :Tabularize /:\zs<CR>
  inoremap <silent> <Bar>   <Bar><Esc>:call <SID>table_auto_align()<CR>
endif

" git
nnoremap <leader>mp  :execute 'silent !git mp' \| redraw!<CR>
" zivyangll/git-blame.vim
nnoremap <Leader>ebb :<C-u>call gitblame#echo()<CR>
" APZelos/blamer.nvim
nnoremap <Leader>bb  :BlamerToggle<CR>
let g:blamer_enabled              = 0
let g:blamer_delay                = 100
let g:blamer_show_in_visual_modes = 0
let g:blamer_show_in_insert_modes = 0
let g:blamer_relative_time        = 1
" let g:blamer_prefix             = ' » '

" airblade/vim-gitgutter
set updatetime=250
set signcolumn=yes
let g:gitgutter_git_executable = '/usr/local/bin/git'
let g:gitgutter_enabled        = 1
let g:gitgutter_realtime       = 0
let g:gitgutter_eager          = 0
highlight clear SignColumn

" ycm-core/YouCompleteMe
nnoremap <leader>gc :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>go :YcmCompleter GoToInclude<cr>
nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>gd :YcmDiags<CR>
let g:ycm_extra_conf_globlist                      = [ '~/.marslo/ycm/*', '~/.vim/plugged/YouCompleteMe/*' ]
let g:ycm_key_invoke_completion                    = '<C-\>'
let g:ycm_echo_current_diagnostic                  = 'virtual-text'
let g:ycm_error_symbol                             = '✗'
let g:ycm_warning_symbol                           = '✹'
let g:ycm_update_diagnostics_in_insert_mode        = 0
let g:ycm_seed_identifiers_with_syntax             = 1
let g:ycm_complete_in_comments                     = 1
let g:ycm_complete_in_strings                      = 1
let g:ycm_collect_identifiers_from_tags_files      = 1
let g:ycm_keep_logfiles                            = 1
let g:ycm_log_level                                = 'debug'
let g:ycm_show_detailed_diag_in_popup              = 1
let g:ycm_filepath_completion_use_working_dir      = 1
let g:ycm_min_num_of_chars_for_completion          = 1
let g:ycm_complete_in_comments                     = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_filetype_whitelist                       = { '*': 1, 'ycm_nofiletype': 1 }
let g:ycm_filetype_specific_completion_to_disable  = { 'gitcommit': 1, 'vim': 1 }
let g:ycm_filetype_blacklist                       = {
  \   'tagbar'  : 1,
  \   'notes'   : 1,
  \   'netrw'   : 1,
  \   'unite'   : 1,
  \   'vimwiki' : 1,
  \   'infolog' : 1,
  \   'leaderf' : 1,
  \   'mail'    : 1,
  \   'help'    : 1,
  \   'undo'    : 1
  \ }
let g:ycm_semantic_triggers                        =  {
  \   'c'         : [ '->', '.' ],
  \   'objc'      : [ '->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s', 're!\[.*\]\s' ],
  \   'ocaml'     : [ '.', '#' ],
  \   'cpp,cuda,objcpp' : [ '->', '.', '::' ],
  \   'perl'      : [ '->' ],
  \   'php'       : [ '->', '::' ],
  \   'cs,d,elixir,go,groovy,java,javascript,julia,perl6,python,scala,typescript,vb': [ '.' ],
  \   'ruby,rust' : [ '.', '::' ],
  \   'lua'       : [ '.', ':' ],
  \   'erlang'    : [ ':' ],
  \ }
augroup YCMCustomized
  autocmd!
  autocmd FileType c,cpp,sh,python,groovy,Jenkinsfile let b:ycm_hover = {
    \ 'command': 'GetDoc',
    \ 'syntax': &filetype,
    \ 'popup_params': {
    \     'maxwidth': 80,
    \     'border': [],
    \     'borderchars': ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
    \   },
    \ }
augroup END

" ycm-core/lsp-examples
let g:ycm_lsp_dir = expand( pluginHome . 'lsp-examples' )
let s:pip_os_dir  = 'bin'
if has( 'win32' ) | let s:pip_os_dir = 'Scripts' | end
source $HOME/.vim/plugged/lsp-examples/vimrc.generated

" Konfekt/FastFold
nnoremap zuz <Plug>(FastFoldUpdate)
xnoremap <silent> <leader>iz :<c-u>FastFoldUpdate<cr>]z<up>$v[z<down>^
xnoremap <silent> <leader>az :<c-u>FastFoldUpdate<cr>]zV[z
let g:fastfold_savehook               = 1
let g:fastfold_fold_command_suffixes  = ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']
let g:markdown_folding                = 1
let g:rst_fold_enabled                = 1
let g:tex_fold_enabled                = 1
let g:vimsyn_folding                  = 'af'
let g:xml_syntax_folding              = 1
let g:javaScript_fold                 = 1
let g:sh_fold_enabled                 = 7
let g:zsh_fold_enable                 = 1
let g:ruby_fold                       = 1
let g:perl_fold                       = 1
let g:perl_fold_blocks                = 1
let g:r_syntax_folding                = 1
let g:rust_fold                       = 1
let g:php_folding                     = 1
let g:fortran_fold                    = 1
let g:clojure_fold                    = 1
let g:baan_fold                       = 1

" vim-syntastic/syntastic
set statusline+=%#warningmsg#
set statusline+=\ %{SyntasticStatuslineFlag()}
set statusline+=\ %* |
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 1
let g:syntastic_check_on_open            = 1
let g:syntastic_check_on_wq              = 0
let g:syntastic_loc_list_height          = 2
let g:syntastic_ignore_files             = ['\.py$']
let g:syntastic_html_tidy_ignore_errors  = [" proprietary attribute \"ng-"]
let g:syntastic_enable_signs             = 1
let g:syntastic_info_symbol              = 'ϊ'                      " ࠵ ೲ
let g:syntastic_error_symbol             = '✗'                      " ஓ ௐ ྾
let g:syntastic_warning_symbol           = '⍨'                      " ᓆ ᓍ 𐘿
let g:syntastic_style_error_symbol       = '⍥'
let g:syntastic_style_warning_symbol     = 'ఠ'                      " ⍤ ൠ
highlight link SyntasticErrorSign        Error
highlight link SyntasticWarningSign      GruvboxYellow
highlight link SyntasticStyleErrorSign   GruvboxRedSign
highlight link SyntasticStyleWarningSign GruvboxPurpleSign

" pedrohdz/vim-yaml-folds                                           " brew install yamllint; pipx install yamllint
set foldlevelstart=20

" dense-analysis/ale                                                " :help g:ale_echo_msg_format
let g:ale_virtualtext_prefix              = '%comment% %severity% [%code%]: '
let g:ale_echo_msg_format                 = '[%linter%] %code%: %s [%severity%] '
let g:ale_echo_msg_error_str              = '✘'
let g:ale_echo_msg_warning_str            = '⚠'
let g:ale_sign_error                      = '💢'                    " ✘ 👾 💣  🙅 🤦
let g:ale_sign_warning                    = 'ᑹᑹ'                    " ⚠ ⸮ ⸘ ☹
let g:ale_sign_info                       = 'ᓆ'                     " ⸚ ϔ 𐘿 𐰦
let g:ale_sign_style_error                = '⍥'                     " ᑹ
let g:ale_sign_style_warning              = 'ᓍ'                     " ᓏ
let g:ale_lint_on_text_changed            = 'never'
let g:ale_fix_on_save                     = 0
let g:ale_popup_menu_enabled              = 1
let g:ale_lint_on_save                    = 1
let g:ale_warn_about_trailing_blank_lines = 1
let g:ale_warn_about_trailing_whitespace  = 1
let g:ale_set_balloons                    = 1
let g:ale_hover_to_preview                = 1
let g:ale_floating_preview                = 1
let g:ale_close_preview_on_insert         = 1
let g:ale_floating_window_border          = [ '│', '─', '╭', '╮', '╯', '╰', '│', '─' ]

" junegunn/fzf.vim
nnoremap <C-p> :Files<CR>
nnoremap <C-g> :GFiles<CR>
nnoremap <C-s> :Ag<CR>
nnoremap <silent><leader>l  :Buffers<CR>
nnoremap <silent> <Leader>H :Helptags<CR>
nnoremap <silent> <Leader>g :Commits<CR>
inoremap <expr> <c-x><c-l> fzf#vim#complete(fzf#wrap({
  \ 'prefix': '^.*$',
  \ 'source': 'rg -n ^ --color always',
  \ 'options': '--ansi --delimiter : --nth 3..',
  \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }
\ }))
let g:fzf_vim                     = {}
let g:fzf_vim.preview_window      = [ 'right,50%', 'ctrl-\' ]
let g:fzf_vim.tags_command        = 'ctags -R'
let g:fzf_vim.commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', 'bat --color=always {}']}, <bang>0)
command! -bang -complete=dir -nargs=? LS
    \ call fzf#run(fzf#wrap('ls', {'source': 'ls', 'dir': <q-args>}, <bang>0))
let g:fzf_layout                  = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true } }
let g:fzf_history_dir             = '~/.vim/cache/fzf-history'
let g:fzf_action                  = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit'
\ }
let g:fzf_colors                  = {
  \ 'fg':         ['fg', 'Normal'                               ] ,
  \ 'bg':         ['bg', 'Normal'                               ] ,
  \ 'preview-bg': ['bg', 'NormalFloat'                          ] ,
  \ 'hl':         ['fg', 'Comment'                              ] ,
  \ 'fg+':        ['fg', 'CursorLine', 'CursorColumn', 'Normal' ] ,
  \ 'bg+':        ['bg', 'CursorLine', 'CursorColumn'           ] ,
  \ 'hl+':        ['fg', 'Statement'                            ] ,
  \ 'info':       ['fg', 'PreProc'                              ] ,
  \ 'border':     ['fg', 'Ignore'                               ] ,
  \ 'prompt':     ['fg', 'Conditional'                          ] ,
  \ 'pointer':    ['fg', 'Exception'                            ] ,
  \ 'marker':     ['fg', 'Keyword'                              ] ,
  \ 'spinner':    ['fg', 'Label'                                ] ,
  \ 'header':     ['fg', 'Comment'                              ]
\ }

" /**************************************************************
"              _                           _
"   __ _ _   _| |_ ___   ___ _ __ ___   __| |
"  / _` | | | | __/ _ \ / __| '_ ` _ \ / _` |
" | (_| | |_| | || (_) | (__| | | | | | (_| |
"  \__,_|\__,_|\__\___/ \___|_| |_| |_|\__,_|
"
" **************************************************************/
if has( "autocmd" )
  autocmd VimLeave           *                      silent clear              " :windo bd
  autocmd BufReadPre         *                      setlocal foldmethod=indent
  autocmd BufWinEnter        *                      if &fdm == 'indent' | setlocal foldmethod=manual | endif
  autocmd BufWinEnter        *                      silent! loadview          " autocmd BufWinLeave * silent! mkview
  autocmd Syntax             *                      syn match ExtraWhitespace /\s\+$\| \+\ze\t/
  autocmd BufEnter           *                      if &diff | let g:blamer_enabled=0 | endif            " ╮ disable git blame in diff mode
  autocmd BufEnter           *                      if ! empty(&key) | let g:blamer_enabled=0 | endif    " ╯ and encrypt mode
  autocmd BufWritePre        *                      %s/\s\+$//e | %s/\r$//e   " automatic remove trailing space
  autocmd BufWritePre        *\(.ltsv\|.diffs\)\@<! silent! retab!            " automatic retab: https://vim.fandom.com/wiki/Remove_unwanted_spaces
  autocmd BufRead,BufNewFile *.t                    set filetype=perl
  autocmd BufRead,BufNewFile *.ltsv                 set filetype=ltsv syntax=groovy noexpandtab
  autocmd QuickFixCmdPost    *grep*                 cwindow
  autocmd FileType           make,snippet,robot     setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType           help                   set nofoldenable
  autocmd Syntax             c,cpp,xml,html,xhtml   normal zM

  augroup DevOps
    autocmd BufRead,BufNewFile *                   setfiletype Jenkinsfile
    autocmd BufRead,BufNewFile *.config            set filetype=config syntax=gitconfig noexpandtab
    autocmd FileType           json,markdown,yaml  set tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType           json,markdown,yaml  setlocal foldmethod=indent
    autocmd Syntax             yaml                normal zM
    autocmd BufEnter           *\(.md\|.markdown\) exe 'noremap <F5> :!"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" %:p "--no-gpu"<CR>'
    autocmd BufRead,BufNewFile .*ignore            set filetype=ignore
    autocmd FileType           ignore,gitconfig    setlocal commentstring=#\ %s
    autocmd FileType           markdown,html       let g:AutoPairsCompleteOnlyOnSpace = 0
    autocmd FileType           markdown,html       let b:AutoPairs = autopairs#AutoPairsDefine({
          \ '<div>':'</div>', '<font>':'</font>', '<a>':'</a>', '<p>':'</p>',
          \ '<table>':'</table>', '<tbody>':'</tbody>',
          \ '<thread>':'</thread>', '<th>':'</th>', '<td>':'</td>'
          \ })
    if index( ['README', 'SUMMARY'], expand("%:r") ) == -1
      autocmd BufWritePost     *\(.md\)            silent :DocTocUpdate       " automatic build doctoc when save it
    endif
    autocmd BufNewFile,BufRead                                                " git config files
          \ *.git/config,.gitconfig,.gitmodules,gitconfig
          \,~/.marslo/.gitalias
          \ setfiletype gitconfig
    if did_filetype()                     | finish      | endif
    if getline(1) =~ '^#!.*[/\\]groovy\>' | setf groovy | endif               " to setup filetype to groovy if first line matches `#!.*[/\\]groovy`
  augroup END

  augroup ShellScript
    autocmd!
    autocmd   Syntax       bash           set filetype=sh
    autocmd   FileType     sh,bash,shell  silent :retab!
    autocmd   FileType     sh,bash,shell  set tabstop=2 softtabstop=2 shiftwidth=2
    autocmd!  BufWritePre  *.sh           silent :retab!                      " automatic retab
    autocmd!  BufWritePost *.sh           silent :redraw!                     " automatic redraw for shellcheck
    " autocmd BufWritePost *.sh           !chmod +x %
  augroup END

  augroup Groovy
    autocmd Filetype   Groovy                set filetype=groovy
    autocmd FileType   groovy,Jenkinsfile    set tabstop=2 softtabstop=2 shiftwidth=2
    autocmd Syntax     groovy,Jenkinsfile    setlocal foldmethod=indent
    autocmd Syntax     groovy,Jenkinsfile    normal zM
    autocmd FileType   Jenkinsfile           setlocal commentstring=//\ %s
    " https://vim.fandom.com/wiki/Syntax_folding_for_Java
    autocmd FileType   java                  setlocal foldmarker=/**,**/ foldmethod=marker foldcolumn=1
    autocmd FileType   javascript            syntax clear jsFuncBlock         " rainbow issue #2
    " autocmd FileType Jenkinsfile           setlocal filetype=groovy syntax=groovy foldmethod=indent
    " autocmd FileType Jenkinsfile           set syntax=groovy filetype=groovy
    " autocmd BufNewFile,BufRead             Jenkinsfile setf groovy
    " autocmd BufNewFile,BufRead,BufReadPost Jenkinsfile setlocal foldmethod=indent
    if getline(1) =~ '^#!.*[/\\]groovy\>' |  setf groovy | endif              " to setup filetype to groovy if first line matches `#!.*[/\\]groovy`
  augroup END

  augroup Python
    autocmd BufNewFile,BufRead python
            \ set tabstop=2 softtabstop=2 shiftwidth=2
            \ setlocal shiftwidth=2 tabstop=2 softtabstop=2 autoindent
            \ fileformat=unix
    autocmd FileType python syntax keyword pythonDecorator print self
    autocmd FileTYpe python set isk-=.
    autocmd Syntax   python setlocal foldmethod=indent
    autocmd Syntax   python normal zM
  augroup END

  augroup vimrc
    autocmd! BufWritePost ~/.vimrc silent! source %
    autocmd  Filetype     vim      let g:ycm_complete_in_strings = 3
    autocmd  Syntax       vim      normal zM
  augroup END

  augroup TermIgnore                                                          " skip quickfix : https://vi.stackexchange.com/a/16709/7389
    autocmd!
    autocmd TerminalOpen * set nobuflisted
  augroup END

  augroup CustomTabularize
    autocmd!
    " https://github.com/jwhitley/vimrc/blob/master/.vimrc
    " autocmd VimEnter * if exists(":Tabularize") | exe ":AddTabularPattern! bundles /[^ ]\\+\\//l1r0" | endif
    " add for plugin/TabularMaps.vim
    autocmd VimEnter * if exists(":Tabularize") | exe ":AddTabularPattern 1,  /^[^,]*\zs,/r1c1l0" | endif
    autocmd VimEnter * if exists(":Tabularize") | exe ":AddTabularPattern 1=  /^[^=]*\zs="        | endif
    autocmd VimEnter * if exists(":Tabularize") | exe ":AddTabularPattern 1== /^[^=]*\zs=/r1c1l0" | endif
  augroup END

  augroup CollumnLimit
    set colorcolumn=80
    highlight CollumnLimit    guibg=NONE    guifg=#4e4e4e    ctermfg=240
    autocmd!
    let collumnLimit = 80
    let pattern      = '\%<' . ( collumnLimit+1 ) . 'v.\%>' . collumnLimit . 'v'
    let w:m1         = matchadd( 'CollumnLimit', pattern, -1 )
  augroup END

  if version > 703
    " autocmd FocusLost * set norelativenumber
    autocmd FocusGained * set relativenumber
    autocmd InsertEnter * set norelativenumber
    autocmd InsertLeave * set relativenumber
    autocmd CmdwinEnter * set norelativenumber
    autocmd CmdwinLeave * set relativenumber
    autocmd CmdwinEnter * let b:ei_save = &eventignore | set eventignore=CursorHold,InsertEnter
    autocmd CmdwinLeave * let &eventignore = b:ei_save
  endif
endif

highlight SpellBad        term=underline   cterm=underline     ctermbg=0
highlight ExtraWhitespace ctermbg=red      guibg=red
highlight DiffText        term=reverse     cterm=reverse       ctermfg=109      ctermbg=235 gui=reverse guifg=#fabd2f guibg=#458588
" highlight Cursor        guifg=white      guibg=gray          gui=bold
" highlight iCursor       guifg=white      guibg=steelblue     gui=underline

" vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=vim:foldmethod=marker:foldmarker="\ **************************************************************/,"\ /**************************************************************
