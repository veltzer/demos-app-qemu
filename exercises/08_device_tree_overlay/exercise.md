# Device Tree Overlay Exercise

## Base Device Tree

Is in the exercise folder.
```

## Tasks
1. Create an overlay to enable UART0:
   - Enable the UART by changing status to "okay"
   - Set clock frequency to 48MHz
   - Configure for 115200 8N1

2. Add a device connected to UART:
   - GPS module at 9600 baud
   - Define protocol parameters
   - Add required properties

## Expected Output Format
```dts
/dts-v1/;
/plugin/;

&{/} {
    /* Your overlay code here */
};
```

## Validation
```bash
dtc -I dts -O dtb -o test.dtbo overlay.dts
```

## Hints
- Use /plugin/ directive for overlays
- Reference nodes with & symbol
- Use status = "okay" to enable devices
