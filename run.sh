#!/usr/bin/bash
if [ ! -f ./search ]; then
	make
fi

if [ "$#" -lt 1 ]; then
	echo "Entrt directory to search.";
else
	if [ ! -d $1 ];then
		echo "The argument must be directory."
	else
		if [ -d $1_change ]; then
			rm -rf $1_change
		fi
		cp -r $1 $1_change
		./search $1_change | perl -n smali_injection.pl;
	fi
fi
