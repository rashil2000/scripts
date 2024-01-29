#!/data/data/com.termux/files/usr/bin/bash

pushd ~/.termux
rm colors.properties

if grep -Fxq "use-black-ui = true" termux.properties ; then
  cp google-light.properties colors.properties
  sed -i -e 's/use-black-ui\ =\ true/use-black-ui\ =\ false/g' termux.properties
  termux-reload-settings
else
  cp google-dark.properties colors.properties
  sed -i -e 's/use-black-ui\ =\ false/use-black-ui\ =\ true/g' termux.properties
  termux-reload-settings
fi

popd
