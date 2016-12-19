if !&compatible
  set nocompatible
endif

" vim-plug {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !mkdir -p ~/.vim/autoload ~/.vim/plugged
  silent !git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/
  silent !ln -s ~/.vim/plugged/vim-plug/plug.vim ~/.vim/autoload/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-plug'
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'w0ng/vim-hybrid'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'
Plug 'Shougo/neocomplete.vim'
Plug 'Shougo/neosnippet-snippets' | Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/unite.vim' | Plug 'Shougo/vimfiler.vim'

let s:plugs = {'plugs': get(g:, 'plugs', {})}
function! s:plugs.is_installed(name)
  return has_key(self.plugs, a:name) ? isdirectory(self.plugs[a:name].dir) : 0
endfunction

call plug#end()
" }}}

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
set autoindent

set showtabline=2
set laststatus=2

set cursorline

set t_ut=

if s:plugs.is_installed('vim-hybrid')
  set background=dark
  colorscheme hybrid
endif

if s:plugs.is_installed('neosnippet.vim')
  imap <C-k> <Plug>(neosnippet_expand_or_jump)
  smap <C-k> <Plug>(neosnippet_expand_or_jump)
  xmap <C-k> <Plug>(neosnippet_expand_target)
endif

if s:plugs.is_installed('neocomplete.vim')
  let g:acp_enableAtStartup = 0
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_smart_case = 1
  let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default' : '',
        \ }
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
endif

if s:plugs.is_installed('vimfiler.vim')
  nnoremap <silent> <F2> :VimFilerTree<CR>
  let g:vimfiler_as_default_explorer = 1

  call vimfiler#custom#profile('default', 'context', {
        \ 'safe' : 0,
        \ 'auto_expand' : 1,
        \ 'parent' : 0,
        \ })

  function! VimFilerTree(...)
    let l:h = expand(a:0 > 0 ? a:1 : '%:p:h')
    let l:path = isdirectory(l:h) ? l:h : ''
    exec ':VimFiler -buffer-name=explorer -split -simple -winwidth=45 -toggle -no-quit ' . l:path
    wincmd t
    setl winfixwidth
  endfunction
  command! VimFilerTree call VimFilerTree(<f-args>)

  autocmd! FileType vimfiler call s:my_vimfiler_settings()
  function! s:my_vimfiler_settings()
    nmap     <buffer><expr><CR> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
    nnoremap <buffer>s          :call vimfiler#mappings#do_action(b:vimfiler, 'my_split')<CR>
    nnoremap <buffer>v          :call vimfiler#mappings#do_action(b:vimfiler, 'my_vsplit')<CR>
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
endif

if s:plugs.is_installed('vim-gitgutter')
  let g:gitgutter_sign_added = '+'
  let g:gitgutter_sign_modified = '~'
  let g:gitgutter_sign_removed = '-'
  nmap ]h <Plug>GitGutterNextHunk
  nmap [h <Plug>GitGutterPrevHunk
endif

if s:plugs.is_installed('vim-fugitive')
  nnoremap <silent> <Leader>gb :Gblame<CR>
  nnoremap <silent> <Leader>gd :Gdiff<CR>
  nnoremap <silent> <Leader>gs :Gstatus<CR>
endif

if s:plugs.is_installed('lightline.vim')
  let g:lightline = {
        \   'colorscheme': 'wombat',
        \   'mode_map': {'c': 'NORMAL'},
        \   'active': {
        \     'left': [
        \       ['mode', 'paste'],
        \       ['fugitive', 'gitgutter', 'filename'],
        \     ],
        \   },
        \   'component_function': {
        \     'mode': 'MyMode',
        \     'modified': 'MyModified',
        \     'gitgutter': 'MyGitGutter',
        \     'fugitive': 'MyFugitive',
        \   },
        \ }

  function! MyModified()
    return &ft =~ 'vim-plug\|help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
  endfunction

  function! MyMode()
    return winwidth('.') > 60 ? lightline#mode() : ''
  endfunction

  function! MyFugitive()
    try
      if &ft !~? 'vim-plug\|vimfiler\|gundo' && exists('*fugitive#head')
        let _ = fugitive#head()
        return _
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
endif
