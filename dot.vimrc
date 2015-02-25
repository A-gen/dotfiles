" vim: foldmethod=marker foldcolumn=4
" NeoBundle{{{
"  Base{{{
if has('vim_starting')
  if &compatible
    set nocompatible
  endif

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/unite.vim'
"  }}}
" Plugins{{{
"   vimproc{{{
NeoBundle 'Shougo/vimproc',
      \ {
      \   'build' : {
      \     'windows' : 'echo "Sorry, cannot update vimproc binary file in Windows."',
      \     'cygwin'  : 'make -f make_cygwin.mak',
      \     'mac'     : 'make -f make_mac.mak',
      \     'unix'    : 'make -f make_unix.mak',
      \   },
      \ }
"   }}}
NeoBundle has('lua') ? 'Shougo/neocomplete' : 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'w0ng/vim-hybrid'
" }}}
"  Post-process{{{
call neobundle#end()
filetype plugin indent on
NeoBundleCheck
"  }}}
" }}}
" Base{{{
set encoding=utf8
set fileencoding=utf-8
set autoread
set noswapfile
set relativenumber
set ruler
set backspace=indent,eol,start

set list
set listchars=tab:»-,trail:-,nbsp:%,eol:↲

set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smarttab

set showtabline=2
set laststatus=2

set t_ut=
set t_Co=256

set cursorline
autocmd VimEnter,ColorScheme * : highlight CursorLine cterm=underline ctermbg=234

syntax on
colorscheme hybrid
set background=dark
" }}}
" Plugin settings{{{
"  neocomplete{{{
if neobundle#is_installed('neocomplete')
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_ignore_case = 1
  let g:neocomplete#enable_smart_case = 1
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns._ = '\h\w*'
elseif neobundle#is_installed('neocomplcache')
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_ignore_case = 1
  let g:neocomplete#enable_smart_case = 1
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns._ = '\h\w*'
endif
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
"  }}}
"  neosnippet{{{
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
"  }}}
"  fugitive{{{
nnoremap <silent> <Space>gb :Gblame<CR>
nnoremap <silent> <Space>gd :Gdiff<CR>
nnoremap <silent> <Space>gs :Gstatus<CR>
"  }}}
"  git-gutter{{{
let g:gitgutter_sign_added = '✚'
let g:gitgutter_sign_modified = '➜'
let g:gitgutter_sign_removed = '✘'
"  }}}
"  vimfiler{{{
nnoremap <F2> :VimFilerTree<CR>

command! VimFilerTree call VimFilerTree(<f-args>)
function! VimFilerTree(...)
  let l:h = expand(a:0 > 0 ? a:1 : '%:p:h')
  let l:path = isdirectory(l:h) ? l:h : ''
  exec ':VimFiler -buffer-name=explorer -split -simple -winwidth=45 -toggle -no-quit ' . l:path
  wincmd t
  setl winfixwidth
endfunction

autocmd! FileType vimfiler call s:my_vimfiler_settings()
function! s:my_vimfiler_settings()
  nmap     <buffer><expr><CR> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
  nnoremap <buffer>s          :call vimfiler#mappings#do_action('my_split')<CR>
  nnoremap <buffer>v          :call vimfiler#mappings#do_action('my_vsplit')<CR>
endfunction

let my_action = {'is_selectable' : 1}
function! my_action.func(candidates)
  wincmd p
  exec 'split '. a:candidates[0].action__path
endfunction
call unite#custom_action('file', 'my_split', my_action)

let my_action = {'is_selectable' : 1}
function! my_action.func(candidates)
  wincmd p
  exec 'vsplit '. a:candidates[0].action__path
endfunction
call unite#custom_action('file', 'my_vsplit', my_action)
"  }}}
"  lightline{{{
let g:lightline = {
  \   'colorscheme': 'wombat',
  \   'separator': {'left': '⮀', 'right': '⮂'},
  \   'subseparator': {'left': '⮁', 'right': '⮃'},
  \   'active': {
  \     'left':  [
  \       ['mode', 'readonly', 'paste'],
  \       ['fugitive', 'gitgutter', 'filename']
  \     ],
  \     'right': [
  \       [ 'lineinfo' ],
  \       [ 'percent' ],
  \       [ 'fileformat', 'fileencoding', 'filetype' ]
  \     ]
  \   },
  \   'component_function': {
  \     'mode': 'MyMode',
  \     'readonly': 'MyReadonly',
  \     'modified': 'MyModified',
  \     'filename': 'MyFilename',
  \     'fugitive': 'MyFugitive',
  \     'gitgutter': 'MyGitGutter'
  \   }
  \ }
"   functions{{{
function! MyMode()
  return &ft =~ 'help\|vimfiler' ? &ft : lightline#mode()
endfunction

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &ro ? '⭤' : ''
endfunction

function! MyFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      let _ = fugitive#head()
      return strlen(_) ? '⭠ '._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! MyGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= 90
    return ''
  endif
  let symbols = [
        \ g:gitgutter_sign_added . ' ',
        \ g:gitgutter_sign_modified . ' ',
        \ g:gitgutter_sign_removed . ' '
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction

function! MyFilename()
  return &ft =~ 'help\|vimfiler' ? &ft : 
        \ ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction
"   }}}
"  }}}
" }}}
