set noet
set tw=80

NeoCompleteEnable

command! -nargs=* R GoRename <args>
command! -nargs=* D GoDef <args>
map <buffer> <C-]> <Plug>(go-def)
