$arr = "Bold-Italic", `
  "Bold-Oblique", `
  "Bold", `
  "Extra-Light-Italic", `
  "Extra-Light-Oblique", `
  "Extra-Light", `
  "Italic", `
  "Light-Italic", `
  "Light-Oblique", `
  "Light", `
  "Medium-Italic", `
  "Medium-Oblique", `
  "Medium", `
  "Oblique", `
  "Regular", `
  "Semi-Bold-Italic", `
  "Semi-Bold-Oblique", `
  "Semi-Bold", `
  "Thin-Italic", `
  "Thin-Oblique", `
  "Thin"

$arr.ForEach{
  $name = $_
  try {
    Invoke-WebRequest -ErrorAction SilentlyContinue `
      "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/VictorMono/$_/complete/Victor%20Mono%20$($_.Replace('-', '%20'))%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf" `
      -Outfile "Victor Mono $_ Nerd Font Complete Windows Compatible.ttf"
  } catch {
    "$name Not found."
  }
}
