"-----------------------------------------------------------------------------
" Editor
"
" Binary editor mode (vim -b or *.bin to enable binary mode)
augroup BinaryXXD
	autocmd!
	autocmd BufReadPre  *.bin let &binary =1
	autocmd BufReadPost * if &binary | silent %!xxd -g 1
	autocmd BufReadPost * set ft=xxd
	autocmd BufReadPost * endif
	autocmd BufWritePre * if &binary | %!xxd -r
	autocmd BufWritePre * endif
	autocmd BufWritePost * if &binary | silent %!xxd -g 1
	autocmd BufWritePost * set nomod
	autocmd BufWritePost * endif
augroup END

"-----------------------------------------------------------------------------
" Tab 
"
set showtabline=2
"set tabline=%!MyTabLine()
function MyTabLine()
	let s = ''
	for i in range(tabpagenr('$'))
		if i + 1 == tabpagenr()
			let s .= '%#TabLineSel#'
    	else
			let s .= '%#TabLine#'
		endif
		let s .= '%' . (i+1) . 'T'
		let s .= ' ' . (i+1) . ' %{MyTabLabel(' . (i+1) . ')} '
	endfor
	let s .= '%#TabLineFill#%T'
	if tabpagenr('$') > 1
		let s .= '%=%#TabLine#%999Xclose'
	endif
	return s
endfunction

function MyTabLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	return bufname(buflist[winnr - 1])
endfunction

map <c-l> :tabn<lf>
map <c-h> :tabp<lf>
hi TabLine     term=reverse cterm=reverse ctermfg=white ctermbg=black
hi TabLineSel  term=bold cterm=bold,underline ctermfg=5
hi TabLineFill term=reverse cterm=reverse ctermfg=white ctermbg=black

"-----------------------------------------------------------------------------
" Looking & Decoration
"

"Enalbe Syntax Hilights
if &t_Co > 2 || has("gui_running")
  syntax on
"  set hlsearch
endif
" tab width
set tabstop=2
set shiftwidth=2
" Replace tab to spaces
" set expandtab
" Hilights corresponding brackets
set showmatch
"Always show status line
set laststatus=2
"Show encoding and return code
"set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set statusline=%n\:%y%F\ \|%{(&fenc!=''?&fenc:&enc).'\|'.&ff.'\|'}%m%r%=%l,%c%V%8P
"Colour of status line
"Show selectable colour
":edit $VIMRUNTIME/syntax/colortest.vim
":source %
highlight StatusLine   term=NONE cterm=NONE ctermfg=lightred ctermbg=lightblue
highlight StatusLineNC   term=NONE cterm=NONE ctermfg=white ctermbg=black


"-----------------------------------------------------------------------------
" Compiler
"
set autowrite
autocmd BufRead *.pl compiler perl
autocmd BufRead *.py setlocal makeprg=/usr/bin/python\ %
autocmd BufRead *.sh setlocal makeprg=/bin/bash\ %
autocmd BufNewFile,BufRead *.go setlocal noet ts=2 sw=2 sts=2

"autocmd BufRead,BufNewFile *.py set filetype=py
"autocmd FileType py setlocal makeprg=/usr/bin/python\ %

"-----------------------------------------------------------------------------
" Others
"	
set nocompatible	" Use Vim defaults (much better!)
set nohlsearch
set bs=2        " allow backspacing over everything in insert mode
if has("autocmd")
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
endif

map <c-m> <c-w>_<c-w>\|
map <c-n> <c-w>=
"map <c-c><c-d> :!gcc -g % -o %< &&　clear && gdb %< && rm -f %<<lf>

" How to install
" git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtre
map <c-w><c-d> :NERDTree<CR>
"autocmd vimenter * NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
