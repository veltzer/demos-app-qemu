# Complex Device Tree Overlays Exercise

## Base Device Tree

Is in the exercise folder.

## Tasks
1. Create parameterized overlays:
   - Display overlay (supports different resolutions: 800x480, 1024x600)
   - Audio overlay (configurable sampling rates: 44.1kHz, 48kHz)

1. Handle overlay conflicts:
   - I2C1 pins shared between display and audio
   - SPI pins shared with other interfaces

1. Create overlay dependencies:
   - Audio requires display overlay
   - Both require pinctrl configuration

## Validation
Test with:

```bash
# Compile overlays
dtc -@ -I dts -O dtb -o display.dtbo display.dts
dtc -@ -I dts -O dtb -o audio.dtbo audio.dts

# Test parameters
fdtoverlay -i base.dtb -o test.dtb display.dtbo audio.dtbo
```
