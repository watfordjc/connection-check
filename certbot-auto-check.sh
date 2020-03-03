#!/bin/sh

TEMPFILE=$(tempfile -d /tmp)
DIR="$1"

if [ ! -d "$1" ]; then
	>&2 echo "Usage: $0 directory"
fi

SERIAL_LIST=$(find -L . -maxdepth 1 -size +1M -iname '*.txt.gz' -o -iname '*.txt' | head -n1)

if [ -z "$SERIAL_LIST" ]; then
	>&2 echo "No serial list found."
	exit 1
else
	echo "Checking against $SERIAL_LIST..."
fi

for cert in $(find "$DIR" -iname '*_chain.pem'); do
	openssl x509 -checkend 7776000 -in "$cert" -noout >/dev/null
	if [ ! $? -eq 0 ]; then
		openssl x509 -checkend 0 -in "$cert" -noout >/dev/null
		if [ $? -eq 0 ]; then
			openssl x509 -serial -noout -in "$cert" | awk -F '=' '{print tolower($NF)}' >> "$TEMPFILE"
		fi
	fi

done

sort -u "$TEMPFILE" | xargs -I '{}' zgrep '{}' "$SERIAL_LIST"
if [ $RESULT -eq 2 ]; then
	>&2 echo "An error occurred using zgrep."
elif [ $RESULT -eq 1 ]; then
	echo "No affected certificates found."
fi

rm "$TEMPFILE"

