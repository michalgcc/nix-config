## LiveCD process
Download and create bootable USB of: https://channels.nixos.org/nixos-23.05/latest-nixos-gnome-x86_64-linux.iso

Install with username 'mg'

### Post install
```
nix-shell -p vim git
mkdir ~/workspace
cd workspace
git clone <this repository>

# Copy hardware config
cp /etc/nixos/hardware-configuration.nix nixos/desktop/hardware-configuration.nix

# Push hardware config
git push 
# Set git username and password

# Adjust hostname
vim /etc/nixos/configuration.nix

networking.hostName = "mg-desktop"

sudo nixos-rebuild switch

./rebuild-nixos.sh
./rebuild-home-manager.sh

sudo rm /etc/nixos/*.nix
sudo reboot

Copy id_rsa (ssh entry) from Keepass to ~/.ssh/

Set permissions:
chmod 600 "$destination_dir/id_rsa"
chmod 644 "$destination_dir/id_rsa.pub"
```

## Installing on Ubuntu and WSL2:

```
sudo apt install git curl
git clone <this repository>

curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
# Logout and login

# Install home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
./rebuild_cli_nix_home_manager.sh

# Remove Ubuntu git
sudo apt remove git

# Configure git to use windows credential manager from scoop (scoop install git)
git config --global credential.helper "/mnt/c/Users/a/scoop/apps/git/current/mingw64/bin/git-credential-manager.exe

# Update Windows git config to match Nix 
Copy paste home-manager/apps/windows.git.config to %USERPROFILE%/.gitconfig
```
# Optional:
## Install NerdFont for Windows terminal

Download the latest version of 
JetBrainsMono.zip from https://github.com/ryanoasis/nerd-fonts/releases
Unzip and install JetBrainsMonoNerdFontMono-Regular.ttf

In terminal apperance setting set Font face to: `JetBrainsMono Nerd Font Mono`

Install wezterm for proper fonts handling
```
sudo apt install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.wezfurlong.wezterm
```

## Updating flake lock file

```
./update_lock_and_apply.sh
```
