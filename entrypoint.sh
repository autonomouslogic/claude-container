#!/bin/bash -e

echo Entrypoint
id

set -x

USER=appuser
useradd -m -u $CLAUDE_USER_ID $USER
su $USER -c "pwd"
su $USER -c "ls -al"
su $USER -c "ls -al /home/appuser"
su $USER -c "ls -al /home/appuser/.claude"
su $USER -c "claude $@"

exit

echo $HOME
id
pwd
touch test
ls -l test

#which claude

#claude "$@"
