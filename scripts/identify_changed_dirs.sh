#!/bin/bash

# this script will run in GitHub Actions or Travis CICD,
# identify changed files
# and save the directories of the files
# if a condition is met,
# it will then print the array of directories

# allowed: github or travis
CI_ENV="github"
TOP_LEVEL_DIRECTORY='src'
MAIN_BRANCH_NAME='main'

if [[ $CI_ENV == "github" ]]; then
    event_type="$GITHUB_EVENT_NAME"
	commit_sha="$GITHUB_SHA"
fi

if [[ $CI_ENV == "travis" ]]; then
    event_type="$TRAVIS_event_type"
	commit_sha="$TRAVIS_COMMIT"
fi

if [[ "$event_type" == "push" ]]; then
	# collect only changed files from commit
	mapfile -t files < <(git diff-tree --no-commit-id --name-only -r "$commit_sha")
fi

if [[ "$event_type" == "pull_request" ]]; then
	# collect all changed files from commit range
	mapfile -t files < <(git diff-tree --no-commit-id --name-only -r origin/"$MAIN_BRANCH_NAME" -r "$commit_sha")
fi

# create directories list
directories=()

for file in "${files[@]}"; do
	parent_dir=$(dirname -- "$file")

	# I only want to collect files in subdirectories under a top level directory
	# provided at the top of the script, therefore the condition requires that the
	# path has a directory matching the user provided value
	if [[ $parent_dir != "." ]] && [[ $parent_dir == *"$TOP_LEVEL_DIRECTORY"* ]]; then
		directories+=("$parent_dir")
	fi
done

if [[ ${#directories[@]} -eq 0 ]]; then
	echo "no matches"
else
	printf "'%s'\n" "${directories[@]}"
	# often we want to write to a file so that another script can act on the list
	# write directories to file since arrays cannot be exported
	printf "'%s'\n" "${directories[@]}" >changed_tf_dirs.txt
fi
