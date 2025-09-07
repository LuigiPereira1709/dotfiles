# Export the environment variables
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"
# ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  zsh-autocomplete
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Init Variables
eval "$(zoxide init zsh)" # zoxide

## ALIAS ##
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'

# Remove
alias rm='echo "Removing" && rm'
alias srm='echo "Removing" && sudo rm'
alias rmr='echo "Removing Recursively" && rm -rf'
alias srmr='echo "Removing Recursively" && sudo rm -rf'

# Gradle
alias ewbutt='echo "TIME TO CLEAN OUR BUTT, CLEANING THE MESS..." && ./gradlew clean build -x test' # clean our butt and getting up
alias ewpls='echo "GUESS HOW MANY ERRORS WILL APPEAR" && ./gradlew clean test --tests' # please, don't appear to many errors
alias ewbath='echo "BATH TIME, THIS SHIT STINKS" && ./gradlew build --refresh-dependencies -x test' # uh, i'm refreshed
alias ewgo='echo "YOU HAVE COURAGE BROH, FOR RUNNING THIS BOMB. GOOD LUCK!" && ./gradlew bootRun' # running like there's no tomorrow
alias ewgod='echo "OH, ARE YOU A DEV? I AM A DEV TOO, WHICH IS YOUR FAVORITE LANGUAGE?" && ./gradlew bootRunDev' # running in my world

# Docker
alias dps='docker ps'

# Docker-Compose
alias dcu='docker-compose up -d'
alias dcd='docker-compose down -v'
alias dcl='docker-compose logs -f'

## ALIAS ##


video2gif() {
  ffmpeg -y -i "${1}" -vf fps=${3:-10},scale=${2:-320}:-1:flags=lanczos,palettegen "${1}.png"
  ffmpeg -i "${1}" -i "${1}.png" -filter_complex "fps=${3:-10},scale=${2:-320}:-1:flags=lanczos[x];[x][1:v]paletteuse" "${1}".gif
  rm "${1}.png"
}


## functions ##
AWS_CMD=$(command -v aws)
# aws cli
miniou(){
  local file=""
  local bucket=""
  local bucket_key=""
  local recursive=false
  local port="9000"

  local help=false

  while getopts "f:b:k:rr:h" opt; do
    case "$opt" in
      f) file="$OPTARG" ;;
      b) bucket_key="$OPTARG" ;;
      p) path="$OPTARG" ;;
      h) help=true ;;
      r) recursive=true ;;
    esac
  done

  if [[ "$help" == true ]] then
    echo -e "
    AWS S3 CLI  wrapper for MinIO

    How to use:
      miniou -f <file|dir> -b <bucket> -k <bucket-key> [options: -r <Recursively>]
    " 
    return 0
  fi

  if [[ -z "$file" || -z "$bucket" || -z "$path" ]]; then
    echo "error: missing mandatory args"
    echo "use: miniou -f <file> -b <bucket> -k <bucket-key>"
    return 1
  fi

  local cmd="${AWS_CMD} --endpoint-url http://localhost:${port} s3 cp \"$file\" \"s3://${bucket}/${bucket_key}\""

  if [[ "$recursive" == true ]] then
    echo "inside of recursive conditional"
    cmd="${cmd} --recursive"
  fi

  eval $cmd
}
## functions ##


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Created by `pipx` on 2025-01-16 04:25:56
export PATH="$PATH:/home/luigi/.local/bin"
