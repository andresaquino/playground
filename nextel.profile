#!/bin/sh 
# vim: set ts=2 et sw=2 sts=2 si ai:

# nextel-hpux.profile
# --
# (c) 2010 Hewlett-Packard Company
# Andres Aquino <aquino@hp.com>
#

# This is the user profile enviroment file.
# See bash_rc or bash_profile for more information.

# input mode
set -o vi
umask 0007

# otros
export HOSTNAME=`hostname`
export MYHOST=`echo ${HOSTNAME} | tr "[:upper:]" "[:lower:]" | sed -e "s/m.*hp//g"`
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
   CRESET="\033[0m"    # Text Reset
   TXTBLK="\033[0;30m" # Black - Regular
   TXTRED="\033[0;31m" # Red
   TXTGRN="\033[0;32m" # Green
   TXTYLW="\033[0;33m" # Yellow
   TXTBLU="\033[0;34m" # Blue
   TXTPUR="\033[0;35m" # Purple
   TXTCYN="\033[0;36m" # Cyan
   TXTWHT="\033[0;37m" # White
   BLDBLK="\033[1;30m" # Black - Bold
   BLDRED="\033[1;31m" # Red
   BLDGRN="\033[1;32m" # Green
   BLDYLW="\033[1;33m" # Yellow
   BLDBLU="\033[1;34m" # Blue
   BLDPUR="\033[1;35m" # Purple
   BLDCYN="\033[1;36m" # Cyan
   BLDWHT="\033[1;37m" # White
   UNKBLK="\033[4;30m" # Black - Underline
   UNDRED="\033[4;31m" # Red
   UNDGRN="\033[4;32m" # Green
   UNDYLW="\033[4;33m" # Yellow
   UNDBLU="\033[4;34m" # Blue
   UNDPUR="\033[4;35m" # Purple
   UNDCYN="\033[4;36m" # Cyan
   UNDWHT="\033[4;37m" # White
   BAKBLK="\033[40m"   # Black - Background
   BAKRED="\033[41m"   # Red
   BAKGRN="\033[42m"   # Green
   BAKYLW="\033[43m"   # Yellow
   BAKBLU="\033[44m"   # Blue
   BAKPUR="\033[45m"   # Purple
   BAKCYN="\033[46m"   # Cyan
   BAKWHT="\033[47m"   # White

else
   # command line _eye candy_
   TTYTYPE="TERM"
   CRESET="\033[0m"    # Text Reset
   TXTBLK="\033[0;30m" # Black - Regular
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
  PATH=/opt/java1.5/bin:${LPATH}
}

java14 () {
  PATH=/opt/java1.4/bin:${LPATH}
}

localpaths () {
  LPATH=${PATH}

  # principal binaries
  [ -d /usr/sbin ] && LPATH=/usr/sbin:${LPATH}
  [ -d /usr/bin ] && LPATH=/usr/bin:${LPATH}
  [ -d /sbin ] && LPATH=/sbin:${LPATH}
  [ -d /bin ] && LPATH=/bin:${LPATH}

  # locals
  [ -d /opt/local/sbin ] && LPATH=/opt/local/sbin:${LPATH}
  [ -d /opt/local/bin ] && LPATH=/opt/local/bin:${LPATH}

  # JRuby
  [ -d ${HOME}/jruby ] && LPATH=${HOME}/jruby/bin:${LPATH}

  # Groovy
  [ -d ${HOME}/groovy ] && LPATH=${HOME}/groovy/bin:${LPATH}

  # JMeter
  [ -d ${HOME}/jmeter ] && LPATH=${HOME}/jmeter/bin:${LPATH}
  
  # monopse 
  [ -d ${HOME}/monopse ] && LPATH=${HOME}/monopse:${LPATH}

  # soya
  [ -d ${HOME}/soya ] && LPATH=${HOME}/soya:${LPATH}

  # perl (local version)
  [ -d ${HOME}/3pp/perl/5.8.3/ora10/bin ] && LPATH=${HOME}/3pp/perl/5.8.3/ora10/bin:${LPATH}

  # by local user
  [ -d ${HOME}/apps ] && LPATH=${HOME}/apps:${LPATH}
  [ -d ${HOME}/bin ] && LPATH=${HOME}/bin:${LPATH}

  LPATH=${LPATH}:.
  PATH=${LPATH}

}

cmdstyle () {
   export PS1="$(echo "\n${CRESET}[${TXTYLW}${MYIP}${TXTWHT}(${MYHOST})${CRESET}]:${TXTWHT} \${PWD} \n${TXTBLU}${USER} ${CRESET}\$> ")"
   export PS2=" ..> "
}

profile () {
   RELEASE=`openssl dgst -md5 ${HOME}/.profile | rev | cut -c-4`
   echo -e -n "${MYENTERPRISE}\nProfile ChangeID (${RELEASE})\n\n"
}

# common alias
alias ls="ls -F"
alias ll="ls -l"
alias la="ll -a"
alias lt="la -t"
alias lr="lt -r"
alias pw="pwd"


# terminal type
export EDITOR=vi
export TERM="xterm"
export LANG=C

# history file
export HISTSIZE=1500
export HISTCONTROL=ignoredups

# otros
export MYUSER="Aplicaciones"
export MYEMAIL="aplicaciones@hp.com"
export MYENTERPRISE="Hewlett-Packard Company"
export MANPATH=$HOME/manuals:$MANPATH

unset USERNAME

# get IP Address
MYIP=`/usr/sbin/ping ${HOSTNAME} -n1 | awk '/icmp_/{print $0}' | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\).*$/\1/'`

# git functionality
[ -s ~/git.profile ] && . ~/git.profile > /dev/null 2>&1

# specific host enviroment
[ -s ~/bscswp8.profile ] && . ~/bscswp8.profile 
[ -s ~/${HOSTNAME}.profile ] && . ~/${HOSTNAME}.profile > /dev/null 2>&1

# load paths and java 
localpaths
java15

# set cursors cmd
cmdstyle

