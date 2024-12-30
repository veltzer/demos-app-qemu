all: devicetree-start.dtb devicetree-phase1.dtb devicetree-phase2.dtb

devicetree-start.dtb: devicetree-start.dts
	dtc -I dts -O dtb -o $@ $<
devicetree-phase1.dtb: devicetree-phase1.dts
	dtc -I dts -O dtb -o $@ $<
devicetree-phase2.dtb: devicetree-phase2.dts
	dtc -I dts -O dtb -o $@ $<

.PHONY: clean
clean:
	rm -f *.dtb
