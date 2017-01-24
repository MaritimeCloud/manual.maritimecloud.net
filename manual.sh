#!/bin/bash

if [ "$1" = "pdf" ]; then
    cd asciidoc
    asciidoctor-pdf -r asciidoctor-diagram manual.asciidoc -D ../target -a imagesdir=../images/
    cd ..
    exit
elif [ "$1" = "html" ]; then
    asciidoctor -r asciidoctor-diagram asciidoc/manual.asciidoc -D target
    exit
elif [ "$1" = "site" ]; then
    echo "Checking for changes to the manual"
    git status
    if ! git diff-index --quiet HEAD --; then
        echo "There are uncommitted changes"
        exit 1
    fi
    rm -rf target/
    asciidoctor -r asciidoctor-diagram asciidoc/manual.asciidoc -D target
    mkdir -p target/images
    cp images/*.png target/images/
    
    git checkout gh-pages
    cp target/manual.html ../manual/index.html
    mkdir -p ../identity/images
    cp target/images/* ../manual/images/
    git add ../manual/index.html
    git add ../manual/images/*
    git commit -m "update manual"
    git push
    git checkout master
    exit   
elif [ -z "$1" ]; then 
    echo Usage: $0 target
    echo where target is:
else
    echo Unknown target: "$1"
    echo Valid targets are:
fi

echo "  pdf        Generates documentation in pdf"
echo "  html       Generates documentation in html"

