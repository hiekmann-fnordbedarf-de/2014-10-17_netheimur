#! /bin/bash
pw1="${1}" # encryption password
pw2="${2}" # pgp key password
pw3="${3}" # owncloud user:password @ owncloud server

# files
mytar="/home/one/Downloads/dokuwiki_$(date +%Y-%m-%d).tar.gz"
mykey="0x823AA1C0"

printf "Copying DokuWiki\n"
cd /var/lib/
sudo tar --create --same-owner --same-permissions --file "${mytar}" dokuwiki
sudo chown one:one "${mytar}"

printf "Encrypting DokuWiki\n"
gpg --no-use-agent --cipher-algo AES256 --symmetric --passphrase ${pw1} --output ${mytar}.gpg ${mytar} 

printf "Signing DokuWiki\n"
gpg --no-tty --quiet --no-use-agent --output ${mytar}.gpg.sig --passphrase ${pw2} --local-user "${mykey}" --sign ${mytar}.gpg # &> /dev/null

printf "Pushing to owncloud\n"
cp ${mytar}.gpg.sig ~/ownCloud/dokuwiki/
owncloudcmd ~/ownCloud owncloud://${pw3}/remote.php/webdav/ &> /dev/null 


printf "Cleaning up\n"
trap "{ rm -rf ${mytar}* ; exit 255; }" EXIT

printf "\nVerfication of public key: gpg --verify [file]\nDecryption: gpg --output [resulting file] --decrypt [file]\nRestoring DokuWiki: replace dokuwiki folder with decrypted one. Set permissions\n"
