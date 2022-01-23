#!/usr/bin/env -S pwsh -nop

<#
.SYNOPSIS
   Print an image on the terminal
.DESCRIPTION
   Print an image on the terminal based on a new given height or width.
   If none of them is specified, the terminal window's width is used and the
   original aspect ratio is maintained.
.PARAMETER Width
   The new width of the image. If height is not specified, the
   original aspect ratio is maintained.
.PARAMETER Height
   The new height of the image. If width is not specified, the
   original aspect ratio is maintained.
.PARAMETER Image
   The path/URL to the image.
.PARAMETER Ascii
   Display the image using ASCII characters instead of blocks.
.EXAMPLE
   Print-Image -Height 45 -Width 45 -Image "Path/to/image.jpg"
.EXAMPLE
   Print-Image -Height 45 -Image "https://server/path/test.jpg" -Ascii
.NOTES
   Conversion Written By:
   Christopher Walker
   Printing Written By:
   jantari
   Simplified By:
   rashil2000
#>
Param (
    [Parameter(Mandatory)][String]$Image,
    [Switch]$Ascii,
    [ValidateRange(1, [int]::MaxValue)][Int]$Width,
    [ValidateRange(1, [int]::MaxValue)][Int]$Height
)
Begin {
    Add-Type -AssemblyName 'System.Drawing'
    $OldImage = if (Test-Path $Image -PathType Leaf) {
        [Drawing.Bitmap]::FromFile($(Get-Item $Image))
    } else {
        [Drawing.Bitmap]::FromStream((Invoke-WebRequest $Image).RawContentStream)
    }
    $e = [char]27
    $chars = ' .,:;+iIH$@'

    if (-not ($Width -or $Height)) {
        $Width = $Host.UI.RawUI.WindowSize.Width
        $Height = $OldImage.Height / $OldImage.Width * $Width
    } elseif (-not $Width) {
        $Width = $OldImage.Width / $OldImage.Height * $Height
    } elseif (-not $Height) {
        $Height = $OldImage.Height / $OldImage.Width * $Width
    }

    if ($Ascii) { $Height = $Height / 2.2 }
}
Process {
    $Bitmap = New-Object System.Drawing.Bitmap @($OldImage, [Drawing.Size]"$Width,$Height")

    if ($Ascii) {
        for ($i = 0; $i -lt $Bitmap.Height; $i++) {
            $outString = ""
            for ($j = 0; $j -lt $Bitmap.Width; $j++) {
                $p = $Bitmap.GetPixel($j, $i)
                $outString += "$e[38;2;$($p.R);$($p.G);$($p.B)m$($chars[[math]::Floor($p.GetBrightness() * $chars.Length)])$e[0m"
            }
            $outString
        }
    } else {
        for ($i = 0; $i -lt $Bitmap.Height; $i += 2) {
            $outString = ""
            for ($j = 0; $j -lt $Bitmap.Width; $j++) {
                $back = $Bitmap.GetPixel($j, $i)
                if ($i -ge $Bitmap.Height - 1) {
                    $foreVT = ""
                } else {
                    $fore = $Bitmap.GetPixel($j, $i + 1)
                    $foreVT = "$e[48;2;$($fore.R);$($fore.G);$($fore.B)m"
                }
                $backVT = "$e[38;2;$($back.R);$($back.G);$($back.B)m"
                $outString += "$backVT$foreVT$([char]0x2580)$e[0m"
            }
            $outString
        }
    }
}
End {
    $Bitmap.Dispose()
    $OldImage.Dispose()
}
