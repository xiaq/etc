# deploy: .elvish/rc.elv

# Imports
use epm
use re
use platform

if (eq $E:ELVISH_PATH "") {
    set E:ELVISH_PATH = 1
    set paths = [
      ~/.opam/default/bin
      ~/on/rakudo-star-*[nomatch-ok]/install/{bin,share/perl6/site/bin}
      ~/.racket/*[nomatch-ok]/bin
      ~/.npm-global/bin
      ~/Library/Python/*[nomatch-ok]/bin
      ~/.cargo/bin
      ~/.local/bin
      ~/bin
      ~/go/bin
      /opt/homebrew/bin
      /opt/homebrew/sbin
      /opt/homebrew/opt/ruby/bin
      $@paths
    ]
      # ~/on/*[nomatch-ok]/bin
}

# Convenience functions
fn c { clear; tmux clear }
fn ls {|@a| e:ls [&darwin=-G &linux=--color=auto][$platform:os] $@a }
fn sed-i {|@a| sed -i '' -e $@a }
fn all-go {
    # List all Go sources recursively. This uses "go list" and excludes all
    # vendor sources.
    put (go list -f '{{.Dir}}' ./...)/*.go
}
fn v {|@a| vim $@a }
fn vrc { vim ~/.elvish/rc.elv }

# Editor configuration
# edit:abbr['xx '] = '> /dev/null '
# edit:location:pinned = [~ ~/go/src/github.com/elves/elvish]
set edit:abbr = [
  &'>!'= '> /dev/null'
  &'||'= '| less'
  &//ul= /usr/local]
set edit:max-height = 30
# edit:location:workspaces = [&elvish=~/go/src/github.com/elves/elvish]

# edit:-prompt-max-wait = 0.02
set edit:insert:binding[Alt-Left]  = $edit:insert:binding[Alt-b]
set edit:insert:binding[Alt-Right] = $edit:insert:binding[Alt-f]
# edit:insert:binding[Alt-Up] = { cd .. }

# Plugins
#use github.com/xiaq/edit.elv/compl/go; go:apply
#use github.com/xiaq/edit.elv/smart-matcher; smart-matcher:apply

#use github.com/muesli/elvish-libs/theme/powerline
#powerline:glyph[chain] = ' '
#powerline:glyph[dirchain] = '/'
#powerline:prompt-pwd-dir-length = 0
#powerline:prompt-segments = [
#    dir virtualenv
#    git-branch git-ahead git-behind git-staged git-dirty git-untracked
#    newline arrow
#]
#powerline:rprompt-segments = [
#    user host
#]
#powerline:setup

# use github.com/xiaq/edit.elv/compl/git; git:apply

fn loc { grep . | grep -v '^\s*#' | wc -l }

fn demo {
  set edit:rprompt = (constantly (styled 'elf@host' inverse))
  var header = '<!-- Follow website/ttyshot/README.md to regenerate -->'
  var ttyshot = { print $header(edit:-dump-buf) > ~/ttyshot.html }
  set edit:global-binding[Alt-x] = $ttyshot
}

set E:EDITOR = kak

use kak
var kak~ = $kak:kak~

set E:OPAM_SWITCH_PREFIX = ~/.opam/default
set E:CAML_LD_LIBRARY_PATH = ~/'.opam/default/lib/stublibs:Updated by package ocaml'
set E:OCAML_TOPLEVEL_PATH = ~/.opam/default/lib/toplevel
set E:MANPATH = :{~/home/xiaq/.opam/default/man}

# echo pid $pid
#use github.com/zzamboni/elvish-modules/alias
#alias:new foo echo bar

# Synchronize $pwd of other panes
fn spwd {
  tmux list-panes -F '#{pane_id}' | each {|id|
    if (not-eq $id $E:TMUX_PANE) {
      tmux send-keys -t $id ':cd '$pwd Enter
    }
  }
}

set E:LSCOLORS = Gxfxcxdxbxegedabagacad

use github.com/zzamboni/elvish-modules/iterm2
iterm2:init
