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
cp /etc/nixos/hardware-configuration.nix nixos/<configuration-name>/hardware-configuration.nix

# Push hardware config
git push 
# Set git username and password

# Adjust hostname
vim /etc/nixos/configuration.nix

networking.hostName = "mg-<configuration-name>"

sudo nixos-rebuild switch
reboot

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
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
./rebuild_cli_nix_home_manager.sh

# Remove Ubuntu git
sudo apt remove git

# Configure git to use windows credential manager from scoop (scoop install git)
git config --global credential.helper "/mnt/c/Users/a/scoop/apps/git/current/mingw64/bin/git-credential-manager.exe"

# Update Windows git config to match Nix 
Copy paste home-manager/apps/windows.git.config to %USERPROFILE%/.gitconfig
```
## Updating flake lock file

```
./update_lock_and_apply.sh
```
