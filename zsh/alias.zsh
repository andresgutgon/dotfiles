# Global aliases

alias -g ls="ls --color=always"
alias -g ll="ls -lA --color=always"
alias -g grep="grep --color=always"
alias -g egrep="egrep --color=always"

# NeoVim
alias neo="nvim"

# Git
alias gp="git pull"
alias gps="git push"
alias gs="git status"
alias ga="git add"
alias gd="git diff"
alias gw="git wip"

# Latitude compose
alias doc="docker-compose exec backend"
alias guard="docker compose exec backend bin/guard"
alias dor="docker-compose run backend"
alias dspec="doc bundle exec rspec"
alias dof="docker-compose exec frontend"

# Docker alias
alias dkillAll='docker kill $(docker ps -q)'

# Laravel
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'

# Network
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ipl="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

fixssh() {
  for key in SSH_AUTH_SOCK SSH_CONNECTION SSH_CLIENT; do
    if (tmux show-environment | grep "^${key}" > /dev/null); then
      value=`tmux show-environment | grep "^${key}" | sed -e "s/^[A-Z_]*=//"`
      export ${key}="${value}"
    fi
  done
}

