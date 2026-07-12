# Traffic Light FSM (iCEBreaker)

A three-state Moore FSM cycling red → green → yellow → red on timers, shown on
the two onboard LEDs. Red = red LED, green = green LED, yellow = both off. The
button acts as a reset back to red.

## Structure

This is the standard FSM template from H&H 4.6, three pieces:

- **State register** (`always_ff`) — holds the current state, updates to
  `nextstate` on each clock edge. Button resets it to RED asynchronously.
- **Next-state logic** (`always_comb`) — a case on the current state. Each state
  waits for the timer, then advances to the next. Defaults at the top of the
  block so nothing infers a latch.
- **Output logic** (assigns) — LEDs are a pure function of the current state.
  That's what makes it a Moore machine: outputs depend only on state, not inputs.

Plus a timer: a free-running counter compared against `target_cycles`, which is
set inside the same `always_comb` case — so each state carries its own duration
(red 3s, green 5s, yellow 1s). `target_cycles` is combinational on purpose: it's
a pure function of the state, so it updates the same instant the state changes
instead of lagging a cycle behind like a registered value would. Given the state,
the target is fully determined — nothing to remember, so nothing to register.

## What went wrong along the way

- Tried to make the state machine count and transition in one block at first.
  Splitting it — counter just counts, target moves the finish line, FSM just
  changes state when the timer says so — fixed most of it.
- Multiple-driver errors from assigning the same signal in more than one place
  (and from mixing ff and comb drivers on one signal). One signal, one driver.
- The button is active-low (rests at 1, drops to 0 when pressed). Getting the
  reset polarity wrong froze the counter on boot.
- States are a `typedef enum` so the code reads as RED/GREEN/YELLOW instead of
  magic bit patterns.

One note on FPGA vs ASIC: on the iCE40 the `= 0` initializers actually work
(initial values load from the bitstream), so strictly the reset isn't required
here — but explicit reset is the portable habit, since ASIC flops power up
unknown.

## Build

    make prog

Yosys → nextpnr-ice40 → icepack → iceprog. iCE40UP5K, sg48.