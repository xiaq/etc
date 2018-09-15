if (eq $E:ELVISH_PATH "") {
    E:ELVISH_PATH = 1
    paths = [
      ~/.node/bin
      ~/Library/Python/*/bin
      ~/.cargo/bin
      ~/bin
      $@paths
    ]
      # ~/on/*[nomatch-ok]/bin
}

# Convenience functions
fn c { clear; tmux clear }
fn ls [@a]{ e:ls -G $@a }
fn sed-i [@a]{ sed -i '' -e $@a }
fn all-go {
    # List all Go sources recursively. This uses "go list" and excludes all
    # vendor sources.
    put (go list -f '{{.Dir}}' ./...)/*.go
}

# Editor configuration
# edit:abbr['xx '] = '> /dev/null '
# edit:location:pinned = [~ ~/go/src/github.com/elves/elvish]
edit:max-height = 30
# edit:location:workspaces = [&elvish=~/go/src/github.com/elves/elvish]

# edit:-prompt-max-wait = 0.02
edit:insert:binding[Alt-Left]  = $edit:insert:binding[Alt-b]
edit:insert:binding[Alt-Right] = $edit:insert:binding[Alt-f]

# Plugins
#use github.com/xiaq/edit.elv/compl/go; go:apply
#use github.com/xiaq/edit.elv/smart-matcher; smart-matcher:apply

# Imports
use epm
use re

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
