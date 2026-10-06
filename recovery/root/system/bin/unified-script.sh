#!/system/bin/sh
#
# Set the product props for the dizi variant this is running on.
#

set_props() {
	local p
	for p in "" .odm .system .vendor .system_ext .product .bootimage; do
		resetprop "ro.product$p.model" "$model"
		resetprop "ro.product$p.brand" "Redmi"
		resetprop "ro.product$p.device" "dizi"
		resetprop "ro.product$p.name" "dizi"
	done
	resetprop ro.build.product dizi
	resetprop ro.product.marketname "Redmi Pad Pro"
	resetprop vendor.usb.product_string "Redmi Pad Pro"
}

case "$(getprop ro.boot.hwc)" in
	CN) model=2405CRPFDC ;;
	IN) model=2405CRPFDI ;;
	JP) model=2405CRPFDL ;;
	*) model=2405CRPFDG ;;
esac
set_props
exit 0
