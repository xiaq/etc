if (eq $E:ELVISH_PATH "") {
    E:ELVISH_PATH = 1
    paths = [
      ~/.node/bin
      ~/Library/Python/*/bin
      ~/.cargo/bin
      ~/on/*[nomatch-ok]/bin
      ~/bin
      $@paths
    ]
}

# Convenience functions
fn c { clear; tmux clear }
fn ls [@a]{ e:ls -G $@a }
fn all-go {
    # List all Go sources recursively. This uses "go list" and excludes all
    # vendor sources.
    put (go list -f '{{.Dir}}' ./...)/*.go
}

# Editor configuration
edit:abbr['xx '] = '> /dev/null '
edit:loc-pinned = [~ ~/go/src/github.com/elves/elvish]
edit:max-height = 30
edit:-prompts-max-wait = 0.02

# Plugins
use github.com/xiaq/edit.elv/compl/go; go:apply
use github.com/xiaq/edit.elv/smart-matcher; smart-matcher:apply

# Imports
use epm
use re
