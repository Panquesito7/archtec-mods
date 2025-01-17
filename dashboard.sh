#!/bin/bash
# requires: jq

json=$(curl https://api.github.com/orgs/Archtec-io/repos?per_page=100)
names=$(echo $json | jq -r 'sort_by(.name) | map(select(.name != "Archtec-io")) | .[].name')

if jq -e . >/dev/null 2>&1 <<<"$json"; then
    echo "Got valid JSON"
else
    echo "Failed to parse JSON, or got false/null"
    exit 1
fi

> dashboard.md

echo "|Name|Last commit|Open issues|Open PR's|Contributors|" >> dashboard.md
echo "|---|---|---|---|---|" >> dashboard.md
for name in ${names}
do
    link="[${name}](https://github.com/Archtec-io/${name})"
    stars="![GitHub Repo stars](https://img.shields.io/github/stars/Archtec-io/${name}?style=social)"
    contributors="![GitHub contributors](https://img.shields.io/github/contributors/Archtec-io/${name})"
    last_commit="![GitHub last commit](https://img.shields.io/github/last-commit/Archtec-io/${name})"
    open_issues="![GitHub issues](https://img.shields.io/github/issues/Archtec-io/${name})"
    open_prs="![GitHub pull requests](https://img.shields.io/github/issues-pr/Archtec-io/${name})"
    echo "|${link}|${last_commit}|${open_issues}|${open_prs}|${contributors}|" >> dashboard.md
done