#!/data/data/com.termux/files/usr/bin/bash

rm ~/.termux/colors.properties
cd ~/projects/scripts/ts
theme=$(cat current)
if [ $theme == "dark" ] ; then
  cp one-light ~/.termux/colors.properties
  echo 'light' | tee current > /dev/null
  termux-reload-settings
  sed -i -e 's/\"dark\"/\"light\"/g' ~/.config/nvim/init.vim
  sed -i -e 's/\"ayu_dark\"/\"ayu_light\"/g' ~/.config/nvim/init.vim
else
  cp default ~/.termux/colors.properties
  echo 'dark' | tee current > /dev/null
  termux-reload-settings
  sed -i -e 's/\"light\"/\"dark\"/g' ~/.config/nvim/init.vim
  sed -i -e 's/\"ayu_light\"/\"ayu_dark\"/g' ~/.config/nvim/init.vim
fi
