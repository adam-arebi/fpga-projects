# Button Counter (iCEBreaker)

A 2-bit counter shown on the two onboard LEDs, advanced one step per button
press: 00 → 01 → 10 → 11 → repeat. The point of the project isn't the counter —
it's the input-conditioning pipeline needed to turn a raw mechanical button into
a single clean event per press.

## What it does

Press the onboard button, the count goes up by one. Each press is registered
exactly once regardless of how long the button is held or how badly the contacts
bounce.

`count[0]` drives the red LED, `count[1]` the green (both active-low).

## How it works

Four blocks, all clocked on the 12 MHz `CLK`, all running every cycle. Signal
flows through them in series:

    BTN_N → [synchronizer] → synced → [debouncer] → clean → [edge detect] → press_pulse → [counter] → count → LEDs

1. **Synchronizer** — two flip-flops in series. `BTN_N` is asynchronous to the
   clock, so sampling it directly risks metastability. The first flop may catch a
   transition mid-flight; the second samples a cycle later, after it has settled.
   Output `synced` is safe to use. The `~` inverts active-low `BTN_N` so `synced`
   is 1 when pressed.

2. **Debouncer** — mechanical contacts chatter for a few ms on each press. A
   stability timer (`db_count`) measures how long `synced` has disagreed with the
   currently-accepted value `clean`. Any bounce that flips the input back resets
   the timer to 0, so chatter can never accumulate. Only after `synced` holds its
   new value continuously for `DB_MAX` cycles (~10 ms) does `clean` update. Result:
   `clean` makes one clean transition per real press.

3. **Edge detector** — `clean_prev` holds `clean` from the previous cycle.
   `press_pulse = clean & ~clean_prev` is high for exactly one cycle at the rising
   edge (pressed now, not pressed last cycle). Turns a held level into a single
   one-cycle event.

4. **Counter** — increments only on the cycle `press_pulse` is high. `[1:0]`
   width wraps 3 → 0 automatically.

## Timing math

- `DB_MAX = 120_000` — 10 ms × 12 MHz = 120,000 cycles.
- `db_count` is 17 bits — smallest width that holds 120,000 (2^17 = 131,072).

## Build

    make prog

Yosys (synth) → nextpnr-ice40 (place & route) → icepack → iceprog. Targets
iCE40UP5K, sg48 package. Pins in `icebreaker.pcf`.

## Notes / next

- Registers rely on iCE40 power-up initialization rather than an explicit reset.
  Add a reset on the next project.
- The synchronizer, debouncer, and edge detector are reusable primitives — UART
  RX and the comms modules in Phase B reuse all three.