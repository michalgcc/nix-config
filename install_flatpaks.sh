#!/usr/bin/env bash

# Optional:

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#  _    _       _           _        _ _
# | |  | |     (_)         | |      | | |
# | |  | |_ __  _ _ __  ___| |_ __ _| | |
# | |  | | '_ \| | '_ \/ __| __/ _` | | |
# | |__| | | | | | | | \__ \ || (_| | | |
#  \____/|_| |_|_|_| |_|___/\__\__,_|_|_|
#
#

# When removing a flatpak change install to uninstall
flatpak uninstall flathub com.spotify.Client

#  _____           _        _ _
# |_   _|         | |      | | |
#   | |  _ __  ___| |_ __ _| | |
#   | | | '_ \/ __| __/ _` | | |
#  _| |_| | | \__ \ || (_| | | |
# |_____|_| |_|___/\__\__,_|_|_|
#
#

flatpak install flathub com.github.tchx84.Flatseal

flatpak install flathub org.mozilla.firefox
flatpak override --user --talk-name=org.freedesktop.ScreenSaver org.mozilla.firefox
flatpak override --user --env=MOZ_ENABLE_WAYLAND=1 org.mozilla.firefox

# Needed for mp4 playback in Firefox
flatpak install flathub org.freedesktop.Platform.ffmpeg-full/x86_64/24.08

# flatpak install md.obsidian.Obsidian

# flatpak override --user --env=OBSIDIAN_USE_WAYLAND=1 md.obsidian.Obsidian

flatpak install flathub io.github.peazip.PeaZip

flatpak install flathub org.keepassxc.KeePassXC

flatpak install flathub com.brave.Browser
echo "Brave: Change prefered ozone platform to wayland"

flatpak install flathub com.github.johnfactotum.Foliate

# flatpak install flathub net.ankiweb.Anki
# flatpak override --user --env=ANKI_WAYLAND=1 net.ankiweb.Anki

# flatpak install flathub com.github.iwalton3.jellyfin-media-player
# flatpak override --user --env=QT_QPA_PLATFORM=wayland com.github.iwalton3.jellyfin-media-player

flatpak install flathub org.remmina.Remmina

flatpak install flathub org.videolan.VLC

flatpak install flathub io.mpv.Mpv

flatpak install flathub io.github.giantpinkrobots.flatsweep

flatpak install flathub org.signal.Signal
flatpak override --user --env=SIGNAL_USE_WAYLAND=1,SIGNAL_USE_TRAY_ICON=1 org.signal.Signal
