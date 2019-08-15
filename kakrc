# deploy: .config/kak/kakrc

set global tabstop 4
#set global ui_options ncurses_assistant=true:ncurses_enable_mouse=true
add-highlighter global/ wrap
add-highlighter global/ number-lines

# Mappings
# ========

# Up and Down scrolls the view and keeps the physical position of the cursor.
map global normal <up> kvk
map global normal <down> kvj
# Use - and = to move to previous and next empty line, like { and } in Vim.
map global normal <minus> <a-/>\n{2,}[^\n]<ret>\;
map global normal = /\n{2,}[^\n]<ret>\;
# ^D to quit, like shell
map global normal <c-d> :q<ret>

# Aliases and Custom Commands
# ===========================
alias global h doc
alias global s source

# Hooks
# ====
hook global WinSetOption filetype=go %{
    go-enable-autocomplete
    hook window BufWritePost .* %{ go-format -use-goimports }
    # Format comments
    map window normal <#> "|par p3 w${kak_opt_autowrap_column}<ret>"
}

hook global WinSetOption filetype=elvish %{
	set window tabstop 2
	set window indentwidth 2
}
