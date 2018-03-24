# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
SAVEHIST=10000
HISTSIZE=10000
export GOPATH=/opt/go
export PYTHONSTARTUP=~/.pyrc
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
autoload -Uz compinit
autoload -U zcalc
autoload -U select-word-style
select-word-style bash

compinit

if [ `stat -c %i /` != "2" ]
then
  INCHROOT=1
fi

fpath=(~/bin/zsh-completions/src $fpath)
maven_plugins=(
         'jboss'
         'tomcat'
         'gwt:Maven plugin for the Google Web Toolkit'
         'android:Maven Plugin for Android'
       )
zstyle ':completion:*:mvn:*' plugins $maven_plugins
zstyle ':completion:*' menu select

zstyle :compinstall filename '$HOME/.zshrc'
zstyle ':completion:*:kill:*' menu yes select interactive
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:processes' command 'ps -U $USER -H'
zstyle ':completion:*' rehash true

if [[ "$TERM" == "rxvt-unicode" ]]
then
bindkey '^?' backward-delete-char
bindkey '^[[7~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[8~' end-of-line
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char 
bindkey '^[[2~' overwrite-mode
elif [[ "$TERM" != emacs ]]; then
[[ -z "$terminfo[kdch1]" ]] || bindkey -M emacs "$terminfo[kdch1]" delete-char
[[ -z "$terminfo[khome]" ]] || bindkey -M emacs "$terminfo[khome]" beginning-of-line
[[ -z "$terminfo[kend]" ]] || bindkey -M emacs "$terminfo[kend]" end-of-line
[[ -z "$terminfo[kdch1]" ]] || bindkey -M vicmd "$terminfo[kdch1]" vi-delete-char
[[ -z "$terminfo[khome]" ]] || bindkey -M vicmd "$terminfo[khome]" vi-beginning-of-line
[[ -z "$terminfo[kend]" ]] || bindkey -M vicmd "$terminfo[kend]" vi-end-of-line

