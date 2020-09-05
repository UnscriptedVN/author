#!/bin/sh

sdk_name=renpy-$1-sdk
echo "Downloading the specified SDK (${sdk_name})..."
wget -q https://www.renpy.org/dl/$1/${sdk_name}.tar.bz2
clear

echo "Downloaded SDK version (${sdk_name})."
echo "Setting up the specified SDK (${sdk_name})..."
tar -xf ./${sdk_name}.tar.bz2
rm ./${sdk_name}.tar.bz2
mv ./${sdk_name} ../renpy

if $3; then
    echo "Downloading Steam libraries..."
    wget -q http://www.renpy.org/dl/steam/renpy-steam-libs.zip
    unzip renpy-steam-libs.zip
    rm renpy-steam-libs.zip
    echo "Copying Steam libraries over to the Ren'Py SDK..."
    cp -rv lib/ ../renpy/lib/
    rm -r lib
    echo "Files copied."
fi

echo "Building the project at $2..."
if ../renpy/renpy.sh ../renpy/launcher distribute $2; then
    built_dir=$(ls | grep '\-dists')
    echo ::set-output name=dir::$built_dir
    echo ::set-output name=version::${built_dir%'-dists'}
else
    return 1
fi
