# Blink 1 Hz

First hardware bringup on the iCEBreaker FPGA (Lattice iCE40UP5K). Blinks the
onboard red LED at exactly 1 Hz using a clock divider from the 12 MHz system clock.

## Design

The 12 MHz clock is divided down by counting 6,000,000 cycles (0.5 seconds) and
toggling the LED state each time the count is reached. Counting to 6,000,000
gives a half-second half-period, so the full on-off cycle is exactly 1 second.
The onboard LED is active-low, so the output is inverted (`LEDR_N = ~state`).

## Build & program

​```
make        # build bitstream
make prog   # program the board
​```

## Toolchain

Yosys (synthesis) → nextpnr-ice40 (place & route) → icepack (bitstream) →
iceprog (programming). Open-source iCE40 flow, no proprietary tools.