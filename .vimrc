
set et
set tabstop=4
set shiftwidth=4

autocmd BufRead,BufNewFile *.c,*.h set noic cin noet
autocmd BufRead,BufNewFile *.c,*.h set noic cin tabstop=8
autocmd BufRead,BufNewFile *.c,*.h set noic cin shiftwidth=8
set smartindent
syntax on
set number
set noeb vb t_vb=
au GUIEnter * set vb t_vb=
set backspace=2
colorscheme darkblue
filetype plugin indent on
syntax enable