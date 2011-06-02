#!/bin/sh 
# vim: set ts=2 et sw=2 sts=2 si ai:

# strategylabs.profile
# --
# (c) 2010 StrategyLabs!
# Andres Aquino <andres.aquino@gmail.com>
#

# This is the user profile enviroment file
# See bash_rc or bash_profile for more information.

# input mode
set -o vi
umask 0007

# otros
export HOSTNAME=`hostname`
export MYHOST=`hostname | sed -e "s/\..*//g"`
export TTYTYPE="TERM"

# Type of SO
CLTYPE="\e"
[ "${APSYSO}" = "HP-UX" ] && CLTYPE="\033"

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

  # command line _eye candy_
  CRESET="${CLTYPE}[0m"    # Text Reset
  TXTBLK="${CLTYPE}[0;30m" # Black - Regular
  TXTRED="${CLTYPE}[0;31m" # Red
  TXTGRN="${CLTYPE}[0;32m" # Green
  TXTYLW="${CLTYPE}[0;33m" # Yellow
  TXTBLU="${CLTYPE}[0;34m" # Blue
  TXTPUR="${CLTYPE}[0;35m" # Purple
  TXTCYN="${CLTYPE}[0;36m" # Cyan
  TXTWHT="${CLTYPE}[0;37m" # White
  BLDBLK="${CLTYPE}[1;30m" # Black - Bold
  BLDRED="${CLTYPE}[1;31m" # Red
  BLDGRN="${CLTYPE}[1;32m" # Green
  BLDYLW="${CLTYPE}[1;33m" # Yellow
  BLDBLU="${CLTYPE}[1;34m" # Blue
  BLDPUR="${CLTYPE}[1;35m" # Purple
  BLDCYN="${CLTYPE}[1;36m" # Cyan
  BLDWHT="${CLTYPE}[1;37m" # White
  UNKBLK="${CLTYPE}[4;30m" # Black - Underline
  UNDRED="${CLTYPE}[4;31m" # Red
  UNDGRN="${CLTYPE}[4;32m" # Green
  UNDYLW="${CLTYPE}[4;33m" # Yellow
  UNDBLU="${CLTYPE}[4;34m" # Blue
  UNDPUR="${CLTYPE}[4;35m" # Purple
  UNDCYN="${CLTYPE}[4;36m" # Cyan
  UNDWHT="${CLTYPE}[4;37m" # White
  BAKBLK="${CLTYPE}[40m"   # Black - Background
  BAKRED="${CLTYPE}[41m"   # Red
  BAKGRN="${CLTYPE}[42m"   # Green
  BAKYLW="${CLTYPE}[43m"   # Yellow
  BAKBLU="${CLTYPE}[44m"   # Blue
  BAKPUR="${CLTYPE}[45m"   # Purple
  BAKCYN="${CLTYPE}[46m"   # Cyan
  BAKWHT="${CLTYPE}[47m"   # White

else
  # command line _eye candy_
  TTYTYPE="TERM"
  CRESET="${CLTYPE}[0m"    # Text Reset
  TXTBLK="${CLTYPE}[0;30m" # Black - Regular
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
  PATH=/opt/java1.6/bin:${LOCALPATH}
}

java15 () {
  PATH=/opt/java1.5/bin:${LOCALPATH}
}

java14 () {
  PATH=/opt/java1.4/bin:${LOCALPATH}
}

localpaths () {
  LPATH=

  # JRuby
  [ -d /opt/jruby/bin ] && LPATH=/opt/jruby/bin:${LPATH}

  # Jython
  [ -d /opt/jython/bin ] && LPATH=/opt/jython/bin:${LPATH}

  # Groovy
  [ -d /opt/groovy/bin ] && LPATH=/opt/groovy/bin:${LPATH}

  # JMeter
  [ -d /opt/jmeter/bin ] && LPATH=/opt/jmeter/bin:${LPATH}

  # Other binaries
  [ -d /usr/sbin ] && LPATH=/usr/sbin:${LPATH}
  [ -d /usr/bin ] && LPATH=/usr/bin:${LPATH}
  [ -d /sbin ] && LPATH=/sbin:${LPATH}

  # locals
  [ -d /opt/local/sbin ] && LPATH=/opt/local/sbin:${LPATH}
  [ -d /opt/local/bin ] && LPATH=/opt/local/bin:${LPATH}
  [ -d /usr/local/bin ] && LPATH=/usr/local/bin:${LPATH}
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
  FPROF=${HOME}/.profile
  [ ! -r ${FPROF} ] && FPROF=${HOME}/.bash_profile
  RELEASE=`openssl dgst -md5 ${FPROF}/ | rev | cut -c-4`
  echo -e -n "${MYENTERPRISE}\nProfile ChangeID (${RELEASE})\n\n"
}

# common alias
alias ls="ls -G -F"
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
export MYEMAIL="andres.aquino@gmail.com"
export MYENTERPRISE="StrategyLabs!"
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

