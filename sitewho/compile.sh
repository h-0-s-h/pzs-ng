#!/bin/sh
file="sitewho.c"

echo -n "Compiling $file : "
case `uname -s` in
 *[Bb][Ss][Dd]*)
  STATIC="-static"
  ;;
esac
gcc -O2 $STATIC -Wall -o ${file%.c} $file 2> /dev/null
if [ $? -gt 0 ]; then
 echo "[FAIL]"
 exit 2
fi
echo "[OK]"

strip ${file%.c}

if [ "`id -u`" -eq 0 ]; then
	echo ""
	echo "Installing..."
	conf="${file%.c}.conf"
	for v in glrootpath headerfile footerfile; do
	 eval $v=$(grep "^$v" $conf | awk {'print $3'})
	done

	[ ! -e $glrootpath$headerfile ] && cp -f ${headerfile##*/} $glrootpath$headerfile
	[ ! -e $glrootpath$footerfile ] && cp -f ${footerfile##*/} $glrootpath$footerfile
	for f in ${file%.c} $conf bandwidth.sh; do
	 [ ! -e $glrootpath/bin/$f ] && cp $f $glrootpath/bin/
	done
fi

echo ""
echo "Check README, if you want to learn how this works!"
echo ""
