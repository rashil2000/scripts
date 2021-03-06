#!/usr/bin/bash

# Theme Switcher for Xfce on Kali

current=$(xfconf-query -c xsettings -p /Net/ThemeName)

if [ $current = "Kali-Dark" ]; then
  # Light Theme

  # Wallpaper
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVNC-0/workspace0/last-image -s /usr/share/backgrounds/kali-16x9/kali-small-logo.png
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVNC-1/workspace0/last-image -s /usr/share/backgrounds/kali-16x9/kali-small-logo.png

  # Icons
  xfconf-query -c xsettings -p /Net/IconThemeName -s Flat-Remix-Blue-Light

  # System
  xfconf-query -c xsettings -p /Net/ThemeName -s Kali-Light

  # Window Manager
  xfconf-query -c xfwm4 -p /general/theme -s Kali-Light

  # Lockscreen
  # sudo sed -i -e 's/Kali-Dark/Kali-Light/g' /etc/lightdm/lightdm-gtk-greeter.conf
  # sudo sed -i -e 's/Flat-Remix-Blue-Dark/Flat-Remix-Blue-Light/g' /etc/lightdm/lightdm-gtk-greeter.conf

  # Mousepad
  gsettings set org.xfce.mousepad.preferences.view color-scheme Kali-Light

  # Firefox
  sed -i -e 's/141e24/FFFFFF/g' ~/.mozilla/firefox/9xtl5lta.default-esr/chrome/userContent.css
  sed -i -e 's/darkslategrey/#FFFFFE/g' ~/.mozilla/firefox/9xtl5lta.default-esr/chrome/userContent.css

  # Git
  sed -i -e 's/decorations\ calochortus-lyallii/decorations\ hoopoe/g' ~/.config/git/config

else
  # Dark Theme

  # Wallpaper
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVNC-0/workspace0/last-image -s /usr/share/backgrounds/kali-16x9/kali-small-neon.png
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVNC-1/workspace0/last-image -s /usr/share/backgrounds/kali-16x9/kali-small-neon.png

  # Icons
  xfconf-query -c xsettings -p /Net/IconThemeName -s Flat-Remix-Blue-Dark

  # System
  xfconf-query -c xsettings -p /Net/ThemeName -s Kali-Dark

  # Window Manager
  xfconf-query -c xfwm4 -p /general/theme -s Kali-Dark

  # Lockscreen
  # sudo sed -i -e 's/Kali-Light/Kali-Dark/g' /etc/lightdm/lightdm-gtk-greeter.conf
  # sudo sed -i -e 's/Flat-Remix-Blue-Light/Flat-Remix-Blue-Dark/g' /etc/lightdm/lightdm-gtk-greeter.conf

  # Mousepad
  gsettings set org.xfce.mousepad.preferences.view color-scheme Kali-Dark

  # Firefox
  sed -i -e 's/FFFFFF/141e24/g' ~/.mozilla/firefox/9xtl5lta.default-esr/chrome/userContent.css
  sed -i -e 's/#FFFFFE/darkslategrey/g' ~/.mozilla/firefox/9xtl5lta.default-esr/chrome/userContent.css

  # Git
  sed -i -e 's/decorations\ hoopoe/decorations\ calochortus-lyallii/g' ~/.config/git/config

fi
