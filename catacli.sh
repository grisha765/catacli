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
	if test -d $HOME/.local/share/$name; then
		echo "Game ${name} is already installed!"
		exit
	elif ! test -d $HOME/.local/share/$name; then
		# скачивание игры
		wget -P /tmp $fresh
		tar_fresh=$(ls /tmp | grep linux-tiles-x64)
		[ -d $HOME/.local/share/$name ] || mkdir -p $HOME/.local/share/$name
		tar -xzf /tmp/$tar_fresh -C $HOME/.local/share/$name --strip-components=1
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

		# создание символической ссылки на папку с настройками
		[ -d $HOME/.config/$name ] || mkdir -p $HOME/.config/$name
		ln -s $HOME/.config/$name $HOME/.local/share/$name/config 
		# создание символической ссылки на папку с данными
		[ -d $HOME/.$name ] || mkdir -p $HOME/.$name # создаём корень
		# папка с сохранениями
		[ -d $HOME/.$name/save ] || mkdir -p $HOME/.$name/save
		ln -s $HOME/.$name/save $HOME/.local/share/$name/save
		# папка с шаблонами персонажей
		[ -d $HOME/.$name/templates ] || mkdir -p $HOME/.$name/templates
		ln -s $HOME/.$name/templates $HOME/.local/share/$name/templates
		# папка с тайлсетами
		[ -d $HOME/.$name/gfx ] || mkdir -p $HOME/.$name/gfx
		mv $HOME/.local/share/$name/gfx/* $HOME/.$name/gfx/
		rm -rf $HOME/.local/share/$name/gfx
		ln -s $HOME/.$name/gfx $HOME/.local/share/$name/gfx
		# папка с звуками
		[ -d $HOME/.$name/sound ] || mkdir -p $HOME/.$name/sound
		mv $HOME/.local/share/$name/data/sound/* $HOME/.$name/sound/
		rm -rf $HOME/.local/share/$name/data/sound 
		ln -s $HOME/.$name/sound $HOME/.local/share/$name/data/sound

		echo "Installation of ${name} completed successfully!"
		echo "${fresh}" > $HOME/.cache/catacli.ver
		exit
	fi

# обновление игры
elif [ "$2" = "update" ]; then
	if [ "${ver}" != "${fresh}" ]; then
		# создание бекапа
		rm -rf $HOME/.local/share/${name}-backup
		mv $HOME/.local/share/$name $HOME/.local/share/${name}-backup
		# скачивание новой версии
		wget -P /tmp $fresh
		tar_fresh=$(ls /tmp | grep linux-tiles-x64)
		[ -d $HOME/.local/share/$name ] || mkdir -p $HOME/.local/share/$name
		tar -xzf /tmp/$tar_fresh -C $HOME/.local/share/$name --strip-components=1
		wget -O $HOME/.local/share/$name/icon.png https://play-lh.googleusercontent.com/GpliYC38XP6cLxg6qVrWoHPI5ksaTnAVxy6fpS51p5yo46hJj5rZgqZH95-gYve0wdXH
		
		# создание символической ссылки на папку с настройками
		ln -s $HOME/.config/$name $HOME/.local/share/$name/config 
		# папка с сохранениями
		ln -s $HOME/.$name/save $HOME/.local/share/$name/save
		# папка с шаблонами персонажей
		ln -s $HOME/.$name/templates $HOME/.local/share/$name/templates
		# папка с тайлсетами
		rm -rf $HOME/.local/share/$name/gfx
		ln -s $HOME/.$name/gfx $HOME/.local/share/$name/gfx
		# папка с звуками
		rm -rf $HOME/.local/share/$name/data/sound 
		ln -s $HOME/.$name/sound $HOME/.local/share/$name/data/sound
		echo "Update for ${name} successfully installed!"
		exit
	elif [ "${ver}" = "${fresh}" ]; then
		echo "There are currently no game updates."
		exit
	fi

# удаление игры
elif [ "$2" = "uninstall" ]; then
	rm -rf $HOME/.local/share/$name*
	rm -rf $HOME/.local/share/applications/$name*
	read -r -p "Delete config files? [Y/n] " response
	if [[ $input =~ ^[Yy]$|^$ ]]; then
		rm -rf $HOME/.config/$name*
		rm -rf $HOME/.$name*
	fi
	echo "Removal of ${name} completed successfully!"
	rm $HOME/.cache/catacli.ver
	exit
elif [ "$2" = "folder" ]; then
	xdg-open $HOME/.local/share/$name
else
	echo "Available launch arguments for the utility:
install = download the game from the selected branch,
update = install updates for the selected branch,
uninstall = uninstall the game from the selected branch,
folder = open the folder with the installed game.
"
	exit
fi
