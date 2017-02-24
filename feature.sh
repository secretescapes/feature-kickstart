#!/bin/bash

jira_file_path="$HOME/.jira"

#Get jira id from param
jira_id=$1
if [ -z "$jira_id" ]
then
	echo "Please, provide a jira id"
	exit 1	
fi

#Get credentials or create them
if [ ! -f $jira_file_path ]; then
	echo "Jira host:"
	read jira_host
    echo "Jira username:"
    read username
    echo "Jira password:"
    read -s password
    `echo -n $username:$password | base64 >> $jira_file_path`
    `echo $jira_host >> $jira_file_path`
fi

jira_key=`sed -n '1p' $jira_file_path`
jira_host=`sed -n '2p' $jira_file_path`

echo "Fetching jira info for $jira_id..."
json=`curl  -s -X GET -H "Authorization: Basic $jira_key" -H "Content-Type: application/json" "$jira_host/rest/api/2/issue/$jira_id?fields=summary"`
key=`echo $json|jq '.key'| sed -r 's/ /_/g' | sed -r 's/[^\.0-9a-zA-Z_\-]//g'`
summary=`echo $json | jq '.fields.summary' | sed -r 's/ /_/g' | sed -r 's/[^\.0-9a-zA-Z_\-]//g'`

if  [ -z "$key" ] || [ -z "$summary" ] || [ $key = "null" ] || [ $summary = "null" ]
then
	echo "Unknown jira issue or invalid credentials"
	exit 1
fi

branch_name=$key-$summary
echo "Creating branch $branch_name"
git checkout -b $branch_name
git push --set-upstream origin $branch_name
