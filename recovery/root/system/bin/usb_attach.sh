#!/system/bin/sh
# dizi: the dwc3 controller can miss the cable attach and stay "not attached"
# until the cable is replugged. Cycling the controller mode re-runs the attach.
# Started whenever the gadget config changes (adb, mtp,adb, fastboot).
udc=/sys/class/udc/a600000.dwc3/state
mode=/sys/devices/platform/soc/a600000.ssusb/mode

for i in 1 2 3 4 5 6; do
	sleep 5
	[ "$(cat $udc)" = configured ] && exit 0
	echo none > $mode
	sleep 2
	echo peripheral > $mode
done
