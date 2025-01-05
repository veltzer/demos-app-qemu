.PHONY: all
all: basic.dtb uart-gps.dtbo

basic.dtb: basic.dts
	dtc -I dts -O dtb -o $@ $<
uart-gps.dtbo: overlay.dts
	dtc -I dts -O dtb -o uart-gps.dtbo overlay.dts

.PHONY: apply
apply:
	dtoverlay basic.dtb uart-gps.dtbo -o final.dtb

.PHONY: clean
clean:
	rm -f *.dtb *.dtbo
