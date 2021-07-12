$MorningTrigger = New-JobTrigger -At '07:00' -Daily
$EveningTrigger = New-JobTrigger -At '19:00' -Daily
$StartupTrigger = New-JobTrigger -AtLogOn -User $Env:USERNAME -RandomDelay 00:01:00

$TestTrigger = New-JobTrigger -At '14:00' -Once

$Job = {
    if ((Get-Date).Hour -ge 7 -and (Get-Date).Hour -lt 19) {}
    else {}
}

$JobOption = New-ScheduledJobOption `
    -RunElevated `
    -StartIfOnBattery `
    -ContinueIfGoingOnBattery

Register-ScheduledJob `
    -Name 'ThemeSwitch' `
    -Trigger $MorningTrigger, $EveningTrigger, $StartupTrigger `
    -ScheduledJobOption $JobOption `
    -ScriptBlock $Job
