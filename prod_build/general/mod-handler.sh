mod_handler() {

MODLIST=$1
IFS=' '
for mod in $MODLIST; do
	case $mod in
		"blank") 
			sed -ibak "s/^#DAP_BLANK/DAP_BLANK/" config.pri || sed -ibak "s/^DAP_BLANK/#DAP_BLANK/" config.pri # For toggling blank mode in general scripts.
			;;
		"static")
			[[ $(echo "$PLATFORM_CANDIDATES" | grep "linux") != "" ]] && sed -ibak "/static/s/^#//" CellFrameDashboard.pro && [ ! -z "ICU_LINUX_PATH" ] && sed -ibak "s!ICU_LINUX_PATH!$ICU_LINUX_PATH!" CellFrameDashboard.pro && \
			PLATFORM_CANDIDATES=$( echo $PLATFORM_CANDIDATES | sed "s/linux\/[a-z]\+ \?//g" | sed "s/$/ linux/" | sed "s/^ //") || sed -ibak "/static/s/^unix/#unix/" config.pri #For toggling static mode
			;;
		*)
			echo "No handling required for mod $mod. Proceeding"
			;;
	esac
done
IFS='\n'
}
