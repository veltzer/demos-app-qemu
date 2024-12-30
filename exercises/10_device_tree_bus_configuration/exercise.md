# Bus Configuration Exercise

## Scenario
Configure an I2C bus with multiple devices and an SPI bus with shared interrupt line:
- I2C Bus: Temperature sensor, EEPROM, and RTC
- SPI Bus: Flash memory and ADC with shared interrupt

## Base Device Tree

## Tasks
1. Configure I2C bus:
   - Temperature sensor (addr: 0x48) with 12-bit resolution
   - EEPROM (addr: 0x50) with 32K storage
   - RTC (addr: 0x68) with backup battery
   - Set bus frequency to 400KHz
   - Configure timing parameters

1. Configure SPI bus:
   - Flash memory (CS0) with 4MB storage
   - ADC (CS1) with 8 channels
   - Shared interrupt on GPIO4
   - Set maximum speed to 10MHz

1. Handle shared resources:
   - Configure interrupt handling
   - Set up chip selects
   - Define transfer modes

## Validation

```bash
dtc -I dts -O dtb -o test.dtb board.dts
```
