#!/bin/bash
set -euC

echo "Setting up proper autocompletion and incremental history search"
cat << EOL >> /etc/inputrc
# Up/down arrows to search history
"\e[A": history-search-backward
"\e[B": history-search-forward

set completion-ignore-case on

# Make sure we don't output everything on the 1 line
set horizontal-scroll-mode Off

# none, visible or audible
set bell-style visible

set visible-stats off
set mark-directories on

set show-all-if-ambiguous on
EOL

echo "Modifying command prompt"
cat << EOL >> /etc/bash.bashrc
# ignore duplicates
export HISTCONTROL=ignoreboth:erasedups

# unlimited bash history
export HISTFILESIZE=
export HISTSIZE=
EOL

echo "Done setting up bash"
