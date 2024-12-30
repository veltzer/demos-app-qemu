# Interrupt Handling Exercise

## Base Device Tree

Is in the exercise folder.

## Tasks
1. Configure GPIO as interrupt controller:
   - Support GPIO interrupts
   - Configure interrupt parent
   - Set up interrupt cells

1. Add shared interrupt handling:
   - Two I2C devices sharing GPIO4
   - One SPI device using GPIO5
   - Configure interrupt types

1. Set up interrupt hierarchy:
   - GPIO controller under GIC
   - Configure interrupt routing
   - Set interrupt priorities

## Expected Output
- Working interrupt configuration
- Proper shared interrupt handling
- Complete interrupt hierarchy
