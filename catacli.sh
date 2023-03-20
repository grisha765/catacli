#!/bin/bash

ver=$(cat $HOME/.cache/catacli.ver)

if [ "$1" = "--stable" ]; then
	name="cataclysm-dda-stable"
	name_ico="Cataclysm: Dark Days Ahead (Stable)"
	fresh=$(curl -s https://cataclysmdda.org/releases/ | grep -m 1 linux-tiles-x64 | sed 's/.*<p><a href="//g; s/".*//g')
elif [ "$1" = "--exp" ]; then
	name="cataclysm-dda-exp"
	name_ico="Cataclysm: Dark Days Ahead (Experimental)"
	fresh=$(curl -s https://cataclysmdda.org/experimental/ | grep -m 1 linux-tiles-x64 | sed 's/.*<p><a href="//g; s/".*//g')
else
	echo "Available utilities to run: 
--stable = stable game branch,
--exp = unstable branch of the game."
	exit
fi

# установка игры
if [ "$2" = "install" ]; then
	if [ "${fresh}" = "${ver}" ]; then
		echo "You have the latest version installed ${name}"
		exit
	elif [ "${fresh}" != "${ver}" ]; then 
		wget -P /tmp $fresh
		tar_fresh=$(ls /tmp | grep linux-tiles-x64)
		[ -d $HOME/.local/share/$name ] || mkdir -p $HOME/.local/share/$name
		tar -xzf /tmp/$tar_fresh -C $HOME/.local/share/$name --strip-components=1 --overwrite
		# создание ярлыка в ~/.local/share/applications
		wget -O $HOME/.local/share/$name/icon.png https://play-lh.googleusercontent.com/GpliYC38XP6cLxg6qVrWoHPI5ksaTnAVxy6fpS51p5yo46hJj5rZgqZH95-gYve0wdXH
		test -e $HOME/.local/share/applications/$name.desktop || echo "[Desktop Entry]
Version=1.0
Name=${name_ico}
Exec=${HOME}/.local/share/${name}/cataclysm-launcher
Icon=${HOME}/.local/share/${name}/icon.png
Type=Application
Categories=Game;" > $HOME/.local/share/applications/$name.desktop
		read -r -p "Do you want to delete the archive with the game after installation? [Y/n] " response
		if [[ $input =~ ^[Yy]$|^$ ]]; then
			rm -rf /tmp/$tar_fresh
		fi
		echo "Installation of ${name} completed successfully!"
		echo "${fresh}" > $HOME/.cache/catacli.ver
		exit
	fi

# удаление игры
elif [ "$2" = "uninstall" ]; then
	rm -rf $HOME/.local/share/$name*
	rm -rf $HOME/.local/share/applications/$name*
	echo "Removal of ${name} completed successfully!"
	rm $HOME/.cache/catacli.ver
	exit
elif [ "$2" = "folder" ]; then
	xdg-open $HOME/.local/share/$name
else
	echo "Available launch arguments for the utility:
install = download the game from the selected branch,
uninstall = uninstall the game from the selected branch,
folder = open the folder with the installed game.
"
	exit
fi
