" Vim color file
" Maintainer:   Qi Xiao <xiaqqaix@gmail.com>
" Last Change:  23 Mar 2016

set background=light
highlight clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="plain"

hi None cterm=NONE
"hi TextLike ctermfg=229
hi TextLike ctermfg=3
hi KeywordLike cterm=bold
hi Reverse cterm=Reverse
"hi ErrorLike ctermfg=196
hi ErrorLike ctermfg=1

hi! link String TextLike
hi! link Comment TextLike
hi! link Character TextLike
hi! link LineNr TextLike

hi! link Keyword KeywordLike
hi! link Statement KeywordLike
hi! link PreProc KeywordLike
hi! link Identifier KeywordLike

hi! link SpecialKey None
hi! link NonText None
hi! link Directory None
hi! link MoreMsg None
hi! link ModeMsg None
hi! link Constant None
hi! link Ignore None

hi! link ErrorMsg ErrorLike
hi! link Error ErrorLike

hi! link IncSearch Reverse
hi! link Search Reverse

hi! MatchParen cterm=Reverse ctermfg=NONE ctermbg=White
hi! Question cterm=standout ctermfg=NONE ctermbg=NONE
hi! StatusLine cterm=bold,reverse ctermfg=NONE ctermbg=NONE
hi! StatusLineNC cterm=reverse ctermfg=NONE ctermbg=NONE
hi! VertSplit cterm=reverse ctermfg=NONE ctermbg=NONE
hi! Title cterm=bold ctermfg=NONE ctermbg=NONE
hi! Visual cterm=reverse ctermfg=NONE ctermbg=NONE
hi! VisualNOS cterm=bold ctermfg=NONE ctermbg=NONE
hi! WarningMsg cterm=standout ctermfg=NONE ctermbg=NONE
hi! WildMenu cterm=standout ctermfg=NONE ctermbg=NONE
hi! Folded cterm=standout ctermfg=NONE ctermbg=NONE
hi! FoldColumn cterm=standout ctermfg=NONE ctermbg=NONE
hi! DiffAdd cterm=bold ctermfg=NONE ctermbg=NONE
hi! DiffChange cterm=bold ctermfg=NONE ctermbg=NONE
hi! DiffDelete cterm=bold ctermfg=NONE ctermbg=NONE
hi! DiffText cterm=reverse ctermfg=NONE ctermbg=NONE
hi! Special cterm=bold ctermfg=NONE ctermbg=NONE
hi! Type cterm=bold ctermfg=NONE ctermbg=NONE
hi! Underlined cterm=underline ctermfg=NONE ctermbg=NONE
hi! Todo cterm=standout ctermfg=NONE ctermbg=NONE
hi! Pmenu ctermfg=black ctermbg=white
