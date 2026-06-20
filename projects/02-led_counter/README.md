# 02 — 2-Bit LED Counter

A 2-bit binary counter displayed on the iCEBreaker's two onboard LEDs.
Counts 00 → 01 → 10 → 11 → 00, advancing once per second.

## What it does

A free-running counter divides the 12 MHz system clock down to a 1 Hz
enable pulse. A separate 2-bit counter increments only when that pulse
fires, so the LEDs step through all four states at one step per second.

## Design notes

**Enable-pulse pattern, not a divided clock.** The divider doesn't
generate a new slower clock — it generates a one-cycle-wide enable that
gates the counter. Everything in the design runs on the single 12 MHz
clock. This avoids clock-gating and keeps the design on one clock domain,
which is the correct way to handle slow events on an FPGA.

**Active-low LEDs.** The onboard LEDs are wired active-low (the `_N`
suffix in the constraints). The counter value is inverted at the output:
`assign LEDR_N = ~count[0];`. Driving a pin low turns its LED on.

**Counter width does the wrapping.** `count` is 2 bits, so 3 + 1 wraps to
0 automatically — no explicit reset condition needed.

## Build and run

Requires the open-source iCE40 toolchain (yosys, nextpnr-ice40,
icestorm). With the iCEBreaker connected over USB:

    make        # synthesize, place/route, generate bitstream
    make prog   # program the board

## Result

Verified on hardware. Red LED (LSB) and green LED (MSB) display the
2-bit count, cycling through 00–01–10–11 at 1 Hz.

## Files

- `counter_leds.sv` — RTL
- `icebreaker.pcf` — pin constraints
- `Makefile` — build and program targets