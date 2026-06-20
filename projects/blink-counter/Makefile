# Project config — change these per project
TOP = blink_1hz
PCF = icebreaker.pcf
SRC = blink_1hz.sv

# iCE40UP5K on iCEBreaker
DEVICE = up5k
PACKAGE = sg48

# Build the bitstream
$(TOP).bin: $(SRC)
	yosys -p "synth_ice40 -top $(TOP) -json $(TOP).json" $(SRC)
	nextpnr-ice40 --$(DEVICE) --package $(PACKAGE) --json $(TOP).json --pcf $(PCF) --asc $(TOP).asc
	icepack $(TOP).asc $(TOP).bin

# Program the board
prog: $(TOP).bin
	iceprog $(TOP).bin

# Remove generated files
clean:
	rm -f $(TOP).json $(TOP).asc $(TOP).bin

.PHONY: prog clean