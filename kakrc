set global tabstop 4
set global ui_options ncurses_assistant=true:ncurses_enable_mouse=true

# Mappings
# ========

# Up and Down scrolls the view and keeps the physical position of the cursor.
map global normal <up> kvk
map global normal <down> jvj
# I use Alt-H and Alt-L for tmux bindings.
map global normal <c-h> <a-h>
map global normal <c-l> <a-l>
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
hook global WinSetOption filetype=go %{ go-enable-autocomplete }
