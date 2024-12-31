# Pin Configuration Exercise

## Scenario
You have a board with limited GPIO pins and need to configure:
- SPI display (4 pins: MOSI, MISO, SCK, CS)
- I2C sensor (2 pins: SDA, SCL)
- PWM LED controller (1 pin)
All sharing the same GPIO bank.

## Base Device Tree

Is in the exercise folder.

## Tasks
1. Configure pin multiplexing:
   - SPI: GPIO 8-11
   - I2C: GPIO 2-3
   - PWM: GPIO 18

1. Set pin properties:
   - SPI pins need pull-down resistors
   - I2C pins need pull-up resistors
   - PWM pin needs no pull

1. Create device nodes:
   - SPI display (compatible="vendor,spi-display")
   - I2C temperature sensor (compatible="vendor,temp-sensor")
   - PWM LED controller

1. Handle conflicts:
   - Ensure proper pin function selection
   - Set drive strengths where needed
   - Configure pin states for sleep mode

## Validation

```bash
dtc -I dts -O dtb -o solution.dtb solution.dts
```

## Expected Skills
- Pin multiplexing configuration
- Understanding pin electrical properties
- Managing shared GPIO resources
- Device node creation and linking
