@echo off

set URL="https://app.circleci.com/pipelines/github/ministryofjustice/testing-circle-ci?branch="
for /f %%i in ('git rev-parse --abbrev-ref HEAD') do set CURRENT_BRANCH=%%i

cd %CUCUMBER_REPO_PATH%
git push
start "" "%URL%%CURRENT_BRANCH%"