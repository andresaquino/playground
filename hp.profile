#!/bin/sh 
# vim: set ts=2 et sw=2 sts=2 si ai:

# hp.profile
# --
# (c) 2010 Hewlett-Packard Company
# Andres Aquino <aquino@hp.com>
#

# This is the user profile enviroment file for GNU/Linux.
# See bash_rc or bash_profile for more information.

# input mode
set -o vi
umask 0007

# otros
export HOSTNAME=`hostname`
export MYHOST=`hostname | sed -e "s/\..*//g"`
MYHOST=`hostname | sed -e "s/\..*//g"`
export TTYTYPE="TERM"

# terminal line settings
stty 2> /dev/null > /dev/null 
if [ "$?" = "0" ]
then
  stty erase "^?"
  stty intr "^C" 
  stty kill "^U" 
  stty stop "^S"
  stty susp "^Z"
  stty werase "^W"

  # command line _eye candy_
   TTYTYPE="CONSOLE"
   CRESET="\e[0m"    # Text Reset
   TXTBLK="\e[0;30m" # Black - Regular
   TXTRED="\e[0;31m" # Red
   TXTGRN="\e[0;32m" # Green
   TXTYLW="\e[0;33m" # Yellow
   TXTBLU="\e[0;34m" # Blue
   TXTPUR="\e[0;35m" # Purple
   TXTCYN="\e[0;36m" # Cyan
   TXTWHT="\e[0;37m" # White
   BLDBLK="\e[1;30m" # Black - Bold
   BLDRED="\e[1;31m" # Red
   BLDGRN="\e[1;32m" # Green
   BLDYLW="\e[1;33m" # Yellow
   BLDBLU="\e[1;34m" # Blue
   BLDPUR="\e[1;35m" # Purple
   BLDCYN="\e[1;36m" # Cyan
   BLDWHT="\e[1;37m" # White
   UNKBLK="\e[4;30m" # Black - Underline
   UNDRED="\e[4;31m" # Red
   UNDGRN="\e[4;32m" # Green
   UNDYLW="\e[4;33m" # Yellow
   UNDBLU="\e[4;34m" # Blue
   UNDPUR="\e[4;35m" # Purple
   UNDCYN="\e[4;36m" # Cyan
   UNDWHT="\e[4;37m" # White
   BAKBLK="\e[40m"   # Black - Background
   BAKRED="\e[41m"   # Red
   BAKGRN="\e[42m"   # Green
   BAKYLW="\e[43m"   # Yellow
   BAKBLU="\e[44m"   # Blue
   BAKPUR="\e[45m"   # Purple
   BAKCYN="\e[46m"   # Cyan
   BAKWHT="\e[47m"   # White

else
   # command line _eye candy_
   TTYTYPE="TERM"
   CRESET="\e[0m"    # Text Reset
   TXTBLK="\e[0;30m" # Black - Regular
   TXTRED="" # Red
   TXTGRN="" # Green
   TXTYLW="" # Yellow
   TXTBLU="" # Blue
   TXTPUR="" # Purple
   TXTCYN="" # Cyan
   TXTWHT="" # White

fi

# functions
java16 () {
  PATH=/opt/java1.6/bin:${LPATH}
}

java15 () {
  PATH=/opt/java1.5/bin:${LOCALPATH}
}

java14 () {
  PATH=/opt/java1.4/bin:${LOCALPATH}
}

localpaths () {
  LPATH=

  # Jython
  [ -d /opt/jython/bin ] && LPATH=/opt/jython/bin:${LPATH}

  # JRuby
  [ -d /opt/jruby/bin ] && LPATH=/opt/jruby/bin:${LPATH}

  # Groovy
  [ -d /opt/groovy/bin ] && LPATH=/opt/groovy/bin:${LPATH}

  # JMeter
  [ -d /opt/jmeter/bin ] && LPATH=/opt/jmeter/bin:${LPATH}

  # Other binaries
  [ -d /usr/sbin ] && LPATH=/usr/sbin:${LPATH}
  [ -d /usr/bin ] && LPATH=/usr/bin:${LPATH}
  [ -d /sbin ] && LPATH=/sbin:${LPATH}
  [ -d /bin ] && LPATH=/bin:${LPATH}

  # locals
  [ -d /usr/local/bin ] && LPATH=/usr/local/bin:${LPATH}
  [ -d /opt/local/sbin ] && LPATH=/opt/local/sbin:${LPATH}
  [ -d /opt/local/bin ] && LPATH=/opt/local/bin:${LPATH}
  [ -d ${HOME}/bin ] && LPATH=${HOME}/bin:${LPATH}

  LPATH=.:${LPATH}
  PATH=${LPATH}:${PATH}

}

cmdstyle () {
  if [ -s ~/git.profile ]
  then
    export PS1="\e]1;${MYIP}\a\e]2;${MYIP}:${MYHOST}\a\
      \n\[${CRESET}\][\[${TXTYLW}\]${MYIP}\[${CRESET}\](${MYHOST})]:\[${BLDGRN}\]\$(__git_ps1 '(%s)')\[${TXTWHT}\] \w \
      \n\[${TXTBLU}\]${USER}\[${CRESET}\] \$> "
  else
    export PS1="\e]1;${MYIP}\a\e]2;${MYIP}:${MYHOST}\a\
      \n\[${CRESET}\][\[${TXTYLW}\]${MYIP}\[${CRESET}\](${MYHOST})]:\[${TXTRED}\]\[${TXTWHT}\] \w \
      \n\[${TXTBLU}\]${USER}\[${CRESET}\] \$> "
  fi
  export PS2=" ..> "
  shopt -s checkwinsize
}

profile () {
   RELEASE=`openssl dgst -md5 ${HOME}/.profile | rev | cut -c-4`
   echo -e -n "${MYENTERPRISE}\nProfile ChangeID (${RELEASE})\n\n"
}



# common alias
alias ls="ls -G -F --color"
alias ll="ls -l"
alias la="ll -a"
alias lt="la -t"
alias lr="lt -r"
alias pw="pwd"

# terminal type
export EDITOR=vim
export TERM="xterm"
export LANG="en_US.UTF-8"

# history file
export HISTSIZE=1500
export HISTCONTROL=ignoredups

# otros
export MYUSER="Andres Aquino"
export MYEMAIL="aquino(at)hp.com"
export MYENTERPRISE="Hewlett-Packard Company"
export MANPATH=$HOME/manuals:$MANPATH

unset USERNAME

LOCALPATH=${PATH}
export PATH=${LOCALPATH}

# get IP Address
MYIP=`ping -c1 ${HOSTNAME} | awk '/icmp_/{print $0}' | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\).*$/\1/'`

# git functionality
[ -s ~/git.profile ] && . ~/git.profile > /dev/null 2>&1

# specific host enviroment
[ -s ~/${HOSTNAME}.profile ] && . ~/${HOSTNAME}.profile > /dev/null 2>&1

# Cursor and profile
localpaths
cmdstyle

