Sillyfunction

```systemverilog
module sillyfunction
(
    input  logic a, b, c, 
    output logic y
);
assign y= ~a & ~b & ~c | a & ~b & ~c | a & ~b & c;
endmodule
```

assign statement descriebes combination logic 

~ indicates NOT
& indicates AND
| indicates OR

logic synthesis transforms HDL code into a netlist describibg the hardware (ie gates and connections) 
logic synthesizer can also perform optimizations to reduce the amount of hardware required
there is synthesizable code and testbench code
think of system in terms of blocks of combination logic, registers and finite state machines

Bitwise operatons act on single-bit signals or on multibit busses.
EXAMPLE:
INVERTER

```systemverilog
module inv(
    input  logic [3:0] a, 
    output logic [3:0] y
);
    assign y = ~a; //bitwise NOT
endmodule
```

a [3:0] represents a 4 bit bus. The bits are a[3], a[2], a[1], a[0]
this is called little endian order, because the least significant bit has the smallest bit number
we could have named  the bus a[4:1] in which case a[4] would hav ebeen most significant
or we could have used a [0:3] in which case a[0] would have been most significant (big endian order)

LOGIC GATES

```systemverilog
module gates(
    input  logic [3:0] a, b, 
    output logic [3:0] y1, y2, y3, y4, y5
);
//five different two-input logic gates on 4-bit busses
    assign y1 = a & b; //AND
    assign y2 = a | b; //OR
    assign y3 = a ^ b; //XOR
    assign y4 = ~(a & b); //NAND
    assign y5 = ~(a | b); //NOR
endmodule
```

~ ^ and | are SV operators
a, b, and y1 are operands
a combination of operators and operands such as a & b is called an expression
a complete statement such as assign y1 = a & b; is called an assignment statement
assign out = in1 op in2; is called a continuous assignment statement
system verilog IS CASE SENSITIVE

Reduction Operators
Reduction operations imply a multiple-input gate acting on a single bus
EXAMPLE: 

```systemverilog
module and8(
    input  logic [7:0] a, 
    output logic y
);
    assign y = &a; //AND reduction
    //saying just &a is the same as saying a[7] & a[6] & a[5] & a[4] & a[3] & a[2] & a[1] & a[0]
    //the output y will be 1 only if all bits of a are 1,
endmodule
```

CONDITIONAL ASSIGNMENTS
conditional assignments select the output from among alternatives based on an input called the condition
EXAMPLE: MULTIPLEXER

```systemverilog
module mux2(
    input  logic [3:0] d0, d1,
    input  logic s, 
    output logic [3:0] y
);
    assign y =s ? d1: d0; //if s is 1, then y=d1, if s is 0, then y=d0
endmodule
```

the first expression is called the condition, if the condition is 1 then the operator chooses the second expression
if the condition is 0 then the operator chooses the third expression
also called a ternary operator because it has three operands and takes in 3 inputs

4:1 MUX

```systemverilog
module mux4(
    input  logic [3:0] d0, d1, d2, d3,
    input  logic [1:0] s,
    output logic [3:0] y
);
    assign y = s[1] ? (s[0] ? d3 : d2) : ( s[0] ? d1 : d0);
endmodule
```

if s[1] is 1, then the output is either d3 or d2 depending on s[0]
if s[1] is 0, then the output is either d1 or d0 depending on s[0]

INTERNAL VARIABLES
internal variables are used only internal to the module (similar to local variables in sw)

EXAMPLE:
FULL ADDER

```systemverilog
module fulladder(
    input  logic a, b, cin,
    output logic s, cout
);
    logic p, g; //internal variables
    assign p= a ^ b;
    assign g= a & b;
    assign s = p ^ cin;
    assign cout = g | (p & cin);
endmodule
```

System Verilog operator precedence (from highest to lowest):
1. Parentheses ()
2. ~ NOT
3. *, /, % MUL, DIV, MOD
4. +, - PLUS, MINUS
5. <<, >> Logical Left/ Right Shift
6. <<<, >>> Arithmetic Left/ Right Shift
7. <, <=, >, >= Relative Comparison
8. ==, != Equality Comparison
9. & ~ & AND, NAND
10. ^, ~^ XOR, XNOR
11. |, ~| OR, NOR
12. ?: Conditional
AND HAS PREFERENCE OVER OR, so assign cout = g | p & cin; is evaluated as assign cout = g | (p & cin); 


NUMBERS
System Verilog supports binary, octal, decimal and hexadecimal numbers
format is  N'Bvalue, where N is the size in bits, B is a letter indicating the base
'b for binary, 'o for octal, 'd for decimal, 'h for hexadecimal
EXAMPLES:
3'b101: Bits: 3, Base: binary (2), Value: 5, Stored: 101
'b11: Bits: ?, Base: binary (2), Value: 3, Stored: 11 (but we don't know how many bits are stored, so we can't say for sure what the value is)
8'b11: Bits: 8, Base: binary (2), Value: 3, Stored: 00000011
8'b1010_1011: Bits: 8, Base: binary (2), Value: 171, Stored: 10101011 (underscores are ignored and can be used for readability)
3'd6: Bits: 3, Base: decimal (10), Value: 6, Stored: 110 
6'o42: Bits: 6, Base: octal (8), Value: 34, Stored: 00010010 
8'hAB: Bits: 8, Base: hexadecimal (16), Value: 171, Stored: 10101011
42: Bits: ?, Base: decimal (10), Value: 42, Stored: 00...0101010 
NOTE: IT'S BETTER TO SPECIFY THE SIZE. Exception is for '0 and '1, as they are system verilog idoms that fill all the bits with 0s and 1s respectively, so the size doesn't matter.

Z's and X's
z's are used to inidcate a floating value. z is useful for describibg a tristate buffer
x's are used to indivate an invalid logic level. helpful to track errors caused by forgetting to reset a flip-flop

TRI-STATE BUFFER

```systemverilog
module tristate (
    input  logic [3:0] a,
    input  logic en,
    output tri [3:0] y
);
    assign y = en ? a : 4'bz;
endmodule
```
y is declared as a tri rather than logc. logic signals can only have a single driver. Tristate busses can have multiple drivers, so they should be declared as a net.