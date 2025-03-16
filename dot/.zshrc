# ~/.zshrc file for zsh interactive shells.
# see /usr/share/doc/zsh/examples/zshrc for examples

# --- Main configuration ---
setopt autocd              # change directory just by typing its name
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments
setopt nonomatch           # hide error message for pattern mismatch
setopt notify              # report background job status immediately
setopt numericglobsort     # sort filenames numerically
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider slashes part of words

# --- History config ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
# --- complete history ---
alias history="history 0"


# --- Key bindings ---
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # history expansion on space
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo

# --- Completion ---
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# --- set a fancy prompt (non-color, unless we know we "want" color) ---
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes ;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi


if [ "$color_prompt" = yes ]; then
  # --- Prompt Configuration ---
  # Define ANSI color codes using tput
  reset_color="$(tput sgr0)"
  red="$(tput setaf 160)"
 
  bg_color='%{%K{#740000}%}'
  fg_color='%{%F{#ced4da}%}'
  #end_color='%{%f%k%}%{%K{#2d2d2d}%}'
  end_color='%{%f%k%}'


  # Initialize prompt style
  PROMPT_STYLE=detailed

  # IP detection logic
  get_ipaddr() {
      local interfaces=("tun0" "tap0" "eth0" "wlan0" "wlan1")
      for iface in "${interfaces[@]}"; do
          if ip link show "$iface" &>/dev/null; then
              local ipaddr=$(ip -4 addr show "$iface" 2>/dev/null | grep -Po 'inet \K\d{1,3}(\.\d{1,3}){3}' | head -n1)
              [[ -n $ipaddr ]] && { echo $ipaddr; return }
          fi
      done
      echo "offline"
  }

  update_prompt() {
      case $PROMPT_STYLE in
          detailed)
              local ipaddr=$(get_ipaddr)
              PROMPT="${bg_color}${fg_color}[ %nX$ipaddr %~ ]\$${end_color} "
              ;;
          ipdir)
              local ipaddr=$(get_ipaddr)
              PROMPT="${bg_color}${fg_color}[ $ipaddr %~ ]\$${end_color} "
              ;;
          dir)
              PROMPT="${bg_color}${fg_color}[ %~ ]\$${end_color} "
              ;;
          minimal)
              PROMPT="${bg_color}${fg_color}\$${end_color} "
              ;;
      esac
  }

  # Toggle prompt styles
  toggle_prompt() {
      case $PROMPT_STYLE in
          detailed) PROMPT_STYLE=ipdir ;;
          ipdir) PROMPT_STYLE=dir ;;
          dir) PROMPT_STYLE=minimal ;;
          *) PROMPT_STYLE=detailed ;;
      esac
      update_prompt
      zle reset-prompt
  }
  
  zle -N toggle_prompt
  bindkey '^P' toggle_prompt

  # Toggle prompt styles in reverse order
  toggle_prompt_reverse() {
      case $PROMPT_STYLE in
          dir) PROMPT_STYLE=ipdir ;;
          ipdir) PROMPT_STYLE=detailed ;;
          detailed) PROMPT_STYLE=minimal ;;
          *) PROMPT_STYLE=dir ;; # Fallback to `dir` if PROMPT_STYLE is not set
      esac
      update_prompt
      zle reset-prompt
  }
  zle -N toggle_prompt_reverse
  bindkey '^[^P' toggle_prompt_reverse

  # --- Transient Prompt ---
  zle-line-init() {
      emulate -L zsh
      [[ $CONTEXT == start ]] || return 0

      local ret
      while true; do
          zle .recursive-edit
          ret=$?
          [[ $ret == 0 && $KEYS == $'\4' ]] || break
          [[ -o ignore_eof ]] || exit 0
      done

      local saved_prompt=$PROMPT
      PROMPT='${bg_color}${fg_color}\$${end_color} '
      zle .reset-prompt
      PROMPT=$saved_prompt

      (( ret )) && zle .send-break || zle .accept-line
      return ret
  }
  zle -N zle-line-init

  # --- Final setup ---
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd update_prompt

    # --- Syntax-highlighting ---
    # options fg,bg,underline,bold
    # see more at https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting
    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern line regexp)
        ZSH_HIGHLIGHT_STYLES[default]=none
        ZSH_HIGHLIGHT_STYLES[line]=bold,standout
        ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,underline
        ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan
        ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green
        ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue
        ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[path]=bold,underline,fg=yellow
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue
        ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue
        ZSH_HIGHLIGHT_STYLES[command-substitution]=none
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[process-substitution]=none
        ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[assign]=none
        ZSH_HIGHLIGHT_STYLES[redirection]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[comment]=fg=black
        ZSH_HIGHLIGHT_STYLES[named-fd]=none
        ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
        ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
        ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red
        ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue
        ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green
        ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan
        ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
        ZSH_HIGHLIGHT_STYLES[alias]=fg=magenta
        ZSH_HIGHLIGHT_REGEXP+=('rm' bg=#c60505,fg=yellow,bold)
        ZSH_HIGHLIGHT_REGEXP+=('sudo' bg=#c60505,fg=yellow,bold)
        ZSH_HIGHLIGHT_REGEXP+=('sudo\s+rm\s+(-[rf]+)?|rm\s+-[rf]+' bg=#c60505,fg=yellow,bold)
  fi

# ---
fi
# --- Auto suggestions ---
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi


# --- LS colors ---
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto --unified=0'
    alias ip='ip --color=auto'
    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# --- command-not-found ---
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi


# --- Aliases ---
alias ls='lsd --icon never --group-directories-first'
alias ll='ls -lh'
alias lv='\ls -v1 '
alias la='ls -a1'
alias l='ls -1'
alias lt='ls -1t'
alias lla='ls -lha'
alias lra='ls -lRa'

alias igrep='grep -i'
alias rm='rm -Iv'
alias ffetch='fastfetch --logo none --color red'
alias cat='batcat --paging=never --style=plain'
alias trans='trans --brief'
alias ris="ristretto"
alias kp="kolourpaint"
alias torwho="whois -h torwhois.com"
alias cls="clear"
alias img="w3m -o ext_image_viewer=0"
alias bspwmrc=". ~/.config/bspwm/bspwmrc"
alias virtualbox="virtualbox -style fusion %U"
alias less="batcat -p --color=always"
alias cal="ncal -C"
alias acs="apt-cache search"
alias del="/bin/rm -rfv"
alias which="which -a"
alias yp3="youtube-dl -x --audio-format mp3 --audio-quality 128K  --output '%(title)s.%(ext)s'"
alias yp4="youtube-dl --format mp4  --output '%(title)s.%(ext)s'"
alias ydl="youtube-dl"
alias python='python -W "ignore"'
alias smbmap='smbmap --no-banner'
alias verse="verse | tr -s ' '| tr -d '\n' | sed 's/^ //'"

# --- functions ---

function zat(){
    zathura $1 >/dev/null 2>&1 &; disown
}

function java11(){
    echo "switching to java 11..."
    sudo update-java-alternatives -s java-1.11.0-openjdk-amd64
    export PATH=$PATH:$JAVA_HOME
    java --version

}

function java17(){
    echo "switching to java 17..."
    sudo update-java-alternatives -s java-1.17.0-openjdk-amd64
    export PATH=$PATH:$JAVA_HOME
    java --version
}

function w32(){
    export WINEARCH=win32
    export WINEPREFIX=~/.wine32

}

function w64(){
    export WINEARCH=win64
    export WINEPREFIX=~/.wine
}

function wttr(){
    curl wttr.in
}

function mkt(){
    if [ -z "$1" ]
    then
        echo "Provide a Folder name\nusage: mkt <foldername>"
    else
        echo "\n[ Creating folder $1 @ $PWD ]\n"
        mkdir -p $1/{content,enum,xploit}
        cd $1
        ls -lha
    fi
}

function xps(){
    if [ -z "$1" ]
    then
        echo "Provide a file\nusage: xps <filename>"
    else
        ip_Oaddress=$( grep --color=never -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' $1 | sort -u  )
        ports_Ofile=$( grep --color=never -oP '\d{1,5}/open' $1 | awk '{print $1}' FS="/" | xargs | tr " " "," )
        echo -e "${graycolor}[${greencolor}+${graycolor}]${endcolor} command copied to clipboard, run:\nsudo nmap -sVC -p$ports_Ofile --min-rate=5000 -n -Pn $ip_Oaddress -oN targeted"
        echo -e "sudo nmap -sVC -p$ports_Ofile --min-rate=5000 -n -Pn $ip_Oaddress -oN targeted" | tr -d '\n' | xclip -sel clip
    fi
}

function mac(){
    find /sys/class/net -mindepth 1 -maxdepth 1 ! -name lo -printf "%P: " -execdir cat {}/address \; \
        | sort -n -r \
        | awk '{printf "\033[01;32m%s\033[0m - \033[01;31m%s\033[0m\n",$1,$2 }'
}

function macc(){
    sudo ifconfig $1 down
    sudo macchanger -A $1
    sudo ifconfig $1 up
}

function wow(){
    sudo ifconfig wlan0 down
    sudo macchanger -m 14:3e:60:32:1d:21 wlan0
    sudo ifconfig wlan0 up
}

function rmk() {
    for item in "$@"; do
        if [[ -d "$item" ]]; then
            # If the item is a directory, remove it and all its contents securely
            find "$item" -type f -exec scrub -p dod {} \; -exec shred -zvun 9 -v {} \;
            find "$item" -depth -type d -exec rmdir {} \;
            if [[ $? -eq 0 ]]; then
                echo "Directory $item and its contents have been securely removed."
            else
                echo "Failed to remove directory $item or some of its contents."
            fi
        elif [[ -f "$item" ]]; then
            # If the item is a file, use the existing method
            scrub -p dod "$item"
            shred -zvun 9 -v "$item"
        else
            echo "Item $item does not exist or is neither a file nor a directory."
        fi
    done
}

function afu()
{
    sudo apt update -y
    export DEBIAN_FRONTEND=noninteractive
    sudo -E apt-get -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" dist-upgrade -q -y --allow-downgrades --allow-remove-essential --allow-change-held-packages
}

get_resolution() {
    xrandr | grep '*' | awk '{print $1}'
}

function lock_screen() {
    local resolution=$(get_resolution)
    convert ~/.config/i3lock/stop.png -gravity center -background black -extent "$resolution" ~/.config/i3lock/centered_stop.png
    i3lock -c 000000 -i ~/.config/i3lock/centered_stop.png
}

# exports
export PATH=$PATH:$HOME:/opt/bin:$HOME/.local/bin:/usr/bin/ruby3.0:$HOME/.go/bin:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.rvm/bin
export DEBIAN_FRONTEND=noninteractive
export GOPATH=$HOME/.go
export GEM_HOME="$HOME/.gems"
export PATH="$HOME/.gems/bin:$PATH"
export _JAVA_AWT_WM_NONREPARENTING=1
export TERM=xterm-256color
