#!/usr/bin/env bash
version=v$(./bin/supdock -v |awk '{print $3}')
message=$(git log --format="%s" -n 1 $CIRCLE_SHA1)
if [[ `git tag -l $version` == $version ]]; then
    echo "Tag $version already exists"
else
    go get github.com/goreleaser/goreleaser
    echo "Tagging new version $version"
    git config --global user.email "$GITHUB_EMAIL"
    git config --global user.name "$GITHUB_USERNAME"
    git tag -a "$version" -m "$message"
    git push origin "$version"
    goreleaser release --skip-validate
fi
