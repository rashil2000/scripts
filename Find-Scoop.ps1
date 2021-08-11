#!pwsh
<#PSScriptInfo
.VERSION 1.0
.GUID 410c7a68-d6f3-4a81-b86a-063ac0b6616d
.AUTHOR Rashil Gandhi
.COMPANYNAME
.COPYRIGHT
.TAGS scoop find search bucket apps
.LICENSEURI
.PROJECTURI
.ICONURI
.REQUIREDMODULES PSSQLite
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
.PRIVATEDATA
#>

<#
.SYNOPSIS
	Find scoop apps.
.DESCRIPTION
	Easily find scoop apps on entire GitHub - that too in blazing fast speed.
.PARAMETER Name
	Name of the app(s).
.PARAMETER Description
	Some string to search in the description of app(s).
.PARAMETER Version
	Version of the app(s).
.PARAMETER Bucket_Repo
	Specify a search string in a particular bucket.
.PARAMETER Table
	This is by default set to 'app'. Set it to 'bucket' to search for buckets.
.PARAMETER ForceUpdate
	The database file will get updated if the script finds it to be older than 24 hours. Set this to '$true' to force an update.
.EXAMPLE
	PS C:\> Find-Scoop rust
	Search for all apps that contain the term `rust` in the name
.EXAMPLE
	PS C:\> Find-Scoop -Description golang
	Search for all apps that contain the term `golang` in the description
.EXAMPLE
	PS C:\> Find-Scoop -Table bucket -Bucket_Repo java
	Search for all buckets that contain the term `java` in their name
.EXAMPLE
	PS C:\> Find-Scoop -Bucket_Repo https://github.com/naderi/scoop-bucket vim
	Search for all apps that contain the term `vim` in the name, in the bucket pointed to by the GitHub URL
.LINK
  Written By: rashil2000
	This script uses `scoop-directory.db` from https://github.com/zhoujin7/crawl-scoop-directory
	The discussion can be found here https://github.com/rasa/scoop-directory/issues/19#issuecomment-757476563
  It might not work as expected if that database file goes down
#>


param(
  [String]$Name,
  [String]$Description,
  [String]$Version,
  [String]$Bucket_Repo,
  [String]$Table = 'app',
  [Switch]$ForceUpdate = $false
)

$DBFile = "$Env:DATA_DIR\Projects\Random\scoop_directory.db"

if ($Table -eq 'bucket') {
  if (!($Bucket_Repo)) {
    Write-Host "`nEnter bucket repository query.`n" -ForegroundColor Red
    return
  }
  $query = "SELECT bucket_repo,apps,updated,stars FROM bucket WHERE bucket_repo LIKE `"%$Bucket_Repo%`" ORDER BY apps DESC;"
} else {
  if (!($Name -or $Description)) {
    Write-Host "`nEnter at least one of name or description.`n" -ForegroundColor Red
    return
  }
  $query = "SELECT name,version,bucket_repo,description FROM app WHERE name LIKE `"%$Name%`" AND description LIKE `"%$Description%`" AND version LIKE `"%$Version%`" AND bucket_repo LIKE `"%$Bucket_Repo%`" ORDER BY version DESC;"
}

if (!(Test-Path $DBFile) -or ((Get-Date) - (Get-Item $DBFile).LastWriteTime).TotalHours -ge 24 -or $ForceUpdate) {
  Invoke-WebRequest 'https://raw.githubusercontent.com/zhoujin7/crawl-scoop-directory/master/scoop_directory.db' -UseBasicParsing -OutFile $DBFile
  Write-Host "`nUpdated database - $DBFile.`n" -ForegroundColor Green
}

return Invoke-SqliteQuery -Database $DBFile -Query $query | Sort-Object name, bucket_repo, version
