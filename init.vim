" 自己基于别人的配置从头开始修改一份配置文件
" 参考 https://zhuanlan.zhihu.com/p/69725463
" date 2019年 11月 01日 星期五 09:49:20 CST

" 
"let g:python3_host_prog='/usr/bin/python3'

" 安装包管理器
" curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" 指定插件目录
" -对于Neovim：stdpath（'data'）. '/ plugged'
" -避免使用标准的Vim目录名称，例如'plugin'
" 使用 `:PlugInstall` 来安装插件
call plug#begin('~/.vim/plugged')

" 确保使用单引号
" 主题插件
Plug 'jacoborus/tender.vim'

" 括号匹配
Plug 'jiangmiao/auto-pairs'

" 状态栏
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" 文件系统浏览器 
Plug 'scrooloose/nerdtree'

" Python 代码折叠
Plug 'tmhedberg/SimpylFold'

" PEP8 缩进
Plug 'vim-scripts/indentpython.vim'

" 自动补全
Plug 'Valloric/YouCompleteMe'

" 自动输入法切换
Plug 'zhmars/vim-ibus', {'as': 'ibus'}

" 初始化插件系统
call plug#end()

" 禁止生成 swap 恢复文件
" 早期计算机经常崩溃，vim 会自动创建一个 .swp 结尾的文件
" 崩溃重启后可以从 .swap 文件恢复
" 现在计算机鲜少崩溃了，可以禁用此功能
set noswapfile

" vim 内部使用的编码，默认使用 latin1，改成通用的 utf8 编码，避免乱码
set encoding=utf-8

" 文件编码探测列表
" vim 启动的时候会依次使用本配置中的编码对文件内容进行解码
" 如果遇到解码失败，则尝试使用下一个编码
" 常见的乱码基本都是 windows 下的 gb2312, gbk, gb18030 等编码导致的
" 所以探测一下 utf8 和 gbk 足以应付大多数情况了
set fileencodings=utf-8,gb18030

" 在插入模式按回车时 vim 会自动根据上一行的缩进级别缩进
set autoindent

" 修正 vim 删除/退格键行为
" 原生的 vim 行为有点怪：
" 如果你在一行的开头切换到插入模式，这时按退格无法退到上一行
" 如果你在一行的某一列切换到插入模式，这时按退格无法退删除这一列之前的字符
" 如果你开启了 autoindent，按回车时 vim 会根据上一行自动缩进，这时按退格无法删除缩进字符
" 通过设置 eol, start 和 indent 可以修正上述行为
set backspace=eol,start,indent

" vim 默认使用单行显示状态，但有些插件需要使用双行展示，不妨直接设成 2
set laststatus=2

" 高亮第 80 列，推荐
set colorcolumn=80

" 高亮光标所在行，推荐
" 有人还会高亮当前列，可以通过 set cursorcolumn 开启，但有点过了，不推荐
set cursorline

" 显示窗口比较小的时候折行展示，不然需要水平翻页，推荐
set linebreak

" 开启语法高亮
syntax on

" 开启自动识别文件类型，并根据文件类型加载不同的插件和缩进规则
filetype plugin indent on

" 打开行号
set number

"" 设置高亮行颜色
"" ctermbg: 背景色  ctermfg：前景色 guibg：下划线背景色
"" guifg：下划线前景色
"hi CursorLine   cterm=NONE ctermbg=black ctermfg=blue guibg=NONE guifg=NONE
"" 高亮列颜色
"hi CursorColumn cterm=NONE ctermbg=black ctermfg=blue guibg=NONE guifg=NONE


" 开启 24 位真彩色支持
" 24位真彩色信息请参考 https://gist.github.com/XVilka/8346728
" 在我的背景下太丑，所以关闭, 应该是我的 terminal 不支持真彩色的原因
"if $COLORTERM == 'truecolor'
"	set termguicolors
"	colorscheme tender
"else
"	set term=urxvt
"	set t_Co=256
"endif

" 设置主题
set termguicolors
colorscheme tender

" 映射NERDTree
" 当按 \+e 时 vim 打开 NERDTree；按 \+f vim 会打开 NERDTree 并定位到当前文件
nnoremap <silent> <leader>e :NERDTreeToggle<cr>
nnoremap <silent> <leader>f :NERDTreeFind<cr>

" 重新映射分割窗口快捷键
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" 开启折叠功能
set foldmethod=indent
set foldlevel=99

" 将折叠快捷键映射到 空格键
nnoremap <space> za

" 标示不必要的空白字符
highlight BadWhitespace guifg=gray guibg=red ctermfg=gray ctermbg=red
autocmd BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Python 虚拟环境支持
python3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
	project_base_dir = os.environ['VIRTUAL_ENV']
	activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
	execfile(activate_this, dict(__file__=activate_this))
EOF

" 隐藏 NERDTree 中的 .pyc 文件
let NERDTreeIgnore=['\.pyc$', '\~$', '__pycache__']

" 自动补全中跳转的定义，Ctrl+o 跳回
nnoremap <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" """"""""""""""
" 跳转到关键字的定义处，<C-]>
" 回退 <C-t>
" """"""""""""""
" 映射 F5 来创建 ctags 索引
"nnoremap <f5> :ctags -R<CR>

" 在每次保存文件时自动执行 ctags
"autocmd BufWritePost *.py call system("ctags -R")

let g:ibus#layout = 'xkb:us::eng'
let g:ibus#engine = 'rime'

