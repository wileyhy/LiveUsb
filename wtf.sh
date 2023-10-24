#!/usr/bin/sh -Ceux
#!/usr/bin/env -iS sh
##                                                Env vars reqd:    env       :             LC_ALL  PATH
##                                                Env vars reqd:    sh        : ENV   HOME  LC_ALL  PATH  PWD
## wtf.sh
#+  POSIX.1-2017 compliant 


## Environment
IFS=' 	
'
LC_ALL="C"
\unset -f unset
\unset -f unalias
\unalias -a

unset -f command
unset ENV
PATH="/usr/bin:/usr/sbin"
PATH="$( command -p getconf PATH ):$PATH"
export LC_ALL PATH
## Shadows                                                                                  SBU ali key fun bui fil
##                                                                              | unalias       x       _   
##                                                                              | unset     y   x       
##                                                                              | command       x       
##                                                                              | getconf       x
##                                                                              | export    y   x       

##                                                Env vars reqd:    unalias   : LC_ALL
##                                                Env vars reqd:    unset     : --
##                                                Env vars reqd:    command   : LC_ALL PATH
##                                                Env vars reqd:    getconf   : LC_ALL
##                                                Env vars reqd:    export    : --

# &Subshells, CSubs
#export             LC_ALL  PATH  TZ
## Note, exp reqd:  ^       ^         `command`

## Note, exp reqd:  ^       ^         `command`
## Note, exp reqd:  ^       ^         `awk`
## Note, exp reqd:  ?       ?         `getconf`

## Note, exp reqd:  ^             ^   `date`
## Note, exp reqd:  ^                 `printf`
## Note, exp reqd:  ^                 `cksum`
## Note, exp reqd:  ^                 `cut`
## Note, exp reqd:  ^                 `mkdir`

# shellcheck disable=SC2034
EDITOR=$( command -pv vi )
if test -z "${HOME}"
then
  HOME=$( awk -F : -v usr="${USER}" '$1 ~ usr { print $6 }' /etc/passwd )
fi
TERM="${TERM:=xterm}"
TZ=$( command -p getconf TZ )
TZ="${TZ:="UTC"}"
export TZ

##                                                                              | 
##                                                                              | 
##                                                                              | 
##                                                                              | 
##                                                                              | 
##                                                                              | 
##                                                                              | 
##                                                Env vars reqd:    command   : LC_ALL PATH
##                                                Env vars reqd:    test      : LC_ALL
##                                                Env vars reqd:    awk       : LC_ALL PATH





## Create the temporary file
umask 177
date_time=$( date +%Y%m%d%H%M%S )
crc=$( printf "%s" "${date_time}" | 
  cksum | 
  cut -b -8 )
temp_d=$( mkdir -m 0700 "/tmp/tmp_${crc}.d" )
temp_f="${temp_d}/share.${date_time}.txt"
touch -r "${temp_d}" "${temp_f}"

##                                                Env vars reqd:    umask     : LC_ALL
##                                                Env vars reqd:    date      : LC_ALL TZ
##                                                Env vars reqd:    printf    : LC_ALL
##                                                Env vars reqd:    cksum     : LC_ALL
##                                                Env vars reqd:    cut       : LC_ALL
##                                                Env vars reqd:    mkdir     : LC_ALL
##                                                Env vars reqd:    touch     : LC_ALL TZ


## Write the file
##                                                Env vars reqd:    nohup     : HOME LC_ALL PATH
##                                                Env vars reqd:    cat       : LC_ALL

nohup cat <<- \EOF > "${temp_f}"
## Programs giving some basic information...
#+
#+ ...on the user's identity
#+                whoami
#+ *              id                                      
#+ *              logname
#+
#+ ...on setting a user password
#+                passwd
#+
#+ ...on the user's access permissions
#+                sudo -l
#+
#+ ...on the name of the shell program you're using
#+ *              echo
#+                echo $SHELL
#+ *              echo $0
#+
#+ ...on your relation to the filesystem
#+ *              pwd -P
#+ *              echo $PWD
#+ *              echo $HOME
#+ *              ls $HOME
#+ *              ls -l $HOME
#+ *              ls -1Falps $HOME
#+ *              ls /
#+                ls /usr/bin /usr/sbin | less
#+ *              ls /usr/bin /usr/sbin | more
#+ *              cd && pwd -P && cd / && pwd -P && cd -
#+
#+ ...on your operating system
#+                uname -a
#+                w
#+                free
#+                top
#+
#+ ...on other programs 
#+                whatis [any text]
#+                which [any text]
#+                apropos [any text] 
#+
#+ ...on the locations of files, directories or anything else in the 
#+  filesystem
#+                updatedb 
#+                locate [any text] | grep -ie README -e doc -e pdf -e htm
#+                find / -name '*[any text]*' 2> /dev/null | less
#+
#+ ...on a few of the easier-to-use text editors, and one not-so-easy-
#+  to-use editor
#+                nano
#+                gedit
#+                kate
#+                leafpad
#+                mousepad
#+                gnome-text-editor
#+ *              vi
#+
#+ ...on the time and date
#+ *              date
#+ *              cal


