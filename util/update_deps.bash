#!/usr/bin/env bash

# This script updates each non-stdlib, non-yyf330 dependency to its most recent
# commit. It can be invoked to aid in debugging after a dependency-related
# failure on continuous integration.

function deps {
	go list -deps -f '{{if and .DepOnly (not .Standard)}}{{.ImportPath}}{{end}}' ./...
}

function unique_repos {
	cut -d '/' -f-3 | sort | uniq
}

function not_gokit {
	grep -v 'yyf330/kit'
}

function go_get_update {
	while read d
	do
		echo $d
		go get -u $d/... || echo "failed, trying again with master" && cd $GOPATH/src/$d && git checkout master && go get -u $d
	done
}

deps | unique_repos | not_gokit | go_get_update
