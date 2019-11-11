# deploy: .config/kak/kakrc

set global tabstop 4
add-highlighter global/ wrap
add-highlighter global/ number-lines
add-highlighter global/ show-matching
set-face global MatchingChar +r

# Mappings
# ========

# Up and Down scrolls the view and keeps the physical position of the cursor.
map global normal <up> kvk
map global normal <down> jvj
# Use - and = to move to previous and next paragraph, like { and } in Vim.
map global normal <minus> '[p;'
map global normal = ']p;'
# ^D to quit, like shell
map global normal <c-d> :q<ret>
# ^W in insert mode
map global insert <c-w> '<left><a-;><a-B><a-;>"_d'
map global normal Y <a-j>
map global normal "'" :lsp-hover<ret>

# Aliases and Custom Commands
# ===========================
alias global h doc
alias global s source

eval %sh{kak-lsp --kakoune -s $kak_session}
#set global lsp_cmd "kak-lsp -s %val{session} -vvv --log /tmp/kak-lsp.log"

define-command -params 0..1 -file-completion split %{ nop %sh{
    tmux split
    tmux send-keys "kak -c $kak_session ${1:-$kak_buffile}" Enter
}}
define-command -params 0..1 -file-completion vsplit %{ nop %sh{
    tmux split -h
    tmux send-keys "kak -c $kak_session ${1:-$kak_buffile}" Enter
}}

alias global sp split
alias global vsp vsplit

alias global ren lsp-rename-prompt

# Hooks
# ====

hook global WinSetOption filetype=(go|typescript) %{
    lsp-enable-window
}

hook global WinSetOption filetype=go %{
    hook window BufWritePost .* %{ go-format -use-goimports }
    # Format comments
    map window normal <#> "|par T4 Q+/ q ${kak_opt_autowrap_column}<ret>"
}

hook global WinSetOption filetype=elvish %{
	set window tabstop 2
	set window indentwidth 2
}

hook global InsertCompletionShow .* %{
    map window insert <tab> <c-n>
    map window insert <down> <c-n>
    map window insert <up> <c-p>
}
hook global InsertCompletionHide .* %{
    unmap window insert <tab>
    unmap window insert <down>
    unmap window insert <up>
}

#
declare-option -hidden range-specs show_matching_range

hook global -group kakrc-matching-ranges InsertChar '[[\](){}<>]' %{
    eval -draft %{
        try %{
            exec '<esc>;hm<a-k>..<ret>;'
            set window show_matching_range %val{timestamp} "%val{selection_desc}|MatchingChar"
        } catch %{
            set window show_matching_range 0
        }
        hook window -once InsertChar '[^[\](){}<>]' %{
            set window show_matching_range 0
        }
        hook window -once ModeChange .* %{
            set window show_matching_range 0
        }
        hook window -once InsertMove .* %{
            set window show_matching_range 0
        }
    }
}

add-highlighter global/ ranges show_matching_range
