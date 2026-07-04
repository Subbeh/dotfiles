#!/bin/sh

if [ -d "$WORKSPACE_DIR/dotfiles" ]; then
  DOT_DIR="$WORKSPACE_DIR/dotfiles"
fi
export DOT_DIR

alias cd.="cd \${DOT_DIR:?not set}"
alias ds='mate status'
alias ddiff='mate diff'
alias da='mate apply'
alias dad='mate apply --dry-run -v'
alias de='mate edit'
alias ddoc='mate doctor'

# dsupdate() {
#   chezmoi execute-template <"$(chezmoi source-path)/.chezmoiscripts/run_onchange_before_01-fetch-secrets.sh.tmpl" | bash
# }
