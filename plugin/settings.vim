set nocompatible " Make vim uncompatible with old vi

set autoread " Automatically read changed files

set ignorecase
set smartcase

" ----- Fixing Vim (fix insane defaults) {{{
set mouse=a " Make Vim recognize mouse events
set path+=**

filetype plugin on

" Automatically load tags file if it exists
set tags=./tags;/
" }}}
 
" ----- Disable sounds on errors {{{
" Disable sounds on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500
autocmd! GUIEnter * set vb t_vb=
" }}}

" ----- Appearance {{{
colorscheme monokai                 
"colorscheme xcode-midnight

if has("gui_running")
    set guifont=Monaco:h13
    
    " Make the window as big as possible
    set lines=999
    set columns=999
endif

syntax on
filetype indent on " Filetype specific indentation

set cursorline " Highlight the line the cursor is on

" Search highlighting {{{
set hlsearch
set incsearch

:augroup search_highlighting
:   autocmd!
:   autocmd InsertEnter * :noh
:augroup end
" }}}

" Place at least 10 lines at the bottom or on top of the cursor
set scrolloff=10
" }}}
 
" ----- Indentation {{{
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab

set shiftround  " Make indent a multiple of shiftwidth
" }}}
 
" ----- Line numbers {{{
set relativenumber
set number


if v:version > 703 " hybrid mode does not work with <= Vim 7.3 
    augroup line_numbering
        autocmd!
        autocmd  InsertEnter * :set norelativenumber
        autocmd  InsertEnter * :set number
        autocmd  InsertLeave * :set relativenumber
    augroup end
endif
" }}}
 
" ----- Quiting {{{
" Quits the current buffer it is a saved file or if it is a buffer without a
" file
" And reports an error otherwise
" Returns 1 if it quit and 0 if it didn't
function! QuitWithoutSaving(quitCommand)
   " Is the current buffer a real file?
   if filereadable(bufname("%"))
       " Is it saved?
       if &modified
           redraw
           "if input("Quit with unsaved changes (y/n)? ", "n") ==~ "y"
           echo "Quit with unsaved changes (y/n) or save and quit (s)? "
           let input = nr2char(getchar())
           if input ==? "y"
               execute a:quitCommand
               return 1
           elseif input ==? "s"
               write
               execute a:quitCommand
               return 1
           else
               redraw
               echo
               return 0
           endif
       endif
   endif
   " Quit
   execute a:quitCommand
   return 1
endfunction
" }}}
 
" ----- Tab for completion {{{
"  Breaks with YCM plugin
" Autocomplete with tab
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    if &filetype ==# "css"
      return "\<c-x>\<c-o>"
    else
      return "\<C-N>"
    endif
  else
    return "\<Tab>"
  endif
endfunction

inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
" }}}

" ----- Spelling {{{
set dictionary="/usr/dict/words"
" Load common abbreviations
call spelling#LoadSpellingAbbrevs()
" }}}

" ----- Folding {{{
" Close all folds
set foldlevelstart=0
" A column that indicates whether something is folded or not
set foldcolumn=1 
" }}}
 
" ----- Commands {{{
command! Reloadrc runtime! plugin/*.vim
" }}}

" ----- Numbers {{{
" I don't use octal numbers so make <c-a> and <c-x> ignore them
set nrformats=hex
" }}}

" ----- You Complete Me {{{
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_filetype_whitelist = { 
            \ "cpp"        : 1,
            \ "c"          : 1,
            \ "python"     : 1,
            \ "css"        : 1,
            \ "javascript" : 1,
            \ "scss"       : 1,
            \ "java"       : 1,
            \ "objc"       : 1,
            \ "swift"      : 1,
            \}

" Additional triggers for css (empty lines and :)
let g:ycm_semantic_triggers = { 
            \ "css": [ 're!\s*' , '.' ],
        \ }

let g:ycm_global_ycm_extra_conf = '~/environment/vim/default_ycm_extra_conf.py'
let g:ycm_extra_conf_globlist = ['~/environment/vim/default_ycm_extra_conf.py']
" }}}

" ----- Completion for commands {{{
set wildmenu
set wildchar=<Tab>
set wildmode=full
" }}}

" ----- EasyAlign Settings {{{
  
let g:easy_align_delimiters = {
            \  ' ': { 'pattern': ' ',  'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 },
            \  '=': { 'pattern': '===\|<=>\|\(&&\|||\|<<\|>>\)=\|=\~[#?]\?\|=>\|[:+/*!%^=><&|.-]\?=[#?]\?',
            \                          'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
            \  ':': { 'pattern': ':',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
            \  ',': { 'pattern': ',',  'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 },
            \  '|': { 'pattern': '|',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
            \  '.': { 'pattern': '\.', 'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 },
            \  '#': { 'pattern': '#\+', 'delimiter_align': 'l', 'ignore_groups': ['!Comment']  },
            \  '&': { 'pattern': '\\\@<!&\|\\\\',
            \                          'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
            \  '{': { 'pattern': '(\@<!{',
            \                          'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
            \  '}': { 'pattern': '}',  'left_margin': 1, 'right_margin': 0, 'stick_to_left': 0 }
            \ }
" }}}

" ----- Persistent undo {{{
if has("persistent_undo")
    let undoDir = expand("$HOME/.vim/undodir")
    call system("mkdir " . undoDir)
    let &undodir = undoDir
    set undofile
endif
"  }}}

" ----- Netrw settings {{{
let g:netrw_banner = 0
let g:netrw_liststyle = 3
" }}}
