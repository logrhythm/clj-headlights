#!/usr/bin/env bash

set -ex

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    exit 0
fi

if [ "$TRAVIS_BRANCH" != "master" ]; then
    exit 0
fi

git config user.name "Travis CI"
git config user.email "travis_ci@logrhythm.com"
openssl aes-256-cbc -k ${travis_key_password} -in travis-github-key.enc -out travis-github-key -d
chmod 600 travis-github-key
eval `ssh-agent -s`
ssh-add travis-github-key

rm -rf target/doc
mkdir -p target
git clone git@github.com:logrhythm/clj-headlights.git target/doc
cd target/doc
git checkout gh-pages
rm -rf ./*
cd ../..
lein codox
cd target/doc
git add .
git commit -am "New documentation for $TRAVIS_COMMIT" || true
git push origin gh-pages || true
cd ../..
