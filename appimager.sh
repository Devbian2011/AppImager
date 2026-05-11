#!/bin/bash

AppImager="v1.0.0"

if [ "$1" = "--version" ]
then
{
    echo "AppImager version $AppImager"
    exit 1
}
fi

if [ "$1" = "--dir" ]
then
{
    ls "$HOME/.local/share/applications/"
    exit 1
}
fi

if [ "$1" = "install" ]
then
{
    cd "$HOME" || exit 1
    pwd
    #read -p "Provide AppImage location: " appimage_location
    appimage_location="$2"
    read -p "Provide application category (Game,Accessories,Development,Internet, etc..): " appimage_category
    read -p "Provide Application icon location (optional, press ENTER to skip): " appimage_icon
    if [ ! -e "$appimage_location" ]
    then
    {
        echo "file not found"
        exit 1
    }
    fi
    echo "AppImage located."
    appimage_name="${appimage_location##*/}"
    appimage_name_no_extension="${appimage_name%.*}"
    mkdir -p "$HOME/Applications"
    mkdir -p "$HOME/Applications/$appimage_name_no_extension"
    cp "$appimage_location" "$HOME/Applications/$appimage_name_no_extension"
    chmod +x "$HOME/Applications/$appimage_name_no_extension/$appimage_name"
    cd "$HOME/Applications/$appimage_name_no_extension"
    pwd
    touch "$appimage_name_no_extension.desktop"
cat <<EOF > "$appimage_name_no_extension.desktop"
[Desktop Entry]
Name=$appimage_name_no_extension
Exec=$HOME/Applications/$appimage_name_no_extension/$appimage_name
Type=Application
Categories=$appimage_category;
Terminal=false
Icon=$appimage_icon
EOF
    cp "$HOME/Applications/$appimage_name_no_extension/$appimage_name_no_extension.desktop" "$HOME/.local/share/applications/"
    exit 1
}
fi

if [ "$1" = "remove" ]
then
    appimage_input="${2%/}"

    if [ -z "$appimage_input" ]
    then
        echo "Provide AppImage name or path"
        exit 1
    fi

    if [ -d "$appimage_input" ]
    then
        appimage_name_no_extension="${appimage_input##*/}"
    else
        appimage_name="${appimage_input##*/}"
        appimage_name_no_extension="${appimage_name%.*}"
    fi

    install_dir="$HOME/Applications/$appimage_name_no_extension"
    desktop_file="$HOME/.local/share/applications/$appimage_name_no_extension.desktop"

    if [ -d "$install_dir" ]
    then
        rm -rf "$install_dir"
        echo "Removed $install_dir"
    else
        echo "Install directory not found: $install_dir"
    fi

    if [ -f "$desktop_file" ]
    then
        rm "$desktop_file"
        echo "Removed desktop entry"
    else
        echo "Desktop entry not found: $desktop_file"
    fi
fi
