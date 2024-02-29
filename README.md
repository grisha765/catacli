# catacli
This Bash script is a utility for managing the Cataclysm: Dark Days Ahead game installations on Linux systems, specifically focusing on GitHub releases. It allows users to easily install, update, and uninstall both stable and experimental branches of the game.
### Initial Setup

1. **Download Dependencies**: Download the `git curl wget sdl2 sdl2_image sdl2_ttf sdl2_mixer freetype2` dependencies using your distribution's package manager.
1. **Clone the repository**: Clone this repository using `git clone`.
2. **Set Permissions**: Make the script executable.

```shell
git clone https://github.com/grisha765/catacli.git
cd catacli
chmod +x catacli.sh
```

### Usage

1. **Installation**: Install the game from the selected branch (stable or experimental).

```shell
./catacli.sh {--stable\--exp} install
```

2. Update: Update the installed game to the latest version available on GitHub.

```shell
./catacli.sh {--stable\--exp} update
```

3. Uninstallation: Completely uninstall the game from the system.

```shell
./catacli.sh {--stable\--exp} uninstall
```

4. Open Game Folder: Open the folder where the game is installed.

```shell
./catacli.sh {--stable\--exp} folder
```

### Features

1. Automatically detects the latest version of the game from GitHub releases.
2. Handles installation, updating, and uninstallation of the game.
3. Creates desktop shortcuts for easy access to the game launcher.
4. Manages configuration files, saves, templates, graphics, and sound directories.
4. Provides clear instructions and usage guidance for each command.
