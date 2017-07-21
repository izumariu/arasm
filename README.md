# ARASM REFERENCE

### Syntax and program structure

A command statement looks like this:

    command arg1 arg2 arg3 ... argN

Example:

    mvw $88 $100

Blocks can be created using "." + block_name, and are closed with "~" + block_name.

Example:

    dne $2093550 0 .a
		lof $2093550
    mvw $88 $100
		~a

Numeric literals are additionally prefixed with a ```$``` if they are formatted as hexadecimals.

### Command reference:

#### Symbol Key
    "Offset" - A code-engine register used to hold an address offset.
    "Stored" - A code-engine register used to store data, also known as accumulator.

#### 32bit write
32bit write of val to (dest + 'offset')
```mvd <dest> <val>```

#### 16bit write
16bit write of val to (dest + 'offset')
```mvw <dest> <val>```

#### 8bit write
8bit write of val to (dest + 'offset')
```mvb <dest> <val>```

#### 32bit 'If less-than' instruction.
If the value at (x_addr or 'offset' when address is 0) < val then execute the following block of instructions.
Conditional instructions can be nested.
```dlt <x_addr> <val> <block>```

#### 32bit 'If greater-than' instruction.
If the value at (x_addr or 'offset' when address is 0) > val then execute the following block of instructions.
Conditional instructions can be nested.
```dgt <x_addr> <val> <block>```

#### 32bit 'If equal-to' instruction.
If the value at (x_addr or 'offset' when address is 0) == val then execute the following block of instructions.
Conditional instructions can be nested.
```deq <x_addr> <val> <block>```

#### 32bit 'If not-equal-to' instruction.
If the value at (x_addr or 'offset' when address is 0) != val then execute the following block of instructions.
Conditional instructions can be nested.
```dne <x_addr> <val> <block>```

#### 16bit 'If less-than' instruction.
If the value at (x_addr or 'offset' when address is 0) < val then execute the following block of instructions.
Conditional instructions can be nested.
```wlt <x_addr> <val> <block>```

#### 16bit 'If greater-than' instruction.
If the value at (x_addr or 'offset' when address is 0) > val then execute the following block of instructions.
Conditional instructions can be nested.
```wgt <x_addr> <val> <block>```

#### 16bit 'If equal-to' instruction.
If the value at (x_addr or 'offset' when address is 0) == val then execute the following block of instructions.
Conditional instructions can be nested.
```weq <x_addr> <val> <block>```

#### 16bit 'If not-equal-to' instruction.
If the value at (x_addr or 'offset' when address is 0) != val then execute the following block of instructions.
Conditional instructions can be nested.
```wne <x_addr> <val> <block>```

#### Load offset register.
Loads the offset register with the data at (addr + 'offset')
Used to preform pointer relative operations.
```lof <addr>```

#### Repeat operation.
Repeats a block of codes for n times. The block can include conditional instructions.
Repeat blocks cannot contain further repeats.
[ARASM]: rop <n> <block>

#### End-if instruction.
Ends the most recent conditional block.
```~block```

#### End-repeat instruction.
Ends the current repeat block. Also implicitly ends any conditional instructions inside the repeat block.
```~block```

#### End-code instruction.
Ends the current repeat block (if any), then End-if's any further outstanding conditional statements.
Also sets 'offset' and 'stored' to zero.
```~#```

#### Set offset register.
Loads the offset register with val.
```sof <val>```

#### Add to 'stored'.
Adds val to the 'stored' register.
```ast <val>```

#### Set 'stored'.
Loads val into the 'stored' register.
```sst <val>```

#### 32bit store and increment.
Saves all 32 bits of 'stored' register to (addr + 'offset'). Post-increments 'offset' by 4.
```sid <addr>```

#### 16bit store and increment.
Saves the bottom 16 bits of 'stored' register to (addr + 'offset'). Post-increments 'offset' by 2.
```siw <addr>```

#### 8bit store and increment.
Saves the bottom 8 bits of 'stored' register to (addr + 'offset'). Post-increments 'offset' by 1.
```sib <addr>```

#### 32bit load 'stored' from address.
Loads 'stored' with the 32bit value at (addr + 'offset').
```lsd <addr>```

#### 16bit load 'stored' from address.
Loads 'stored' with the 16bit value at (addr + 'offset').
```lsw <addr>```

#### 8bit load 'stored' from address.
Loads 'stored' with the 8bit value at (addr + 'offset').
```lsb <addr>```

#### Add to 'offset'.
Adds val to the 'offset' register .
[ARASM]: aof <val>

#### Direct memory write.
Writes num_bytes bytes from list_as_val to the addresses starting at (addr_start + 'offset').
[ARASM]: fmv <addr_start> <list_as_val> <num_bytes>

#### Memory copy
Copied num_bytes bytes from addresses starting at the 'offset' register to addresses starting at addr_start.
[ARASM]: fcp <addr_start> <num_bytes>
