#!pwsh

# A cute little script to show GitHub notifications on the terminal.
# Requires an access token to be stored in PowerShell's secret vault.

$e = [char]0x1b
$conwidth = $Host.UI.RawUI.WindowSize.Width

ForEach ($res in (Invoke-RestMethod https://api.github.com/notifications `
                    -h @{ Authorization = "Bearer $(Get-Secret GH_NOTIF_API_KEY -AsPlainText)" }))
{
    $reponame = $res.repository.full_name

    "`n{0}        {1,$($conwidth - $reponame.Length)}" -f `
        "$e[1m$reponame$e[0m", `
        "$e[3m$(Get-Date -Date $res.updated_at -UFormat "%c")$e[0m"
    "$($res.subject.type) ($e[4m$($res.reason)$e[0m)"
    "$($res.subject.title)"
    "$e[3;34m$($res.subject.url.Replace('api.','').Replace('repos/',''))$e[0m"
    "-" * $reponame.Length
}