## How to view any file available from your local filesystem (assuming 
#+  the file can be viewed)
#+                less [absolute path of any file]
#+                less ./[name of any file in $PWD]


## Programs giving some more specific information about themselves
#+                [program name] --help
#+                [program name] -h


## Programs giving some more specific information...
#+
#+ ...on "shell builtins"
#+                help
#+                help [name of any shell builtin]
#+                type -a [any text]
#+
#+ ...on other programs, but providing "info files" is optional for 
#+  programmers.
#+                info
#+                info [program name]


## Directories where some additional information about any given program
#+  can often be found
#+                ls /usr/share/
#+                ls /usr/share/doc/


## Programs giving more specific and sometimes highly technical 
#+  information...
#+
#+ ...on other programs. Providing "man pages" is a very common practice
#+                man 
#+                man man
#+                man [program name]
#+                man [program name] | grep -ine [any text] -e [...]
#+                man -k [any text]
#+                man -K [any text] 
#+
#+ ...on any software packages from which any given file may have 
#+  originated....
#+                rpm -qf [absolute path of any file available on disk]
#+                dnf provides [any text]


## Programs giving information on the software package from which
#+  any given file may have originated...
#+                rpm -qi [software package name]
#+                rpm -ql [software package name]
#+                dnf info [software package name]


## Programs giving information on any file or any software package
#+  available from the Linux distribution of your choosing...
#+                dnf search [any text]
#+                dnf --all search [any text]
#+                dnf info [software package name]


## Programs for more safely browsing the web (when all used at the same
#+  time, anyway)...
#+                firefox
#+                no-script
#+                privacy-badger
#+                https-everywhere


## Websites for getting some (usually) reliable information
#+                wikipedia.org
#+                gnu.org
#+                tldp.org
#+                ubuntu.com
#+                fedoraproject.org
#+                debian.org
#+                opensuse.org
#+                archlinux.org
#+                gentoo.org
#+                kernel.org
#+                distrowatch.com
#+                pgp.mit.edu
#+                keyring.debian.org
#+                linux.com
#+                linuxjournal.com
#+                linuxfoundation.org
#+                slashdot.org
#+ *              pubs.opengroup.org/onlinepubs/9699919799/nframe.html
#+                britannica.com


## Websites for getting often acceptible but sometimes completely
#+  wrongful information (the search engines themselves aren't in 
#+  any responsible for the correctness of their suggestion, of course)
#+                duckduckgo.com
#+                google.com


## Programs giving information locally which is usually available
#+  from within a web browser...
#+
#+ ...from Wikipedia
#+                wike
#+
#+ ...from DuckDuckGo
#+                ddgr
#+
#+ ...from Google
#+                googler
#+
#+ ...from the dictionary
#+                gnome-dictionary


## Need to know...
#+    - A "string" is a series of any characters that you can type in 
#+      from a keyboard.
#+    - A "newbie" is someone who is just beginning with Linux. Abbr.
#+      as "N.B."
#+    - If the text string you want to search for contains any spaces, 
#+      tabs, newlines or odd punctuation characters, then (N.B.) when 
#+      typing something on the commandline it would be best to enclose 
#+      the entire string in single quotes, eg:  
#+          'text string' or 
#+          'WTF!?!' or 
#+          'I paid $$$ for this `!@#$%?!?'
#+    - On Linux, all files and directories on the filesystem (FS) (or
#+      anything else on the FS such as sockets, FIFO's, etc.) are all
#+      considered to be "files," and are often all referred to just as 
#+      "files."
#+    - Google is your friend.
#+    - Checklists are your friends.
#+    - Intuition is better exercised in some other life context.
#+    - RTFM = Read the Fine Manual
#+    - Regular (ie, human language) text editors were not made for 
#+      viewing binary files and so they cannot be relied upon for
#+      viewing binary files both safely and directly.
#+    - Please don't install software that your distro has never heard 
#+      of before ...at least until you know the difference between 
#+      Stephen Bourne and Jason Bourne...?
#+    - Some firewalld:
#+          systemctl enable firewalld.service
#+          systemctl start firewalld.service
#+          systemctl status firewalld.service
#+          firewall-cmd --state
#+    - Don't re-use passwords.
#+    - Don't feed the trolls.
#+    - Back up your important files. 
#+    - Anything you put on the internet will stay there for the rest 
#+      of your life.
#+    - Stay off of the Darknet.
#+    - ":q" to exit out of `vi`
#+    - "set -x" to get a better idea of what the shell is really doing
#+    - It's always good to go for a walk.
#+    - Remember, mistakes can be costly, and library cards are free.

EOF

## Read the file
chmod -R 0400 "${temp_d}"
##                                                Env vars reqd:    chmod     : LC_ALL

more -e "${temp_f}"
##                                                Env vars reqd:    more      : EDITOR LC_ALL TERM


## Clean up and exit
test -d "${temp_d}" && rm -fr "${temp_d}"
##                                                Env vars reqd:    rm        : LC_ALL

exit 00
##                                                Env vars reqd:    exit      : --


