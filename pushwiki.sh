#! /bin/bash
pw1="${1}"
pw2="${2}"
pw3="${3}"
printf "Temp Folder "
tmpfolder=$(mktemp --directory ~/dokuwiki.XXX)
printf "${tmpfolder}\n"
printf "Copying DokuWiki\n"
cp --recursive /usr/share/dokuwiki ${tmpfolder}
printf "Naming backup "
backupname="dokuwiki_""$(date +%Y-%m-%d)"".tar.gz.gpg.sig"
printf "${backupname}\n"
printf "Compressing DokuWiki\n"
tar --gzip --create --absolute-names --file ${tmpfolder}/dokuwiki.tar.gz ${tmpfolder}/dokuwiki
printf "Symmetric encrypting of DokuWiki\n"
gpg --no-use-agent --cipher-algo AES256 --symmetric --passphrase ${pw1} --output ${tmpfolder}/dokuwiki.tar.gz.gpg ${tmpfolder}/dokuwiki.tar.gz 
printf "Signing encrypted DokuWiki\n"
gpg --no-tty --quiet --no-use-agent --output ${tmpfolder}/dokuwiki.tar.gz.gpg.sig --passphrase ${pw2} --local-user 0x57E5F195 --sign ${tmpfolder}/dokuwiki.tar.gz.gpg &> /dev/null
printf "Pushing to owncloud\n"
mv ${tmpfolder}/dokuwiki.tar.gz.gpg.sig ${tmpfolder}/${backupname}
cp ${tmpfolder}/${backupname} ~/ownCloud/
owncloudcmd ~/ownCloud ${pw3} > /dev/null 
printf "Cleaning up"
rm -rf ${tmpfolder}
printf "\nIn order to verify: gpg --verify [file]\nIn order to decrypt: gpg --output [resulting file] --decrypt [file]\n"
