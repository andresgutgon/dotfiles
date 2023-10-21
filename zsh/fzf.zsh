export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'
export FZF_DEFAULT_OPTS='--reverse --border --ansi --preview "bat --color=always --line-range :500 {}"'

# Use Ctrl+R to search command history
bindkey '^R' fzf-history-widget

# Use Alt+C to search for directories and CD into them
bindkey '^[c' fzf-cd-widget
