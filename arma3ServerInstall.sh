#!/bin/bash

# FUNCTIONS
function input_check () {
	read -p "$1" response
	response=${response,,}
	case $response in ''|y|ye|yes)
		return 0
	;;
	*)
		return 1
	;;
	esac
}

function create_instance() {
	path=$armadir/$1
	mkdir $path
	mkdir $path/keys
	mkdir $path/mpmissions
	mkdir $path/userconfig
	mkdir $path/mods
	mkdir $path/serverconfig
	touch $path/start.sh
	chmod u+x $path/start.sh
	ln -s $install/arma3server $path/arma3server
	ln -s $install/addons $path/addons
	ln -s $install/argo $path/argo
	ln -s $install/battleye $path/battleye
	ln -s $install/curator $path/curator
	ln -s $install/dta $path/dta
	ln -s $install/enoch $path/enoch
	ln -s $install/expansion $path/expansion
	ln -s $install/gm $path/gm
	ln -s $install/heli $path/heli
	ln -s $install/jets $path/jets
	ln -s $install/kart $path/kart
	ln -s $install/keys/a3.bikey $path/keys/a3.bikey
	ln -s $install/mark $path/mark
	ln -s $install/orange $path/orange
	ln -s $install/steamapps $path/steamapps
	ln -s $install/tacops $path/tacops
	ln -s $install/tank $path/tank
	ln -s $install/libsteam.so $path/libsteam.so
	ln -s $install/libsteam_api.so $path/libsteam_api.so
	ln -s $install/libtier0_s.so $path/libtier0_s.so
	ln -s $install/libvstdlib_s.so $path/libvstdlib_s.so
	ln -s $install/steam_appid.txt $path/steam_appid.txt
	ln -s $install/steamclient.so $path/steamclient.so
	echo "Instance $1 has been created."
}

function progressfilt () {
    local flag=false c count cr=$'\r' nl=$'\n'
    while IFS='' read -d '' -rn 1 c
    do
        if $flag
        then
            printf '%s' "$c"
        else
            if [[ $c != $cr && $c != $nl ]]
            then
                count=0
            else
                ((count++))
                if ((count > 1))
                then
                    flag=true
                fi
            fi
        fi
    done
}

# HEADER
echo '---- ArmA 3 Automatic Linux Server Installer ----'
echo -e '------------- Created by bitwise ----------------\n'

# SETTINGS
echo -e 'Steam Login'
echo 'Note: if a Steam Guard code is needed, enter it with the password, seperated by a space (i.e. "<password> <code>").'
read -p 'Steam username: ' user
read -p 'Steam password: ' pass
echo -e "\nThis script will now install and ArmA 3 Linux server in the $(whoami) home directory."
if ! input_check 'Are you sure you want to continue? [Y/n]'; then
	exit;
fi


# DEPENDENCY CHECKER
echo -e '\nChecking for dependencies...'
pkg='lib32gcc1'
if sudo apt-get -qq install $pkg; then
    echo "    Successfully installed $pkg"
else
    echo "    Error installing $pkg"
fi
pkg='lib32stdc++6'
if sudo apt-get -qq install $pkg; then
    echo "    Successfully installed $pkg"
else
    echo "    Error installing $pkg"
fi
echo

# STEAMCMD INSTALLER
steamcmddir=/home/$(whoami)/steamcmd
mkdir $steamcmddir
wget -P $steamcmddir http://media.steampowered.com/installer/steamcmd_linux.tar.gz --progress=bar:force 2>&1 | progressfilt
tar -xzf $steamcmddir/steamcmd_linux.tar.gz -C $steamcmddir/


# ARMA 3 SERVER INSTALLER
armadir=/home/$(whoami)/arma
mkdir $armadir
echo -e '#!/bin/bash\n/home/$(whoami)/steamcmd/steamcmd.sh +runscript /home/$(whoami)/arma/.a3update.txt' > $armadir/a3update
chmod u+x $armadir/a3update
echo -e "\n@ShutdownOnFailedCommand 1\n@NoPromptForPassword 1\nlogin $user $pass\nforce_install_dir /home/$(whoami)/arma/install\napp_update 233780 validate\nquit" > $armadir/.a3update.txt
#$armadir/a3update


# ARMA 3 INSTANCE CREATOR
install=$armadir/install
create_instance public
while ! input_check 'Would you like to create another instance? [y/N]'; do
	read -p "Enter the new instance name: " instance
	create_instance $instance
done
