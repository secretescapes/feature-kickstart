# feature-kickstart
Bash script that given a jira issue id, creates a git branch with an appropriate name and pushes it to origin

#Install
* Download the script and place it in a directory that is included in your $PATH, like $HOME/bin

#Usage
* Just type `feature.sh [jira_id]` (`feature.sh DEV-1234`)
* The first time the command is executed, it will ask for the jira host (e.g https://companyname.atlassian.net), your username and password. It will create a file (`.jira`) in your home directory with this information (password and username are stored as a base64 string)
* Then the script will take the title of the jira ticket and replace spaces with `"_"` and will remove non alphanumeric character. With that, it will create a new git branch, check it out, and push to origin.

