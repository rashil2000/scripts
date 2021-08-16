#!/usr/bin/env pwsh

<#
.SYNOPSIS
   Preview markdown files using GitHub's stylesheet
.DESCRIPTION
   Convert a given markdown file to HTML using either GitHub's Markdown
   API or PowerShell's builtin cmdlet and preview it in a browser with
   GitHub's stylesheet applied. The stylesheet is embedded into the
   template HTML file which needs to exist at the location $TemplateFile.
.PARAMETER MarkdownFile
   The path of markdown file to convert. The file should have
   one of the supported markdown file extensions.
.PARAMETER UseNative
   Use PowerShell's builtin converter. Use in case the GitHub
   API is not available. Needs PowerShell Core.
.PARAMETER HtmlFile
   Optional path for output HTML file.
.EXAMPLE
   Show-GitHubMarkdown "Path/to/markdown"
.EXAMPLE
   Show-GitHubMarkdown -UseNative -MarkdownFile "Path/to/markdown"
.EXAMPLE
   Show-GitHubMarkdown "Path/to/markdown" -HtmlFile "Path/to/html"
.NOTES
   Written By:
    rashil2000
#>


param(
    [Parameter(Mandatory)]
    [ValidateScript({
        (Test-Path -Path $_ -PathType Leaf) `
        -and `
        ([IO.Path]::GetExtension($_) -in '.md', '.markdown', '.mdown', '.mkdn', '.mkd', '.mdwn', '.mkdown')
    })]
    [String]$MarkdownFile,
    [Parameter(Mandatory=$false)]
    [ValidateScript({ $PSVersionTable.PSVersion.Major -gt 5 })]
    [switch]$UseNative,
    [Parameter(Mandatory=$false)]
    [string]$HtmlFile
)

$TemplateFile = 'Nice/template.html'

$ConvertedHtml = if ($UseNative) {
    (ConvertFrom-Markdown $MarkdownFile).Html
} else {
    Invoke-RestMethod https://api.github.com/markdown `
        -Method Post `
        -Body (@{text="$(Get-Content -Raw $MarkdownFile)"; mode="gfm"} | ConvertTo-Json)
}

if (-not $ConvertedHtml) {
    Write-Error "GitHub Markdown API not reachable"
    return
}

if (-not $HtmlFile) {
    $TempFile = [IO.Path]::GetTempFileName()
    $HtmlFile = $TempFile.Replace('.tmp','.html')
    Rename-Item $TempFile $HtmlFile
}

(Get-Content $TemplateFile).
    Replace("{{{DocumentTitle}}}", [IO.Path]::GetFileNameWithoutExtension($MarkdownFile)).
    Replace("{{{DocumentBody}}}", $ConvertedHtml) `
    | Out-File $HtmlFile

Invoke-Item $HtmlFile
