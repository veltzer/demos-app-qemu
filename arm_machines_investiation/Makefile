ALL:=main.eabi.elf main.eabihf.elf

.PHONY: all
all: $(ALL)

main.eabi.elf: main.c
	arm-linux-gnueabi-gcc -static $< -o $@

main.eabihf.elf: main.c
	arm-linux-gnueabihf-gcc -static $< -o $@

.PHONY: clean
clean:
	rm -f $(ALL)

.PHONY: show
show:
	file *.elf
