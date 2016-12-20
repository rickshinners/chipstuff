#!/bin/sh

newhostname=$1
if [[ -z "$newhostname" ]]; then
	>&2 echo "You must supply a new hostname in the command line arguments"
	exit 1
fi

if [[ ! -f /etc/hostname ]]; then
	>&2 echo "/etc/hostname not found"
	exit 1
fi
hostname=`cat /etc/hostname`
if [[ -z "$hostname" ]]; then
	>&2 echo "/etc/hostname is empty"
	exit 1
fi

echo "Changing hostname from \"$hostname\" to \"$newhostname\""

echo $newhostname > "/etc/hostname"
retval=$?
if [[ $retval -ne 0 ]]; then
	>&2 echo "there was a problem setting /etc/hostname"
	exit 1
fi

sed -i "s/127.0.0.1\t$hostname/127.0.0.1\t$newhostname/g" /etc/hosts
retval=$?
if [[ $retval -ne 0 ]]; then
	>&2 echo "There was a problem update /etc/hosts"
	exit 1
fi

/etc/init.d/avahi-daemon restart
