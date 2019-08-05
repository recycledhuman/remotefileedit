#!/bin/bash
USER="$(who | awk /console/{'print $1'} | head -1)"
SCRIPT=remotefileedit
IP={remote file server ip}
SHARE={folder on remote file server}
CHECKFILE={file in folder of remote server to check connection}
WRITEFILEA={name of file to write to for choices A}
WRITEFILEB={name of file to write to for choices B}
NOW="$(Date +"%m/%d/%Y %H:%M")"


echo "Please enter your username"
read NAME

echo "***************Starting Log****************" >> /Users/$USER/Library/Logs/$SCRIPT.log

if [[ $NAME == $USER ]]; then
		echo "User is verified" >> /Users/$USER/Library/Logs/$SCRIPT.log
	else
		echo "Error: User is not verified" && echo "User is not verified" >> /Users/$USER/Library/Logs/$SCRIPT.log
		exit 2
fi		

echo "Please enter your password"
read -s PASS

echo "Enter A for allowing or B for blocking"
read CHOICE

if [[ $CHOICE = A ]]
	then
		echo "Please enter the URL you wish to allow"
		read URLALLOW
	else
		echo "Please enter the URL you wish to block"
		read URLBLOCK
fi

echo "Is $URLALLOW $URLBLOCK a subdomain y/n"
read SUB

if [[ ! -d /Users/$USER/share ]]; then
	mkdir /Users/$USER/share
fi

mount -t smbfs //$USER:$PASS@$IP/$SHARE /Users/$USER/share

if [[ -f /Users/$USER/share/$CHECKFILE ]]; then
	echo "Connected to server" >> /Users/$USER/Library/Logs/$SCRIPT.log
		else
			echo "File is unavailable or credentials are incorrect, exiting" >> /Users/$USER/Library/Logs/$SCRIPT.log
		exit 1
fi

touch /Users/$USER/share/placeholder.txt

if [[ $URLALLOW != "" ]]
	then
		echo "You will be allowing: $URLALLOW"
		echo " Is this correct y/n"
		read CONFIRM
	else
		echo "You will be blocking: $URLBLOCK"
		echo "Is this correct y/n?"
		read CONFIRM
fi

if [[ $CONFIRM != y ]]
	then
		echo "Could not confirm URL, try again"
		exit 3
	else
		echo "URL confirmed - Proceeding" >> /Users/$USER/Library/Logs/$SCRIPT.log
fi

if [[ $URLALLOW != "" ]]
	then
		if [[ $SUB != y ]]
			then
				echo "$USER allowed $URLALLOW at $NOW" >> /Users/$USER/Library/Logs/$SCRIPT.log
				echo "*.$URLALLOW/" >> /Users/$USER/share/placeholder.txt
				echo "$URLALLOW/" >> /Users/$USER/share/placeholder.txt
			else
				echo "$USER allowed $URLALLOW subdomain at $NOW" >> /Users/$USER/Library/Logs/$SCRIPT.log
				echo "$URLALLOW/" >> /Users/$USER/placeholder.txt
		fi
	else
		if [[ $SUB != y ]]
			then			
				echo "$USER blocked $URLBLOCK at $NOW" >> /Users/$USER/Library/Logs/$SCRIPT.log
				echo "*.$URLBLOCK/" >> /Users/$USER/share/placeholder.txt
				echo "$URLBLOCK/" >> /Users/$USER/share/placeholder.txt
			else
				echo "$USER blocked $URLBLOCK at $NOW" >> /Users/$USER/Library/Logs/$SCRIPT.log
                        	echo "$URLBLOCK/" >> /Users/$USER/share/placeholder.txt
		fi
fi

if [[ $URLALLOW != "" ]]
	then
		 perl -pe 's/\r\n|\n|\r/\r\n/g' /Users/$USER/share/placeholder.txt >> /Users/$USER/share/$WRITEFILEA.txt
	else
		 perl -pe 's/\r\n|\n|\r/\r\n/g' /Users/$USER/share/placeholder.txt >> /Users/$USER/share/$WRITEFILEB.txt
fi

rm /Users/$USER/share/placeholder.txt
perl -pe 's/\r\n|\n|\r/\r\n/g' /Users/$USER/Library/Logs/urlextlist.log >> /Users/$USER/share/$SCRIPT.txt
rm /Users/$USER/Library/Logs/$SCRIPT.log

sleep 5

umount /Users/$USER/share
exit 0
