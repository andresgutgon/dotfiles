# Global aliases

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
alias docker-restart='f() { docker compose stop "$1" && docker compose up "$1" -d; }; f'
alias docker-rebuild='f() { docker compose stop "$1" && docker compose build "$1" && docker compose up "$1" -d; }; f'

alias docker-ps='f() { docker ps | awk '\''{print $1, $(NF)}'\'' | grep "$1" | awk '\''{print $1}'\'' |  tail -n 1; }; f'

alias docker-attach='f() { docker attach $(docker-ps "$1"); }; f'
alias docker-bash='f() { docker exec -it $(docker-ps "$1") /bin/bash; }; f'

alias docker-restart-attach='f() { docker-restart "$1" && docker-attach "$1"; }; f'
alias docker-rebuild-attach='f() { docker-rebuild "$1" && docker-attach "$1"; }; f'

alias docker-restart-bash='f() { docker-restart "$1" && docker-bash "$1"; }; f'
alias docker-rebuild-bash='f() { docker-rebuild "$1" && docker-bash "$1"; }; f'

alias docker-kill-all='docker kill $(docker ps -q)'

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
