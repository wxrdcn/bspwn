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

    bg_color='%{%K{#5d0606}%}'
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

    # Add to your .zshrc
    setopt prompt_subst

    function shorten_path() {
        local path=${PWD/#$HOME/\~}
        local is_absolute=0
        [[ "$path" == /* ]] && is_absolute=1  # Check if path is absolute
        local elements=("${(@s:/:)path}")
        elements=("${(@)elements:#}")  # Remove empty elements
        local shortened=""

        if [[ "$path" == "~" ]]; then
            echo "~"
            return
        fi

        # Handle home directory (~/...) case
        if [[ "$path" == "~/"* ]]; then
            shortened="~/"
            elements=("${elements[@]:1}")  # Remove '~' from elements
        elif (( is_absolute )); then
            # Only add initial slash for absolute paths
            shortened="/"
        fi

        local num_elements=${#elements[@]}

        # Process all elements except the last one (if any)
        for ((i=1; i < num_elements; i++)); do
            shortened+="${elements[i][1]}/"  # Shorten parent dirs to first char followed by slash
        done

        # Append the full last directory component without an extra slash
        if (( num_elements > 0 )); then
            shortened+="${elements[-1]}"
        fi

        # Handle root directory edge case
        [[ "$shortened" == "/" ]] && echo "/" && return

        echo "${shortened}"
    }

    # Update your update_prompt function
    update_prompt() {
        case $PROMPT_STYLE in
            detailed)
                local ipaddr=$(get_ipaddr)
                PROMPT="${bg_color}${fg_color}[ %nX$ipaddr \$(shorten_path) ]\$${end_color} "
                ;;
            ipdir)
                local ipaddr=$(get_ipaddr)
                PROMPT="${bg_color}${fg_color}[ $ipaddr \$(shorten_path) ]\$${end_color} "
                ;;
            dir)
                PROMPT="${bg_color}${fg_color}[ \$(shorten_path) ]\$${end_color} "
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
        ZSH_HIGHLIGHT_STYLES[path]=bold,underline,fg=blue
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
        ZSH_HIGHLIGHT_REGEXP+=('sudo' bg=#c60505,fg=yellow,bold)
        ZSH_HIGHLIGHT_REGEXP+=('sudo' bg=#c60505,fg=yellow,bold)
        ZSH_HIGHLIGHT_REGEXP+=('rm(\s+-[^\s]+|\s+--[^\s]+)*' bg=#c60505,fg=yellow,bold)
        ZSH_HIGHLIGHT_REGEXP+=('sudo\s+rm(\s+-[^\s]+|\s+--[^\s]+)*' bg=#c60505,fg=yellow,bold)
        ZSH_HIGHLIGHT_REGEXP+=('\$\([^\)]*rm[^\)]*\)|`[^`]*rm[^`]*`' bg=#c60505,fg=yellow,bold)
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
alias l='ls -1v'
alias lt='ls -1t'
alias lla='ls -lha'
alias lra='ls -lRa'

alias igrep='grep -i'
alias grepi='grep -i'
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
alias cal="ncal -bwyM"
alias acs="apt-cache search"
alias del="/bin/rm -rfv"
alias which="which -a"
alias yp3="youtube-dl -x --audio-format mp3 --audio-quality 128K  --output '%(title)s.%(ext)s'"
alias yp4="youtube-dl --format mp4  --output '%(title)s.%(ext)s'"
alias ydl="youtube-dl"
alias python='python -W "ignore"'
alias smbmap='smbmap --no-banner'
alias verse="verse | tr -s ' '| tr -d '' | sed 's/^ //'"
alias target='setg rhost'
alias ctarget='unsetg rhost'
alias hosts='sudoedit /etc/hosts'
alias apt='sudo apt'
alias apt-get='sudo apt-get'
alias btop='sudo btop'
alias htop='sudo htop'
alias top='sudo top'
alias show-options="show_options"
alias rsync="rsync -Phavzc"
alias rhost='setg rhost'
alias rport='setg rport'
alias lhost='setg lhost'
alias lport='setg lport'

# --- functions ---

function clear_all(){
    for i in "lhost" "lport" "rhost" "rport" "ssl" "proto"; do
        unsetg "$i";
    done
}

function smap(){
    sudo nmap -sS -p- --reason -n -Pn --min-rate=5000 --disable-arp-ping --stats-every=5s -oA tcp-all "$1"
}

function umap(){
    sudo nmap -sU -F --reason -n -Pn --min-rate=5000 --disable-arp-ping --stats-every=5s -oA udp-all "$1"
}

function ww() {
    # Declare options as a local array to avoid conflicts with outer scope
    local -a options

    # Check if any arguments were provided
    if [ $# -eq 0 ]; then
        echo "Usage: ww [whatweb options] <URLs>"
        return 1
    fi

    # Get the last argument (the target URL or IP)
    target="${@: -1}"

    # Validate that the target looks like a URL or IP
    if [[ ! "$target" =~ ^(https?://|[a-zA-Z0-9.-]+\.[a-zA-Z]+|[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+) ]]; then
        echo "Error: Last argument doesn't appear to be a valid target"
        echo "Usage: ww [whatweb options] <URLs>"
        return 1
    fi

    # Generate a clean filename from the target
    clean_name=$(echo "$target" | sed -E 's/https?:\/\///g' | sed -E 's/[:\/]/_/g' | sed -E 's/\./_/g')
    base_filename="${clean_name}"

    # Define output filenames for text, XML, and JSON
    txt_file="./${base_filename}.txt"
    xml_file="./${base_filename}.xml"
    json_file="./${base_filename}.json"

    # Gather all arguments except the last one (the target)
    if [ $# -gt 1 ]; then
        options=("${@:1:$#-1}")
    else
        options=()
    fi

    # Display scan details
    echo -e "[+]Scanning $target..."
    echo -e "[+]Options: ${options[*]}"
    echo -e "[+]Results will be saved to:"
    echo -e "
----------------------
    "
    echo -e "	Text:  $txt_file"
    echo -e "	XML:   $xml_file"
    echo -e "	JSON:  $json_file"
    echo -e "
----------------------

    "

    # Run whatweb with the specified options and output formats
    whatweb -v "${options[@]}" --log-xml="$xml_file" --log-json="$json_file" "$target" | tee "$txt_file"

    echo "Scan complete!"
}


# Open PDFs with Zathura (detached from terminal)
function zat() {
    zathura "$@" &!
}

# Open documents with Atril (detached from terminal)
function atril() {
    command atril "$@" &!
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


function mkt() {
    # Combine all arguments into a single folder name
    local fname="${(j: :)@}"

    if [[ -z "$fname" ]]; then
        echo >&2 "Provide a folder name
        usage: mkt <folder name>"
        return 1
    fi

    printf "
[1;34m[ %s/%s ][0m

" "$PWD" "$fname"

    # Create directory structure
    if ! mkdir -p "$fname"/{recon/{nmap/{tcp,udp},tcp,udp},loot,xploit/{bx,px}/{cve,script,payload,misc}} 2>/dev/null; then
        echo >&2 "Error: Failed to create directory structure"
        return 2
    fi

    # Create base files
    if ! touch "$fname"/{log.txt,credentials.txt,summary.md} 2>/dev/null; then
        echo >&2 "Error: Failed to create initial files"
        return 3
    fi

    ls -ld "$fname"

}


function xps(){
    if [ -z "$1" ]
    then
        echo "Provide a file
usage: xps <filename>"
    else
        ip_Oaddress=$( grep --color=never -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' $1 | sort -u  )
        ports_Ofile=$( grep --color=never -oP '\d{1,5}/open' $1 | awk '{print $1}' FS="/" | xargs | tr " " "," )
        command="sudo nmap -sVC -p$ports_Ofile --disable-arp-ping --min-rate=5000 -n -Pn $ip_Oaddress --stats-every=5s -oA targeted"
        echo -e "[+] command copied to clipboard, run:
$command"
        echo -e "$command" | tr -d '
' | xclip -sel clip
    fi
}

function mac(){
    find /sys/class/net -mindepth 1 -maxdepth 1 ! -name lo -printf "%P: " -execdir cat {}/address \; \
        | sort -n -r \
        | awk '{printf "[01;32m%s[0m - [01;31m%s[0m
",$1,$2 }'
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

show_options() {
  local allowed=("lhost" "lport" "rhost" "rport" )
  echo "┌── Current Configuration Options ──"
  for var in "${allowed[@]}"; do
    if [[ -v $var ]]; then
      printf "│ [1;36m%-6s[0m ▸ %s
" "$var" "${(P)var}"
    else
      printf "│ [1;31m%-6s[0m ▸ %s
" "$var" "(not set)"
    fi
  done
  echo "└───────────────────────────────────"
}

setg() {
  if [ $# -ne 2 ]; then
    echo "Usage: setg <variable> <value>"
    return 1
  fi

  # Define allowed variables
  local allowed=("lhost" "lport" "rport" "rhost")
  local var_name="${1:l}"  # Convert input to lowercase instead of uppercase

  # Check if variable is allowed
  if [[ ! " ${allowed[@]} " =~ " ${var_name} " ]]; then
    echo "Error: '${var_name}' is not a configurable variable"
    echo "Allowed variables: ${allowed[@]}"
    return 1
  fi

  # Additional validation for rhost
  if [[ $var_name == "rhost" ]]; then
    if [[ "$2" != "none" ]] && ! [[ "$2" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
      echo "Error: Invalid IP address format for rhost"
      return 1
    fi
  fi

  # Get the actual file path (resolving symlink)
  local zshrc_actual=$(readlink -f ~/.zshrc)

  # Create a temporary file
  local temp_file=$(mktemp)

  # Check if the variable already exists in the file
  local var_exists=0

  # Process the file line by line and update the variable if it exists
  while IFS= read -r line; do
    if [[ "$line" =~ ^export\ ${var_name}= ]]; then
      echo "export ${var_name}=\"$2\"" >> "$temp_file"
      var_exists=1
    else
      echo "$line" >> "$temp_file"
    fi
  done < "$zshrc_actual"

  # If the variable doesn't exist, append it to the end of the file
  if [[ $var_exists -eq 0 ]]; then
    echo "export ${var_name}=\"$2\"" >> "$temp_file"
  fi

  # Replace the original file with the new content
  cat "$temp_file" > "$zshrc_actual"
  rm "$temp_file"

  # Update current session
  export ${var_name}="$2"
  echo "Global variable ${var_name} set to $2"

  # Sync rhost to .current_target
  if [[ $var_name == "rhost" ]]; then
    echo "$2" > ~/.current_target
    echo "Updated ~/.current_target with rhost value"
  fi
}

unsetg() {
  if [ $# -ne 1 ]; then
    echo "Usage: unsetg <variable>"
    return 1
  fi

  # Define allowed variables
  local allowed=("lhost" "lport" "rport" "rhost" "ssl" "proto")
  local var_name="${1:l}"  # Convert input to lowercase 

  # Check if variable is allowed
  if [[ ! " ${allowed[@]} " =~ " ${var_name} " ]]; then
    echo "Error: '${var_name}' is not a configurable variable"
    echo "Allowed variables: ${allowed[@]}"
    return 1
  fi

  # Get the actual file path (resolving symlink)
  local zshrc_actual=$(readlink -f ~/.zshrc)

  # Create a temporary file
  local temp_file=$(mktemp)

  # Process the file line by line, skipping the target variable
  while IFS= read -r line; do
    if [[ ! "$line" =~ ^export\ ${var_name}= ]]; then
      echo "$line" >> "$temp_file"
    fi
  done < "$zshrc_actual"

  # Replace the original file with the new content
  cat "$temp_file" > "$zshrc_actual"
  rm "$temp_file"

  # Unset variable in the current session
  unset "$var_name"
  echo "[+] Removed variable \"${var_name}\""

  # Special handling for rhost: clear .current_target
  if [[ $var_name == "rhost" ]]; then
    echo "no target" > ~/.current_target
    echo "Cleared ~/.current_target"
  fi

  return 0
}

PROMPT_EOL_MARK=''

# exports
export PATH=$PATH:$HOME:/opt/bin:$HOME/.local/bin:/usr/bin/ruby3.0:$HOME/.go/bin:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.rvm/bin
export DEBIAN_FRONTEND=noninteractive
export GOPATH=$HOME/.go
export GEM_HOME="$HOME/.gems"
export PATH="$HOME/.gems/bin:$PATH"
export _JAVA_AWT_WM_NONREPARENTING=1
export TERM=xterm-256color

### capture the flag variables ###