[[ -z "$terminfo[cuu1]" ]] || bindkey -M viins "$terminfo[cuu1]" vi-up-line-or-history
[[ -z "$terminfo[cuf1]" ]] || bindkey -M viins "$terminfo[cuf1]" vi-forward-char
[[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins "$terminfo[kcuu1]" vi-up-line-or-history
[[ -z "$terminfo[kcud1]" ]] || bindkey -M viins "$terminfo[kcud1]" vi-down-line-or-history
[[ -z "$terminfo[kcuf1]" ]] || bindkey -M viins "$terminfo[kcuf1]" vi-forward-char
[[ -z "$terminfo[kcub1]" ]] || bindkey -M viins "$terminfo[kcub1]" vi-backward-char

bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
fi

if [[ "$TERM" == screen ]]
then
    bindkey "^[[7~" beginning-of-line
    bindkey "^[[8~" end-of-line
fi

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                             /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _ignored _correct _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**'
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' prompt '%e'
zstyle ':completion:*' substitute 1

local _myhosts;
_myhosts=( ${${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ }:#\!*}
${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*} );
zstyle ':completion:*' hosts $_myhosts;

#bindkey "^[[2~" yank
#bindkey "^[[3~" delete-char
#bindkey "^[[5~" up-line-or-history
#bindkey "^[[6~" down-line-or-history
#bindkey "^[[7~" beginning-of-line
#bindkey "^[[8~" end-of-line
#bindkey "^[e" expand-cmd-path ## C-e for expanding path of typed command
#bindkey "^[[A" up-line-or-search ## up arrow for back-history-search
#bindkey "^[[B" down-line-or-search ## down arrow for fwd-history-search
#bindkey " " magic-space ## do history expansion on space

# End of lines added by compinstall
#TERM=xterm-256color
parse_git_branch () {
    git branch 2> /dev/null | grep "*" | sed -e "s/* \(.*\)/%B%F{green}%K{black}[\1]%k%f%b:/g"
}

function check_swh() {
  if [ -n "$SWH" ]
  then
    echo "%F{red}%K{black}%%%%%k%f"
  else
    echo "%%"
  fi
}

function check_chroot() {
  if [ -n "$INCHROOT" ]
  then
    echo "%F{green}%K{blue}%M/chroot%k%f"
  else
    echo "%M"
  fi
}

function precmd() {
    PROMPT="%B$(check_swh)[$(check_chroot)]%b%(1j.:[j:%j].):$(parse_git_branch)[%~]%(!.# .> )"
}
function phold() {
    echo "$1 hold" | dpkg --set-selections
}
function punhold() {
    echo "$1 install" | dpkg --set-selections
}
function swh() {
    env HOME=/media/usb$1/home SWH=1 zsh
}
RPROMPT='[%* %D]'
PATH=$PATH:~/bin/maven/bin
alias gq=geeqie
alias mr=mirage
alias dp='dd if=/dev/random ibs=1 count=1 >> '
alias c='zless -niR'
#alias p='ps aux | grep -v grep | grep -ai '
p() { ps -Fwwp `pgrep -fd, $1` 2>/dev/null }
alias sm='/usr/bin/smplayer'
alias sr='tmux attach'
alias tcnon="export LD_PRELOAD=~/.tconn/tconn.so"
alias tcnoff="unset LD_PRELOAD"
alias ls='ls --color'
alias lr='ls -lahrt'
alias l='ls -lah'
alias md='mkdir -p'
alias lss='ls -lahrS'
alias fn='find -iname '
alias agi='apt install'
alias agr='apt remove'
alias agp='apt purge'
alias agu='apt update'
alias agup='apt dist-upgrade'
alias agar='apt autoremove'
alias ags='apt source'
alias agbd='apt build-dep'
alias acsh='apt show'
alias acs='apt search'
alias acd='apt depends'
alias acrd='apt rdepends'
alias afs='apt-file search'
alias afl='apt-file list'
alias afu='apt-file update'
alias acp='apt policy'
alias dbp='dpkg-buildpackage'
alias df='df -h'
alias mp='ionice -n 0 mpv'
alias mp5.1='ionice -n 0 mpv -af pan=2:.32:.32:.39:.06:.06:.39:.17:-.17:-.17:.17:.33:.33'
alias vcs16='vcs -c 4 -n 16 -H 200 --anonymous -O quality=50 -j'
alias vcs25='vcs -c 5 -n 25 -H 200 --anonymous -O quality=50 -j'
alias cp='ionice -c 3 cp -i'
alias mv='ionice -c 3 mv -i'
alias akd='apt-key adv --keyserver keyserver.ubuntu.com --recv-keys'
alias winzip='unzip -x -O CP866'
alias chmodfix='chmod -R u=rwX,g=rX,o=rX'
alias unpck='atool -ex'
alias rsync='rsync -Pr'
alias joinimg='montage -tile 1 -geometry +0+0 -quality 85'

if [ `id -u` = "0" ]
then
    alias sc='systemctl'
else
    alias sc='systemctl --user'
fi

function akw() {
  wget -O- "$1" | apt-key add -
}

function javadbg() {
    PORT=$1
    shift
    java -Xdebug -agentlib:jdwp=transport=dt_socket,address=$PORT,server=y,suspend=y "$@"
}

function mpdvd() {
    mp "dvdnav://menu/`readlink -f "$1"`"
}

function chrootmnt() {
    mount --bind /dev "$1/dev"
    mount --bind /dev/pts "$1/dev/pts"
    mount --bind /sys "$1/sys"
    mount --bind /proc "$1/proc"
    chroot "$@"
    umount "$1/proc"
    umount "$1/sys"
    umount "$1/dev/pts"
    umount "$1/dev"
}

function nvupd() {
    "$1" --no-kernel-module --no-x-check -s
}

function getdeps() {
    ldd "$1" | grep "not found" | sed -n 's#\t\(\S*\) =>.*#\1#p' | sort -u
}

function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip

alias -g H="| head"
alias -g T="| tail"
alias -g G="| grep -a"
alias -g L="| less"
alias -g M="| most"
alias -g W="| wc -l"
alias -g B="&|"
alias -g HL="--help"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"

alias ns='netstat -anp G '

alias -s {gif,jpg,png,jpeg,tif,tiff,JPG,PNG,GIF,JPEG,TIF,TIFF}='geeqie'
alias -s {avi,mpg,wmv,3gp,mov,mkv,flv,mp4}='mp'
alias -s {pdf,djvu,ps}='epdfview'

_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1	# Because we didn't really complete anything
}

setopt autocd notify caseglob extendedglob histignorealldups incappendhistory sharehistory histignorespace
unsetopt beep nomatch recexact hup

if [ -e /usr/share/autojump/autojump.zsh ]
then
  . /usr/share/autojump/autojump.zsh
fi
export BC_ENV_ARGS=~/.bcrc
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.opengl=true"
export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit
export WINEDLLOVERRIDES=winemenubuilder.exe=d

if [ -e ~/.zshrc.local ]
then
  . ~/.zshrc.local
fi

