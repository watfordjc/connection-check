# connection-check

This repository contains scripts to check if any of your certificates are affected by the Let's Encrypt revocation due to the CAA bug.

Simply clone this repository then follow the below instructions.

## revoked-serials-sorted.txt.gz

If you already have a copy of the caa-rechecking-incident-affected-serials.txt.gz file from Let's Encrypt, just create a symbolic link to it in the directory you've cloned the repository to, or `scp` a copy from another machine/server.

If you don't have a copy, use `git-lfs checkout` (git-lfs might need installing on your machine) to get a gzipped sorted list containing just the affected serial numbers.

The scripts will first attempt to find matches by grepping against "\*.txt.gz", falling back to "\*.txt".

## acme.sh

If you use acme.sh, running `./acme-sh-check.sh` will scan your ~/.acme.sh/ directory for any certificate issuance configuration files, extracting from the Le_LinkCert line the latest serial number for that certificate.

The script then scans for the serial numbers in the list of revoked serial numbers, outputting either a list of affected serial numbers or a message (zgrep error/no affected certificates found).

For any affected certificates, you can modify the `Le_NextRenewTime` line in the ~/.acme.sh/domain/domain.conf or ~/.acme.sh/domain_ecc/domain.conf file to a unix timestamp in the past, such as `Le_NextRenewTime='1583200000'`, and then manually run the cron command.

## certbot-auto

If you use certbot-auto, running `./certbot-auto-check.sh DIRECTORY` will scan DIRECTORY for any files matching "\*_chain.pem", check for certificates expiring between now and 90 days time, and extract the serial numbers of those that match these conditions.

The script then scans for the serial numbers in the list of revoked serial numbers, outputting either a list of affected serial numbers or a message (zgrep error/no affected certificates found).
