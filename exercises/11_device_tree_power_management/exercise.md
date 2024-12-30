# Power Management Exercise

## Scenario
Configure power management for a system with:
- WiFi module with multiple power states
- Display with backlight control
- SD card interface with runtime PM
- USB controller with wakeup capability

## Base Device Tree

Is in the exercise folder.

## Tasks
1. Configure WiFi power states:
   - Define operating points (voltage/frequency pairs)
   - Add power state transitions
   - Setup wake-on-WLAN

1. Configure Display power:
   - Add backlight control
   - Define power-up sequence
   - Add DPMS states

1. Configure SD card power:
   - Enable runtime PM
   - Define power-off delay
   - Add card detection wakeup

1. Configure USB power:
   - Enable remote wakeup
   - Define power states
   - Configure suspend/resume
