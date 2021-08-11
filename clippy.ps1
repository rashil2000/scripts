#!pwsh

# A cute little script to show the current weather information

$e = [char]0x1B
$linehere = try {
    $texthere = (Invoke-RestMethod wttr.in/?format=%f`,%l).TrimStart('+').Split(',')
    "Hmm, feels like $($texthere[0]) in $($texthere[1])"
} catch {
    "Hmm, looks like you're not connected to the internet"
}
$chars = '-' * ($linehere.Length + 4)

@"
${e}[33m$chars
|${e}[0m ${e}[3;34m$linehere${e}[0m ${e}[33m|
$chars
         /
        /${e}[0m
     __
    /  \
    |  |
    ${e}[3;5;90m@  @${e}[0m
    |  |
    || |/
    || ||
    |\_/|
    \___/

"@
