#!/bin/bash

# Set variables from arguments
hash=${1} && echo "hash: ${hash}"
hashfull=${2} && echo "hashfull: ${hashfull}"
currentBranch=${3} && echo "currentBranch: ${currentBranch}"
buildStatus=${4} && echo "buildStatus: ${buildStatus}"
buildId=${5} && echo "buildId: ${buildId}"
organizationName=${6} && echo "organizationName: ${organizationName}"
projectName=${7} && echo "projectName: ${projectName}"
authorCommit=${8} && echo "authorCommit: ${authorCommit}"
authorCommitEmail=${9} && echo "authorCommitEmail: ${authorCommitEmail}"
commitReference=${10} && echo "commitReference: ${commitReference}"
jobName=${11} && echo "jobName: ${jobName}"
webHookUrl=${12} && echo "webHookUrl: ${webHookUrl}"
repositoryName=${13} && echo "repositoryName: ${repositoryName}"
repositoryGroupURL=${14} && echo "repositoryGroupURL: ${repositoryGroupURL}"
fullCommit=${15} && echo "fullCommit: ${fullCommit}"
fullCurrentBranch=${16} && echo "fullCurrentBranch: ${fullCurrentBranch}"
pipelineId=${17} && echo "pipelineId: ${pipelineId}"

case "$buildStatus" in
    "Succeeded") fontColor="#007E33" ;;
    "SucceededWithIssues") fontColor="#FF8800" ;;
    "Canceled") fontColor="#212121" ;;
    "Failed") fontColor="#CC0000" ;;
esac

case "$fullCurrentBranch" in
    refs/heads/develop|refs/heads/master) message="Branch name" ;;
    refs/tags/*) message="Tag version" ;;
    *) message="Unknown" ;;
esac

body=$(cat << EOF
{
  "cards": [
    {
      "header": {
        "title": "${jobName^} Pipeline Result Available",
        "imageUrl": "https://img.icons8.com/ios/50/000000/test-results.png"
      },
      "sections": [
         {
           "widgets": [
              {
                "textParagraph": {
                  "text": "<p><font color=\"${fontColor}\">Status ${buildStatus}</font></p>"
                  }
              },
              {
                "keyValue": {
                  "topLabel": "Repository name:",
                  "content": "${repositoryName}"
                  }
              },
              {
                "keyValue": {
                  "topLabel": "Current Branch:",
                  "content": "${currentBranch}"
                  }
              },
              {
                "keyValue": {
                  "topLabel": "Commit reference:",
                  "content": "${commitReference}",
                  }
              },
              {
                "keyValue": {
                  "topLabel": "From:",
                  "content": "${authorCommit} - ${authorCommitEmail}"
                  }
              },
              {
                "keyValue": {
                  "topLabel": "Pipeline Reference:",
                  "content": "${buildId}",
                  "button": {
                    "textButton": {
                      "text": "View",
                      "onClick": {
                        "openLink": {
                          "url": "${repositoryGroupURL}/_build/results?buildId=${buildId}&view=results"
                        }
                      }
                    }
                  }
                }
              }
            ]
          }
        ]
      }
    ]
  }
EOF
)

curl \
  -s \
  -X POST \
  -H 'Content-Type: application/json' \
  "${webHookUrl}" \
  -d "$body"

