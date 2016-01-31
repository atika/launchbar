#!/bin/sh

# LaunchBar Action Script

for ARG in "$@"; do
    if [[ -a $ARG ]]; then
    	apppath="$ARG"
    	appname=$(basename "$ARG" | perl -p -e "s/\.app//")
    	osascript -e "ignoring application responses" -e "tell application \"$appname\" to quit saving yes" -e "end ignoring"
    	(sleep 3 && open -a "$appname")&

    	echo "{\"title\":\"Reloaded $# apps.\"}"
    else
    	echo "{\"title\":\"Please specify a app to reload\"}"
    fi
done
