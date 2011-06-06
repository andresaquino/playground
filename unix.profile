#!/bin/sh 
# vim: set ts=2 et sw=2 sts=2 si ai:

# unix.profile
# -
#
# Andres Aquino <aquino(at)hp.com>
# Hewlett-Packard Company
# 

# This is the user profile enviroment file
# See bash_rc or bash_profile for more information.

# Predefined variables
_ULAND="`uname -s`"
_UHOST=`hostname | sed -e "s/\..*//g"`
_UDATE=`date "+%Y%m%d"`
_UHOUR=`date "+%H%M"`
_UNAME="Andres Aquino"
_UMAIL="aquino(at)hp.com"
_UWORK="Hewlett-Packard Company"
_UDEBG=false

# set environment
loadenvironment()
{
  # input mode
  set -o vi

  # permissions by default over new files/directories
  umask 0007

  # Terminal 
  export TTYTYPE="TERM"
  export HOSTNAME=`hostname`

  # Java Environment
  export JAVA_HOME=
  export SHLIB_PATH=

  # System binaries
  [ -d /usr/sbin ] && PATH=/usr/sbin:${PATH}
  [ -d /usr/bin ] && PATH=/usr/bin:${PATH}
  [ -d /sbin ] && PATH=/sbin:${PATH}
  [ -d /bin ] && PATH=/bin:${PATH}

  ${_UDEBG} && printto "> Loading environment"
  
  # history file and manuals
  export HISTSIZE=1500
  export HISTCONTROL=ignoredups
  export MANPATH=${HOME}/manuals:${MANPATH}

  # Terminal settings by SO
  export TERM="xterm"

  # setting locale and editor 
  if [ "${_ULAND}" = "HP-UX" ]
  then
    export EDITOR=vi
    export LANG="C"
    CLTYPE="\033"
    _IPADDR=`ping ${HOSTNAME} -n1 | awk '/icmp_/{print $0}' | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\).*$/\1/'`
  else
    export EDITOR=vim
    export LANG="en_US.UTF-8"
    CLTYPE="\e"
    _IPADDR=`ping -c1 ${HOSTNAME} | awk '/icmp_/{print $0}' | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\).*$/\1/'`
  fi

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

  # Common alias
  alias ls="ls -F"
  alias ll="ls -l"
  alias la="ll -a"
  alias lt="la -t"
  alias lr="lt -r"
  alias pw="pwd"
  alias java16="javaenvironment java16"
  alias java15="javaenvironment java15"
  alias java14="javaenvironment java14"
 
}

# Prints a message 
printto()
{
  local message="${1}"

  _echo=`which echo`
  case "${_ULAND}" in
    "HP-UX")
      ${_echo} "${message}"
    ;;
      
    "Linux")
      echo -e -n "${message} \n"
    ;;
    
    "Darwin")
      echo -e -n "${message} \n"
    ;;
      
    *)
      ${_echo} "${message} "
    ;;
  esac

}

loadprofile()
{
  local uprofile=${1}
  if [ -s ${uprofile} ]
  then
    . ${uprofile} > /dev/null 2>&1
    ${_UDEBG} && printto "> Load profile ${uprofile}"
  fi

}

# Set a java environment
javaenvironment()
{
  local JAVA_ENV="${1}"

  # rebuild path and validate
  local JAVA_PROF="${HOME}/paths.d/${JAVA_ENV}"
  
  # java path file? 
  grep -q java "${JAVA_PROF}" || return 0

  # reload paths to eliminate some java previous settings
  localpaths

  # rebuild path with java home
  for eachpath in $(cat ${JAVA_PROF})
  do
    # expand vars
    eachpath="$(eval echo ${eachpath})"
    if [ -d ${eachpath}/bin ] 
    then
      PATH=${eachpath}/bin:${PATH}
      ${_UDEBG} && printto "> Adding new path: ${eachpath}/bin"

      JAVA_HOME=${eachpath}
      JAVA_VERSION=`java -version 2>&1 | grep "version" | sed -e "s/\"//g;s/.*ion //g"`
      ${_UDEBG} && printto "> Setting JAVA_HOME to ${eachpath}, Ver. ${JAVA_VERSION}"
      
      # workaround hp-ux & java16
      [ ${_ULAND} = "HP-UX" ] && [ ${JAVA_ENV} = "java16" ] && SHLIB_PATH=${JAVA_HOME}/jre/lib/PA_RISC2.0/jli
      return 0
    fi
  done

}

# Define a execution unix path reading each file in Paths.d
localpaths () 
{
  LPATH=

  [ ! -d ${HOME}/paths.d ] || [ -z "$(ls -A ${HOME}/paths.d)" ] && return 0
  for pathfile in ${HOME}/paths.d/*
  do
    # empty file?
    [ ! -s ${pathfile} ] && continue
    
    # java path file? 
    grep -q java "${pathfile}" && continue 

    # foreach file, get paths and add to execution path
    for eachpath in $(cat ${pathfile})
    do
      eachpath="$(eval echo ${eachpath} | sed -e 's/ *//g')"
      [ ! -d ${eachpath} ] && break 
      LPATH=${eachpath}:${LPATH}
      ${_UDEBG} && printto "> Adding new path: ${eachpath}"
    done
  done

  # User binary  
  [ -d ${HOME}/bin ] && LPATH=${HOME}/bin:${LPATH}

  LPATH=.:${LPATH}
  PATH=${LPATH}:${_PATH}

}

# Sets PS1 and PS2 using an _eye candy_ cmd line, if you're using Git it shows branch name
cmdstyle () 
{
  export _USERNAME=${_UNAME}
  export _USERMAIL=${_UMAIL}
  export _USERWORK=${_UWORK}

  if [ "${_ULAND}" = "HP-UX" ]
  then
    export PS1="$(echo "\n${CRESET}[${TXTYLW}${_IPADDR}${TXTWHT}(${_UHOST})${TXTWHT}]: \${PWD} \n${TXTBLU}${USER} ${CRESET}\$> ")"
  else
    if [ -s ~/git.profile ]
    then
      export PS1="\e]1;${_IPADDR}\a\e]2;${_IPADDR}:${_UHOST}\a\
                  \n\[${CRESET}\][\[${TXTYLW}\]${_IPADDR}\[${CRESET}\](${_UHOST})]:\[${BLDGRN}\]\$(__git_ps1 '(%s)')\[${TXTWHT}\] \w \
                  \n\[${TXTBLU}\]${USER}\[${CRESET}\] \$> "
    else
      export PS1="\e]1;${_IPADDR}\a\e]2;${_IPADDR}:${_UHOST}\a\
                  \n\[${CRESET}\][\[${TXTYLW}\]${_IPADDR}\[${CRESET}\](${_UHOST})]:\[${TXTRED}\]\[${TXTWHT}\] \w \
                  \n\[${TXTBLU}\]${USER}\[${CRESET}\] \$> "
    fi
  fi
  export PS2=" ..> "
  unset USERNAME
}

# Shows MD5 of this profile
version () 
{
  FPROF=`basename ~/host.info`
  RELEASE=`openssl dgst -md5 ${FPROF} | rev | cut -c-4`
  printto "Profile ver. (${RELEASE}) \n${_UWORK} \n\nCoded by Andres Aquino <aquino(at)hp.com>"
}

# set environment
loadenvironment

# profiles per host
loadprofile ~/host.info
loadprofile ~/git.profile
loadprofile ~/${HOSTNAME}.profile
loadprofile ~/bscswp8.profile
_PATH=${PATH}

# Cursor and profile
localpaths
cmdstyle

