#!/bin/bash

BRANCH_NAME="$1"

echo "**** Branch name...........: ${BRANCH_NAME} *****"
git_author_name=$(git show -s --pretty=%an)
echo "**** GIT AUTHOR NAME *****"
echo $git_author_name

if [[ "$git_author_name" != "Team DWP CI" ]]
then
    git version
    echo "**** git local *****"
    git config user.name "Team DWP CI"
    git config user.email "digitalworkplace@adeo.com"
    git config push.followTags true
    echo "**** rename branch master to main ***** "
    git branch
    git branch -m main
    git branch
    echo "**** git local *****"
    echo $PWD
    echo "**** Commande git remote *****"
    git remote -v

    echo "**** Start creating a new version.....: RUNNING *****"
    echo "**** all branches *****"
    echo "**** git branch *****"
    git branch
    echo "**** git log *****"
    git log
    echo "**** git tag *****"
    git tag
    echo "**** Create counter lines file (summary_count_lines.xml)  *****"
    pygount --format=cloc-xml --suffix=py,toml --out=summary_count_lines.xml
    export number_lines_python=$(grep "code=\"[0-9]*" test.py  -o | cut -d "\"" -f2 | tail -1)
    echo "**** TEMPORARY extract number of code python lines   *****"
    echo $number_lines_python
    sed -ie "s/python_lines_code = .*$/python_lines_code = '$number_lines_python'/" version.py
    echo "**** Modifying date version variable *****"
    export date_version=$(date '+%Y-%m-%dT%H:%M:%S')
    sed -ie "s/__version_date__ = .*$/__version_date__ =  '$date_version'/" version.py
    echo "**** running publish *****"
    semantic-release publish
    exit $?
fi


if [[ "$git_author_name" == "Team DWP CI" ]]
then
  echo "Skipping creating a new version: Author of commit is already Team DWP CI. "
fi

exit 0
