#!/bin/sh

# pass flatpak as first argument when using the godot flatpak to build
godotBuild ()
{
    if [ "$1" = "flatpak" ]; then
        flatpak run org.godotengine.Godot --export-release --headless "$2"
    else
        godot --export-release --headless "$2"
    fi
}

# remake build directory
rm -rf build/
mkdir build
mkdir build/windows/
mkdir build/linux/

godotBuild "$1" "Windows Desktop"
godotBuild "$1" "Linux"
