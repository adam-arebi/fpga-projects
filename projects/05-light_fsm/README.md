# PWM Breathing LEDs (iCEBreaker)

Two onboard LEDs breathing in opposite phase — as red fades up to full bright,
green fades down to dim, and they cross in the middle. Built on a basic PWM core.

## What it is

A digital pin can only be full-on or full-off, never half. But switch it on and
off faster than the eye can follow and you only see the average — on 50% of the
time looks half-bright, 90% looks nearly full. That fraction is the duty cycle.
Sweep the duty slowly up and down and you get a breathing effect.

The core is three parts: a fast counter that free-runs 0 to 8191 and wraps by
overflow (8191 = 2^13 - 1, so it wraps on its own), a comparator
`count < duty` that turns the LED on while the counter is below the duty value,
and a slow sweep that walks duty up and down once per counter wrap so the change
is slow enough to see.

## The bug

First version ramped up to full brightness and then stuck there — never came back
down. The sweep flipped direction right at the top value (duty == 8191). Reason was the
non-blocking assignment. In a clocked block every line reads the values from the
start of the cycle and all the updates happen together at the edge. So on the cycle
duty hit 8191, the direction flip got scheduled but the line that steps duty still
read the old direction (up) and did duty + 1. On a 13-bit register 8191 + 1 wraps
to 0, then next cycle it underflows back, and it just bounces across the boundary
forever, and so it froze at bright.

Fix was to turn around one short of the limits and flip direction at 8190 and at 1
instead of 8191 and 0. That gives the direction change a cycle to take effect before
duty reaches a value where +1 or -1 would wrap.

## Part 2: Two LEDs, opposite phase

The second version drives both LEDs off the *same* counter and the same swept duty.
Only difference is green compares against the inverted duty:

    assign LEDR_N = ~(count < duty_red);
    assign LEDG_N = ~(count < (pwmMAX - duty_red));

So green's brightness is always pwmMAX - red's. No second counter or second sweep —
green is derived from red, which means they can't drift out of sync. One fast carrier,
two channels with their own duty. That's basically how a real multi-channel PWM
peripheral (RGB, multi-motor) works.

## Build

    make prog

Yosys → nextpnr-ice40 → icepack → iceprog. iCE40UP5K, sg48.