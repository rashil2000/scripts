#!/usr/bin/env pwsh

# This script runs through an hourly cron job.
# It checks for any new commits on remote, pulls them in
# if they are ahead, and restarts the production server
# with the updated codebase.
# Also, a notification regarding the latest changes is
# sent on a dedicated Slack channel.

Set-Location ~/blogger/

/usr/bin/git remote update

$commitsAheadCommand = /usr/bin/git log HEAD..origin/master --oneline

if ($commitsAheadCommand) {
  /usr/bin/git pull origin master

  /usr/local/bin/npm install

  Set-Location ~/blogger/functions/
  /usr/local/bin/npm install

  Set-Location ~/blogger/
  /usr/local/bin/npm run build

  [String]$deployMessage = /usr/bin/git log --pretty='format:%Creset%s' --no-merges -n 1
  /usr/local/bin/firebase deploy -m $deployMessage

  [String]$slackText = ''

  if ($commitsAheadCommand -is [Object[]]) {
    $msgCommand = /usr/bin/git log --pretty='format:%Creset%s' --no-merges -n $commitsAheadCommand.Length

    $slackText = '"_'
    for ($i = 0; $i -lt $msgCommand.Length - 1; $i++) {
      $slackText = $slackText + $msgCommand[$i] + '_\n_'
    }
    $slackText = $slackText + $msgCommand[$i] + '_"'
  }
  else {
    $msgCommand = /usr/bin/git log --pretty='format:%Creset%s' --no-merges -n 1

    $slackText = '"_' + $msgCommand + '_"'
  }

  $body = @"
  {
    "text": "Redeployment to Firebase complete",
    "blocks": [
        {
              "type": "section",
              "text": {
                      "type": "mrkdwn",
                      "text": "Redeployment to Firebase complete."
              }
        },
        {
              "type": "section",
              "text": {
                      "type": "mrkdwn",
                      "text": " - Changes: "
              }
        },
        {
              "type": "section",
              "text": {
                      "type": "mrkdwn",
                      "text": $slackText
              }
        },
        {
              "type": "section",
              "text": {
                      "type": "mrkdwn",
                      "text": "Visit <https://github.com/rashil2000/blogger/commits/master|github.com/rashil2000/blogger/commits/master> for a complete list of commits."
              }
        }
    ]
  }
"@

  Invoke-RestMethod $Env:SLACK_HOOK_URL `
    -Method Post `
    -ContentType application/json `
    -Body $body
} else {
  $body = @"
  {
    "text": "No redeployment to Firebase",
    "blocks": [
        {
              "type": "section",
              "text": {
                      "type": "mrkdwn",
                      "text": "No redeployment to Firebase."
              }
        },
        {
              "type": "section",
              "text": {
                      "type": "mrkdwn",
                      "text": "_No upstream changes._"
              }
        },
        {
              "type": "section",
              "text": {
                      "type": "mrkdwn",
                      "text": "Visit <https://github.com/rashil2000/blogger/commits/master|github.com/rashil2000/blogger/commits/master> for a complete list of commits."
              }
        }
    ]
  }
"@

  Invoke-RestMethod $Env:SLACK_HOOK_URL `
    -Method Post `
    -ContentType application/json `
    -Body $body
}
