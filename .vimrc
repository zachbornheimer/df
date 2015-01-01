
set et
set tabstop=4
set shiftwidth=4
set t_Co=256

autocmd BufRead,BufNewFile *.c,*.h set noic cin noet
autocmd BufRead,BufNewFile *.c,*.h set noic cin tabstop=8
autocmd BufRead,BufNewFile *.c,*.h set noic cin shiftwidth=8

set smartindent
syntax on
set number
set noeb vb t_vb=
au GUIEnter * set vb t_vb=
set backspace=2
colorscheme Tomorrow-Night-Bright
filetype plugin indent on
syntax enable
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;
nnoremap zz ZZ
nnoremap ZZ zz

if strftime("%H") < 8 || strftime("%H") > 22
    colorscheme Tomorrow-Night
else
    colorscheme Tomorrow-Night-Bright
endif

" w = save, w! = force-save, w!! = force sudo save
cmap w!! w !sudo tee > /dev/null %

" POD file settings
autocmd Filetype pod source ~/.vim/plugins/autocorrect.vimplugin
autocmd Filetype pod setlocal spell textwidth=79

" Git commit modifications
autocmd Filetype gitcommit setlocal spell textwidth=72