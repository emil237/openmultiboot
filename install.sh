#!/bin/sh
#-----------------------------------------------------------#
#       Coded By - e2TURK - http://twitter.com/e2TURK       #
#-----------------------------------------------------------#

isTR=$(grep osd.language=tr_TR /etc/enigma2/settings | grep -o tr_TR)
TR="/home/root/TR"
if [ "$isTR" == "tr_TR" ]; then
	touch $TR
fi

echo -e "\n\n"
echo -e "------------------------------------------------"
echo -e "------------- OMB ENHANCED - e2TURK ------------"
echo -e "------------------------------------------------"
echo -e "---------- https://twitter.com/e2TURK ----------"
echo -e "------------------------------------------------"

if [ -f $TR ]; then
	if [ -d /usr/lib/python3.10 ]; then
		rm -rf /usr/lib/locale/tr_TR
		mkdir -p /usr/lib/locale/tr_TR
		if [ -d /etc/openvision ]; then
			cp -R /usr/lib/locale/en_GB/LC_CTYPE /usr/lib/locale/tr_TR
		elif [ -d /usr/lib/locale/C.UTF-8 ]; then
			cp -R /usr/lib/locale/C.UTF-8/LC_CTYPE /usr/lib/locale/tr_TR
		fi
	fi
fi

[ -f $TR ] && echo -e "\n  omb enhanced kurulumu başlatıldı ! \n\n\n" || echo -e "\n  started omb enhanced installation ! \n\n\n"


CheckOS() {
[ -f $TR ] && echo -e "\n  işletim sistemi kontrol ediliyor ... \n" || echo -e "\n  checking operating system ... \n"
if [ -f /etc/opkg/opkg.conf ]; then
	OS="e2OS"
	[ -f $TR ] && echo -e "\n  veriler alınıyor, lütfen bekleyiniz ... \n" || echo -e "\n  receiving data, please wait ... \n"
	opkg update > /dev/null 2>&1
elif [ -f /etc/apt/apt.conf ]; then
	OS="dmOS"
fi
}

CheckImage() {
[ -f $TR ] && echo -e "\n  ana yazılım kontrol ediliyor ... \n" || echo -e "\n  checking main flash image ... \n"
if cat /etc/issue | grep -qo 'openatv 6.4'; then
	isImage="openATV"
elif cat /etc/issue | grep -qo 'openatv 7.0'; then
	isImage="openATV"
elif cat /etc/issue | grep -qo 'openatv 7.1'; then
	isImage="openATV"
elif cat /etc/issue | grep -qo 'openatv 6.1'; then
	isImage="openViX"
elif cat /etc/issue | grep -qo 'openatv 6.2'; then
	isImage="openViX"
elif cat /etc/issue | grep -qo 'openbh 5.1'; then
	isImage="openBH"
elif cat /etc/issue | grep -qo 'openspa 8.0'; then
	isImage="openSPA"
elif cat /etc/issue | grep -qo 'pure2 6.5'; then
	isImage="PURE2"
fi
}

CheckDevice() {
[ -f $TR ] && echo -e "\n  cihaz uyumluluğu kontrol ediliyor ... \n" || echo -e "\n  checking device compatibility ... \n"
cModel=$(opkg list openmultiboot | grep -o openmultiboot)
if [ "$cModel" == "openmultiboot" ]; then
	isDevice="OK"
else
	isDevice="NO"
fi

}

CheckOS "$@"
CheckImage "$@"
CheckDevice "$@"

