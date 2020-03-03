# connection-check

This repository contains scripts to check if any of your certificates are affected by the Let's Encrypt revocation due to the CAA bug.

Simply clone this repository then follow the below instructions.

## revoked-serials-sorted.txt.gz

If you already have a copy of the caa-rechecking-incident-affected-serials.txt.gz file from Let's Encrypt, just create a symbolic link to it in the directory you've cloned the repository to, or `scp` a copy from another machine/server.

If you don't have a copy, use `git-lfs checkout` (git-lfs might need installing on your machine) to get a gzipped sorted list containing just the affected serial numbers.

The scripts will first attempt to find matches by grepping against "\*.txt.gz", falling back to "\*.txt".

## acme.sh

Placeholder one-liner: `find ~/.acme.sh -iname '*.conf' ! -iname '*.csr.conf' -print0 | xargs -0 grep Le_LinkCert | awk -F '/' '{print $NF}' | sed "s/'//" | sort -u | xargs -I '{}' zgrep '{}' *.txt.gz`
