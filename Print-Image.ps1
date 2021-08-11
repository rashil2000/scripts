#!pwsh

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
   The path to the image
.EXAMPLE
   Print-Image -Height 45 -Width 45 -Image "Path/to/image.jpg"
.EXAMPLE
   Print-Image -Height 45 -Image "Path/to/image.jpg"
.NOTES
   Conversion Written By:
   Christopher Walker
   Printing Written By:
   jantari
	 Simplified By:
	 rashil2000
#>
Param (
    [Parameter(Mandatory)]
    [ValidateScript( { Test-Path -Path $_ -PathType Leaf } )][String]$Image,
    [ValidateRange(1, [int]::MaxValue)][Int]$Width,
    [ValidateRange(1, [int]::MaxValue)][Int]$Height
)
Begin {
    Add-Type -AssemblyName 'System.Drawing'
    $OldImage = New-Object -TypeName System.Drawing.Bitmap -ArgumentList $Image
    $e = [char]27

    if (-not ($Width -or $Height)) {
        $Width = $Host.UI.RawUI.WindowSize.Width
        $Height = $OldImage.Height / $OldImage.Width * $Width
    } elseif (-not $Width) {
        $Width = $OldImage.Width / $OldImage.Height * $Height
    } elseif (-not $Height) {
        $Height = $OldImage.Height / $OldImage.Width * $Width
    }
}
Process {
    $Bitmap = New-Object -TypeName System.Drawing.Bitmap -ArgumentList $Width, $Height
    $NewImage = [System.Drawing.Graphics]::FromImage($Bitmap)

    $NewImage.DrawImage($OldImage, $(New-Object -TypeName System.Drawing.Rectangle -ArgumentList 0, 0, $Width, $Height))

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
End {
    $Bitmap.Dispose()
    $NewImage.Dispose()
    $OldImage.Dispose()
}