if [ "$OS" == "e2OS" ]; then
	if [ "$isImage" == "openATV" ] || [ "$isImage" == "openViX" ] || [ "$isImage" == "openBH" ] || [ "$isImage" == "openSPA" ] || [ "$isImage" == "PURE2" ]; then
		if [ "$isDevice" == "OK" ]; then
			opkg install --force-reinstall --force-overwrite enigma2-plugin-extensions-openmultiboot > /dev/null 2>&1
			sleep 1
			opkg remove --force-depends enigma2-plugin-extensions-openmultiboot > /dev/null 2>&1

			if [ -d /usr/lib/enigma2/python/Plugins/Extensions/OpenMultiboot ]; then
				rm -rf /usr/lib/enigma2/python/Plugins/Extensions/OpenMultiboot
			fi

			dVER="v1.3"
			dREV="r45"
			dOMB="omb-enhanced_"$dVER"_e2turk-$dREV.tar.gz"
			dURL="https://raw.githubusercontent.com/emil237/openmultiboot/main/$dOMB"
			wget -q "--no-check-certificate" "$dURL" -O "/tmp/$dOMB"
			tar -zxf /tmp/$dOMB -C / --no-same-permissions
			rm -rf /tmp/$dOMB

			if mountpoint -q /usr/lib/enigma2/python/Plugins/Extensions/OpenMultiboot; then
				if [ -f $TR ]; then
					echo -e "\n  OMB Enhanced by e2TURK\nsadece ana yazılım üzerine kurulabiir !"
					echo -e "\n  şu an alt yazılım çalıştığı için\n  omb enhanced kurulumu iptal ediliyor ... \n\n"
				else
					echo -e "\n  OMB Enhanced by e2TURk\nwill only install on main image !"
					echo -e "\n  now that child image is running,\n  omb enhanced installation is canceling ... \n\n"
				fi
				sleep 3
				exit 1
			else
				if [ -f $TR ]; then
					echo -e "\n  cihazda ana yazılım (flash) çalışıyor ...\n\n\n  omb enhanced kurulumu devam ediyor ... \n\n"
				else
					echo -e "\n  main image is running ...\n\n\n  proceeding installation ... \n\n"
				fi
			fi

			chmod 755 /usr/lib/enigma2/python/Plugins/Extensions/OpenMultiboot/open-multiboot*.p*

			if [ -f $TR ]; then
				echo -e "\n\n  kurulum, başarıyla tamamlandı ! \n"
				sleep 2
				echo -e "  sistem yeniden başlatılıyor ... \n"
			else
				echo -e "\n\n  installation, completed successfully ! \n"
				sleep 2
				echo -e "  restarting enigma2 system ... \n"
			fi

			echo -e "------------------------------------------------"
			echo -e "------------- OMB ENHANCED - e2TURK ------------"
			echo -e "------------------------------------------------"
			echo -e "---------- https://twitter.com/e2TURK ----------"
			echo -e "------------------------------------------------"
			echo -e "\n\n"

			sleep 1
			rm -rf $TR
			sleep 2
			killall -9 enigma2
			exit 0
		else
			[ -f $TR ] && echo -e "\n\n\n  cihazınız openmultiboot ile uyumlu değil ! \n\n  kurulum iptal ediliyor ... \n\n" || echo -e "\n\n\n  your device is not compatible with openmultiboot ! \n\n  installation canceling ... \n\n"
			sleep 1
			exit 1
		fi
	else
		[ -f $TR ] && echo -e "\n\n\n  kullandığınız ana (flash) yazılım desteklenmiyor, \n  desteklenen yazılımların listesi\n  1) openATV 6.4 , openATV 7.0 , openATV 7.1 \n  2) openViX 6.1 , openViX 6.2 \n  3) openBH 5.1 \n  4) openSPA 8.0 \n  5) PURE2 6.5 \n  bunlardan birini cihazınıza yükleyip tekrar deneyin ! \n\n" || echo -e "\n\n\n  your flash image is not supported, \n  list of supported images\n  1) openATV 6.4 , openATV 7.0 , openATV 7.1 \n  2) openViX 6.1 , openViX 6.2 \n  3) openBH 5.1 \n  4) openSPA 8.0 \n  5) PURE2 6.5 \n  install one of these on your device and try again ! \n\n"
		sleep 1
		exit 1
	fi
elif [ "$OS" == "dmOS" ]; then
	[ -f $TR ] && echo -e "\n\n\n  işletim sistemi desteklenmiyor ! \n  openATV , openViX , openBH , openSPA , PURE2 yazılımının \n  güncel sürüm olanlarından birini kullanın ! \n\n" || echo -e "\n\n\n  OS not supported, use one of latest versions of \n  openATV , openViX , openBH , openSPA , PURE2 images ! \n\n"
	sleep 1
	exit 1
else
	[ -f $TR ] && echo -e "\n\n\n  işletim sistemi desteklenmiyor ! kurulum iptal ediliyor ... \n\n" || echo -e "\n\n\n  OS not supported ! installation canceling ... \n\n"
	sleep 1
	exit 1
fi
exit 0
