#!/bin/sh

ultraconfPath=$XDG_CONFIG_HOME/ultraconf/
superuserMode=false

print_usage()
{
    echo ultraconf.sh [-p path] [-s] [-h]
    echo -h print this help
    echo -p path to the ultraconf directory
    echo -s superuser mode to install portage/overlay files
    exit
}

while getopts 'hp:s' OPT; do
    case "$OPT" in
        h) print_usage ;;
        p) ultraconfPath=$OPTARG ;;
        s) superuserMode=true ;;
    esac
done

installFile() {
    [ ! -d $XDG_CONFIG_HOME/$1 ] && mkdir -p $XDG_CONFIG_HOME/$1
    [ ! -d $ultraconfPath/dotfiles/$1 ] && ln -sf $ultraconfPath/dotfiles/$1    $XDG_CONFIG_HOME/$1/$2 \
                                    || ln -sf $ultraconfPath/dotfiles/$1/$2 $XDG_CONFIG_HOME/$1/$2
}

[ ! -d $XDG_CONFIG_HOME ]      && mkdir $XDG_CONFIG_HOME
[ ! -d $XDG_DATA_HOME ]        && mkdir -p $XDG_DATA_HOME
[ ! -d $XDG_DATA_HOME/../bin ] && mkdir -p $XDG_DATA_HOME/../bin

# Install users dotfiles
cp $ultraconfPath/dotfiles/zprofile ~
installFile bc              bcrc
installFile bspwm           bspwmrc
installFile gdb             init
installFile git             config
installFile gnuplot         config
installFile sxhkd           sxhkdrc
installFile tmux            tmux.conf
installFile translate-shell init.trans
installFile zprofile        .zprofile
mkdir $XDG_CONFIG_HOME/vim/{spell,syntax} $XDG_DATA_HOME/{vim,vim/undo,vim/swap,vim/backup,vim/view} 2> /dev/null
installFile vim             vimrc
installFile zathura         zathurarc
installFile mutt            style.muttrc
installFile mutt            mailcap
installFile w3m             config
installFile w3m             keymap
installFile X11             xinitrc
installFile X11             xresources
mkdir $XDG_CONFIG_HOME/zsh/completion 2> /dev/null
installFile zsh             .zshrc
installFile zsh/completion  _jira

# Install users scripts
ln -sf $ultraconfPath/scripts/*.sh $XDG_DATA_HOME/../bin/

# Install Portage conf root files
( $superuserMode ) || exit
sudo rmdir /etc/portage/package.* 2> /dev/null
sudo cp $ultraconfPath//portage/{make.conf,package.*} /etc/portage/
sudo cp $ultraconfPath/portage/world /var/lib/portage/

# Install overlay
sudo cp -r $ultraconfPath/overlay /var/db/repos/perso
