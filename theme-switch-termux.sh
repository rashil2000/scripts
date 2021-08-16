#!/data/data/com.termux/files/usr/bin/bash

rm ~/.termux/colors.properties
cd ~/GitHub/rashil2000/scripts/Nice
theme=$(cat current)
if [ $theme == "dark" ] ; then
  cp one-light ~/.termux/colors.properties
  echo 'light' | tee current > /dev/null
  termux-reload-settings
  sed -i -e 's/decorations\ calochortus-lyallii/decorations\ hoopoe/g' ~/.config/git/config
else
  cp default ~/.termux/colors.properties
  echo 'dark' | tee current > /dev/null
  termux-reload-settings
  sed -i -e 's/decorations\ hoopoe/decorations\ calochortus-lyallii/g' ~/.config/git/config
fi
