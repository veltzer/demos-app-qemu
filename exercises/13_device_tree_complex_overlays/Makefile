DTS_SRC=$(shell find . -name "*.dts")
DTS_DTB=$(addsuffix .dtb, $(basename $(DTS_SRC)))

DTSO_SRC=$(shell find . -name "*.dtso")
DTSO_DTBO=$(addsuffix .dtbo, $(basename $(DTSO_SRC)))


.PHONY: all
all: $(DTS_DTB) $(DTSO_DTBO)

$(DTS_DTB): %.dtb: %.dts
	dtc -I dts -O dtb -o $@ $<
$(DTSO_DTBO): %.dtbo: %.dtso
	dtc -@ -I dts -O dtb -o $@ $<

.PHONY: clean
clean:
	rm -f *.dtb *.dtbo

.PHONY: debug
debug:
	$(info DTS_SRC is $(DTS_SRC))
	$(info DTS_DTB is $(DTS_DTB))
	$(info DTSO_SRC is $(DTSO_SRC))
	$(info DTSO_DTB is $(DTSO_DTBO))
