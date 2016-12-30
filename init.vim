let g:cache_home = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME

let s:dein_cache_dir = g:cache_home . '/dein'

augroup MyAutoCmd
  autocmd!
augroup END

if &runtimepath !~# '/dein.vim'
  let s:dein_repo_dir = s:dein_cache_dir . '/repos/github.com/Shougo/dein.vim'

  if !isdirectory(s:dein_repo_dir)
    call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
  endif

  execute 'set runtimepath^=' . s:dein_repo_dir
endif

" dein.vim settings
let g:dein#install_max_processes = 16
let g:dein#install_progress_type = 'title'
let g:dein#install_message_type = 'none'
let g:dein#enable_notification = 1

if dein#load_state(s:dein_cache_dir)
  call dein#begin(s:dein_cache_dir)

  let s:toml_dir = g:config_home . '/nvim/dein'

  call dein#load_toml(s:toml_dir . '/plugins.toml', {'lazy': 0})
  call dein#load_toml(s:toml_dir . '/lazy.toml', {'lazy': 1})
  if has('python3')
    call dein#load_toml(s:toml_dir . '/nvim.toml', {'lazy' : 0})
  endif

  call dein#end()
  call dein#save_state()
endif

if has('vim_starting')
  if dein#check_install(['vimproc'])
    call dein#install(['vimproc'])
  endif
  if dein#check_install()
    call dein#install()
  endif
endif

" インサートモード時のみESCをjjでも許可
inoremap <silent> jj <ESC>
" 文字列検索後のハイライトを解除
noremap <silent> <Esc><Esc> :<C-u>nohlsearch<Cr><Esc>
" 数値のインクリメント
vnoremap <C-a> <C-a>gv
" 数値のデクリメント
vnoremap <C-x> <C-x>gv
" vv で行末まで選択
vnoremap v ^$h

" 画面幅を均等にします
nnoremap = <C-w>=
" 画面幅を増やします
nnoremap > <C-w>>
" 画面幅を減らします
nnoremap < <C-w><
" 置換
nnoremap s/ :%s/

" tabキーで次の検索候補を選択
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" S-tabキーで前の検索候補を選択
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" スーパーユーザとしてファイルを上書き
nnoremap wtee :w !sudo tee %

" シンタックスハイライトON
syntax on
" ファイル形式の自動検出
filetype plugin indent on

" カラースキームの設定
if ! dein#check_install(['molokai'])
  " スキームにはmolokaiを使用
  colorscheme molokai
" コメントの色変更
hi Comment ctermfg=Gray
endif

" タブを複数のスペースに置き換え
set expandtab
" タブの文字数
set tabstop=2
" 自動インデントした際のズレ幅
set shiftwidth=2
" 改行時に前行のインデントを継続
set autoindent
" 改行時に入力された行の末尾にあわせて次の行のインデントを増減
set smartindent

" 行番号表示
set number
" ビープ音OFF
set visualbell
set vb t_tb=
" バックアップファイルを作成しない
set nobackup 

" タブ文字，行末など不可視文字を可視化
set list
"タブと改行を指定文字で可視化
set listchars=tab:»\ ,eol:¶

" 検索時に大文字小文字の区別を行わない
set ignorecase
" 検索時に大文字が入力された場合のみ大文字小文字の区別を行う
set smartcase

" 色を256階調に設定
set t_Co=256

" ファイル形式の自動検出
filetype plugin indent on

" 全角スペースを表示
function! ZnkakSpace()
  highlight ZnkakSpace cterm=underline ctermfg=grey gui=underline guifg=grey
endfunction

if has('syntax')
  augroup ZnkakSpace
    autocmd!
    " ZnkakSpaceをカラーファイルで設定するなら次の行は削除
    autocmd ColorScheme * call ZnkakSpace()
    " 全角スペースのハイライト指定
    autocmd VimEnter,WinEnter * match ZnkakSpace /　/
    autocmd VimEnter,WinEnter * match ZnkakSpace '\%u3000'
  augroup END
  call ZnkakSpace()
endif
