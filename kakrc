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
map global normal <#> "|par T4 ${kak_opt_autowrap_column}<ret>"
# My tmux config uses Alt-K, so use Ctrl-K instead
map global normal <c-k> <a-k>
map global normal <c-s-k> <a-s-k>

# Aliases and Custom Commands
# ===========================
alias global h doc
alias global s source

eval %sh{kak-lsp --kakoune -s $kak_session}
#set global lsp_cmd "kak-lsp -s %val{session} -vvv --log /tmp/kak-lsp.log"

define-command -params 0..1 -file-completion split %{ nop %sh{
    tmux split
    if test -z "$1"; then
        first_line=`echo $kak_window_range | awk '{ print $1 + 1 }'`
        command="exec ${first_line}gvt; select $kak_selections_desc"
    fi
    tmux send-keys "kak -c $kak_session ${1:-$kak_buffile} -e '$command'" Enter
}}
define-command -params 0..1 -file-completion vsplit %{ nop %sh{
    tmux split -h
    if test -z "$1"; then
        first_line=`echo $kak_window_range | awk '{ print $1 + 1 }'`
        command="exec ${first_line}gvt; select $kak_selections_desc"
    fi
    tmux send-keys "kak -c $kak_session ${1:-$kak_buffile} -e '$command'" Enter
}}

alias global sp split
alias global vsp vsplit

alias global ren lsp-rename-prompt

# Plugins
# =======

source "%val{config}/plugins/plug.kak/rc/plug.kak"

plug "andreyorst/plug.kak" noload
plug "chriswalker/golang.kak"
plug "https://gitlab.com/Screwtapello/kakoune-state-save.git"
plug "https://bitbucket.org/KJ_Duncan/kakoune-racket.kak.git"
plug "https://gitlab.com/notramo/elvish.kak.git"
plug "andreyorst/powerline.kak" config %{
    powerline-start
} defer powerline %{
    set-option global powerline_separator ""
    set-option global powerline_format "line_column position filetype session bufname"
}

# Hooks
# ====

hook global WinSetOption filetype=(go|typescript|c|cpp|ocaml) %{
    lsp-enable-window
}

hook global WinSetOption filetype=go %{
    hook window BufWritePost .* %{ go-format -use-goimports }
    # Override the key to format comments.
    map window normal <#> "|par T4 Q+/ q ${kak_opt_autowrap_column}<ret>"
    define-command gorename %{
        prompt "new name:" %{ nop %sh{
            gorename -offset "$kak_buffile:#$kak_cursor_byte_offset" -to "$kak_text"
            notify-send 'gorename done' || true
        } }
    }
}

hook global WinSetOption filetype=(elvish|yaml|racket|typescript|html) %{
	set window tabstop 2
	set window indentwidth 2
}

hook global WinSetOption filetype=markdown %{
    # Override the key.
    map window normal <#> "|prettier --stdin --parser markdown --tab-width 4 --prose-wrap always<ret>"

    hook window InsertKey <tab> %{ execute-keys -draft h@ }
    autowrap-enable
    # Override the default version of the command, which copies list item
    # prefixes.
    define-command -hidden -override markdown-indent-on-new-line %{
        # preserve previous line indent
        try %{ execute-keys -draft <semicolon> K <a-&> }
        # copy block quote(s), list item prefix and following white spaces
        try %{ execute-keys -draft k <a-x> s ^\h*\K((>\h*)+([*+-]\h)?|(>\h*)*[*+-]\h)\h* <ret> y gh j P x s [*+-] <ret> r <space> }
        # remove trailing white spaces
        try %{ execute-keys -draft -itersel %{ k<a-x> s \h+$ <ret> d } }
    }
    # Override the default version of the command to run with hooks.
    define-command -hidden -override autowrap-cursor %{ evaluate-commands -save-regs '/"|^@m' %{
        try %{
            ## if the line isn't too long, do nothing
            execute-keys -draft "<a-x><a-k>^[^\n]{%opt{autowrap_column},}[^\n]<ret>"

            try %{
                reg m "%val{selections_desc}"

                ## if we're adding characters past the limit, just wrap them around
                execute-keys -draft -with-hooks "<a-h><a-k>.{%opt{autowrap_column}}\h*[^\s]*<ret>1s(\h+)[^\h]*\z<ret>c<ret>"
            } catch %{
                ## if we're adding characters in the middle of a sentence, use
                ## the `fmtcmd` command to wrap the entire paragraph
                evaluate-commands %sh{
                    if [ "${kak_opt_autowrap_format_paragraph}" = true ] \
                        && [ -n "${kak_opt_autowrap_fmtcmd}" ]; then
                        format_cmd=$(printf %s "${kak_opt_autowrap_fmtcmd}" \
                                     | sed "s/%c/${kak_opt_autowrap_column}/g")
                        printf %s "
                            evaluate-commands -draft %{
                                execute-keys '<a-]>p<a-x><a-j>|${format_cmd}<ret>'
                                try %{ execute-keys s\h+$<ret> d }
                            }
                            select '${kak_main_reg_m}'
                        "
                    fi
                }
            }
        }
    } }
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
