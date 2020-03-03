#!/bin/sh

SERIAL_LIST=$(find -L . -maxdepth 1 -size +1M -iname '*.txt.gz' -o -iname '*.txt' | head -n1)

if [ -z "$SERIAL_LIST" ]; then
	>&2 echo "No serial list found."
	exit 1
else
	echo "Checking against $SERIAL_LIST..."
fi

find ~/.acme.sh -iname '*.conf' ! -iname '*.csr.conf' -print0 | xargs -0 grep Le_LinkCert | awk -F '/' '{print $NF}' | sed "s/'//" | sort -u | xargs -I '{}' zgrep '{}' "$SERIAL_LIST"
RESULT=$?

if [ $RESULT -eq 2 ]; then
	>&2 echo "An error occurred using zgrep."
elif [ $RESULT -eq 1 ]; then
	echo "No affected certificates found."
fi
