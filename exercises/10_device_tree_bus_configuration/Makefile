DTS_SRC=$(shell find . -name "*.dts")
DTS_DTB=$(addsuffix .dtb, $(basename $(DTS_SRC)))


.PHONY: all
all: $(DTS_DTB)

$(DTS_DTB): %.dtb: %.dts
	dtc -I dts -O dtb -o $@ $<

.PHONY: clean
clean:
	rm -f *.dtb *.dtbo

.PHONY: debug
debug:
	$(info DTS_SRC is $(DTS_SRC))
	$(info DTS_DTB is $(DTS_DTB))
