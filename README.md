# ARASM REFERENCE

### Syntax and program structure
The program has to contain a "main" block!
That block sets the entry point, obviously.

Example:

    main:
    mvw $88 $100

A command statement looks like this:

    command arg1 arg2 arg3 ... argN

The program is divided into sections using ```section name + ":"```.
The sections are used for yielding in branching commands.

Example:

    a:
    lof $2093550
    mvw $88 $100

    main:
    dne $2093550 0 .a

Numeric literals are prefixed with a ```$``` if they are formatted as hexadecimals.
References to program sections are prefixed with a ```.```(dot).


### Command reference:

#### Symbol Key
    "Offset" - A code-engine register used to hold an address offset.
    "Stored" - A code-engine register used to store data, also known as accumulator.

#### _32bit write_
Syntax: ```mvd <src> <dest>```
32bit write of (literal)src to (location + 'offset')


#### _16bit write_
Syntax: ```mvw <src> <dest>```
1XXXXXXX 0000YYYY - 16bit write of YYYY to location: XXXXXXXX + 'offset'

#### 8bit write
2XXXXXXX 000000YY - 8bit write of YY to location: XXXXXXXX + 'offset'
[ARASM]: ```mvb <src> <dest>```

#### 32bit 'If less-than' instruction.
3XXXXXXX YYYYYYYY - If the value at (XXXXXXXX or 'offset' when address is 0) < YYYYYYYY then execute the following block of instructions.
Conditional instructions can be nested.
[ARASM]: ```dlt <x_addr> <y_add> <section_identifier>```

#### 32bit 'If greater-than' instruction.
4XXXXXXX YYYYYYYY - If the value at (XXXXXXXX or 'offset' when address is 0) > YYYYYYYY then execute the following block of instructions.
Conditional instructions can be nested.
[ARASM]: ```dgt <x_addr> <y_add> <section_identifier>```

#### 32bit 'If equal' instruction.
5XXXXXXX YYYYYYYY - If the value at (XXXXXXXX or 'offset' when address is 0) == YYYYYYYY then execute the following block of instructions.
Conditional instructions can be nested.
[ARASM]: ```deq <x_addr> <y_add> <section_identifier>```

#### 32bit 'If not equal' instruction.
6XXXXXXX YYYYYYYY - If the value at (XXXXXXXX or 'offset' when address is 0) != YYYYYYYY then execute the following block of instructions.
Conditional instructions can be nested.
[ARASM]: ```dne <x_addr> <y_add> <section_identifier>```

#### 16bit 'If less-than' instruction.
7XXXXXXX ZZZZYYYY - If the value at (XXXXXXXX or 'offset' when address is 0) masked by ZZZZ < YYYY then execute the following block of instructions
Conditional instructions can be nested.
[ARASM]: ```wlt <x_addr> <y_add> <section_identifier>```

#### 16bit 'If greater-than' instruction.
8XXXXXXX YYYYYYYY - If the value at (XXXXXXXX or 'offset' when address is 0) masked by ZZZZ > YYYY then execute the following block of instructions.
Conditional instructions can be nested.
[ARASM]: ```wgt <x_addr> <y_add> <section_identifier>```

#### 16bit 'If equal' instruction.
9XXXXXXX YYYYYYYY - If the value at (XXXXXXXX or 'offset' when address is 0) masked by ZZZZ == YYYY then execute the following block of instructions.
Conditional instructions can be nested.
[ARASM]: ```weq <x_addr> <y_add> <section_identifier>```

#### 16bit 'If not equal' instruction.
AXXXXXXX YYYYYYYY - If the value at (XXXXXXXX or 'offset' when address is 0) masked by ZZZZ != YYYY then execute the following block of instructions.
Conditional instructions can be nested.
[ARASM]: ```wne <x_addr> <y_add> <section_identifier>```

#### Load offset register.
BXXXXXXX 00000000 - Loads the offset register with the data at address (XXXXXXXX + 'offset')
Used to preform pointer relative operations.
[ARASM]: ```lof <addr>```

#### Repeat operation.
C0000000 NNNNNNNN - repeats a block of codes for NNNNNNNN times. The block can include conditional instructions.
Repeat blocks cannot contain further repeats.
[ARASM]: ```rop <count> <section_identifier>```

#### End-if instruction.
D0000000 00000000 - Ends the most recent conditional block.
[ARASM]: ~block

#### End-repeat instruction.
D1000000 00000000 - Ends the current repeat block. Also implicitly ends any conditional instructions inside the repeat block.
[ARASM]: ~block

#### End-code instruction.
D2000000 00000000 - Ends the current repeat block (if any), then End-if's any further outstanding conditional statements.
Also sets 'offset' and 'stored' to zero.
[ARASM]: // nothing

#### Set offset register.
D3000000 YYYYYYYY - Loads the offset register with the value YYYYYYYY.
[ARASM]: ```sof <val>```

#### Add to 'stored'.
D4000000 YYYYYYYY - Adds YYYYYYYY to the 'stored' register.
[ARASM]: ```ast <val>```

#### Set 'stored'.
D5000000 YYYYYYYY - Loads the value YYYYYYYY into the 'stored' register.
[ARASM]: ```sst <val>```

#### 32bit store and increment.
D6000000 XXXXXXXX - Saves all 32 bits of 'stored' register to address (XXXXXXXX + 'offset'). Post-increments 'offset' by 4.
[ARASM]: ```sid <addr>```

#### 16bit store and increment.
D7000000 XXXXXXXX - Saves bottom 16 bits of 'stored' register to address (XXXXXXXX + 'offset'). Post-increments 'offset' by 2.
[ARASM]: ```siw <addr>```

#### 8bit store and increment.
D8000000 XXXXXXXX - Saves bottom 8 bits of 'stored' register to address (XXXXXXXX + 'offset'). Post-increments 'offset' by 1.
[ARASM]: ```sib <addr>```

#### 32bit load 'stored' from address.
D9000000 XXXXXXXX - Loads 'stored' with the 32bit value at address (XXXXXXXX + 'offset').
[ARASM]: ```lsd <addr>```

#### 16bit load 'stored' from address.
DA000000 XXXXXXXX - Loads 'stored' with the 16bit value at address (XXXXXXXX + 'offset').
[ARASM]: ```lsw <addr>```

#### 8bit load 'stored' from address.
DB000000 XXXXXXXX - Loads 'stored' with the 8bit value at address (XXXXXXXX + 'offset').
[ARASM]: ```lsb <addr>```

#### Add to 'offset'.
DC000000 YYYYYYYY - Adds YYYYYYYY to the 'offset' register .
[ARASM]: ```aof <val>```

#### Direct memory write.
EXXXXXXX NNNNNNNN - Writes NNNNNNNN bytes from the list of values VVVVVVVV to the addresses starting at (XXXXXXXX + 'offset').
VVVVVVVV VVVVVVVV *
((NNNNNNNN+7)/8)
[ARASM]: ```fmv <addr_start> <list_as_val> <num_bytes>```

#### Memory copy
FXXXXXXX NNNNNNNN - Copied NNNNNNNN bytes from addresses starting at the 'offset' register to addresses starting at XXXXXXXX.
[ARASM]: ```fcp <addr_start> <num_bytes>```
