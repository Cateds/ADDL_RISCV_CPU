# Water Light Program Flowchart

RV32I assembly program flowchart based on `waterlight.s` file.

## Overall Program Flow

```mermaid
flowchart TD
    A[Start _main] --> B[Initialize GPIO Base Address]
    B --> C["Configure GPIO Mode<br/>Lower 8 bits output, upper bits input"]
    C --> D["Initialize Variables<br/>x13=LED state(0x01)<br/>x14=Output register address<br/>x15=Direction flag(0)<br/>x16=Run flag(1)"]
    D --> E[Main Loop main_loop]

    E --> F[Read GPIO Input Status]
    F --> G[Extract GPIO Run Switch]
    G --> H[Extract GPIO Direction Switch]
    H --> I{"GPIO[8] == 0?<br/>Stop running?"}

    I -->|Yes| J[Turn off all LEDs]
    I -->|No| K[Update direction flag]

    J --> L[Short delay 1000 cycles]
    L --> M[Jump back to main loop]
    M --> E

    K --> N[Light current LED]
    N --> O[Delay 0x600 cycles]
    O --> P{"Direction flag == 0?<br/>Forward movement?"}

    P -->|Yes| Q[Forward movement processing]
    P -->|No| R[Backward movement processing]

    Q --> S["Left shift one bit x13 << 1"]
    S --> T{"Result < 0x100?"}
    T -->|Yes| U[Update LED state]
    T -->|No| V[Reset to 0x01]
    U --> W[Jump back to main loop]
    V --> W
    W --> E

    R --> X["Right shift one bit x13 >> 1"]
    X --> Y{"Result != 0?"}
    Y -->|Yes| Z[Update LED state]
    Y -->|No| AA[Reset to 0x80]
    Z --> BB[Jump back to main loop]
    AA --> BB
    BB --> E
```

## Detailed Functional Modules

### 1. Initialization Module

```mermaid
flowchart TD
    A[_main Entry] --> B["lui x10, 0x40100<br/>Set GPIO base address"]
    B --> C["addi x11, x10, 0x04<br/>Calculate config register address"]
    C --> D["addi x12, x0, 0xFF<br/>Set output mode value"]
    D --> E["sh x12, 0(x11)<br/>Write to config register"]
    E --> F["Initialize working variables<br/>x13=0x01, x14=output address<br/>x15=0, x16=1"]
```

### 2. GPIO Read and Control Logic

```mermaid
flowchart TD
    A[Read GPIO Input] --> B["lh x17, 0(x10)<br/>Read complete GPIO value"]
    B --> C["srli x18, x17, 8<br/>Right shift 8 bits to get upper bits"]
    C --> D["andi x19, x18, 1<br/>Extract GPIO run switch"]
    D --> E["srli x20, x18, 1<br/>Continue right shift for GPIO direction"]
    E --> F["andi x20, x20, 1<br/>Extract GPIO direction switch"]
    F --> G{"GPIO[8] == 0?"}
    G -->|Yes| H[Stop water light]
    G -->|No| I[Continue running]
    I --> J["add x15, x0, x20<br/>Update direction flag"]
```

### 3. Delay Module

```mermaid
flowchart TD
    A[Start Delay] --> B["lui x21, 0x00600<br/>Set delay counter"]
    B --> C["delay_loop:<br/>addi x21, x21, -1"]
    C --> D{"x21 != 0?"}
    D -->|Yes| C
    D -->|No| E[Delay Finished]
```

### 4. Forward Movement Logic

```mermaid
flowchart TD
    A[forward: Forward Movement] --> B["slli x22, x13, 1<br/>Current state left shift one bit"]
    B --> C["addi x23, x0, 0x100<br/>Set boundary value 256"]
    C --> D{"x22 < 256?"}
    D -->|Yes| E["update_forward:<br/>add x13, x0, x22<br/>Update LED state"]
    D -->|No| F["addi x13, x0, 1<br/>Reset to first LED"]
    E --> G["jal x0, main_loop<br/>Return to main loop"]
    F --> G
```

### 5. Backward Movement Logic

```mermaid
flowchart TD
    A[backward: Backward Movement] --> B["srli x22, x13, 1<br/>Current state right shift one bit"]
    B --> C{"x22 != 0?"}
    C -->|Yes| D["update_backward:<br/>add x13, x0, x22<br/>Update LED state"]
    C -->|No| E["addi x13, x0, 0x80<br/>Reset to last LED"]
    D --> F["jal x0, main_loop<br/>Return to main loop"]
    E --> F
```

### 6. Stop Mode

```mermaid
flowchart TD
    A[stop_lights: Stop Mode] --> B["sh x0, 0(x14)<br/>Turn off all LEDs"]
    B --> C["addi x21, x0, 1000<br/>Set short delay counter"]
    C --> D["short_delay:<br/>addi x21, x21, -1"]
    D --> E{"x21 != 0?"}
    E -->|Yes| D
    E -->|No| F["jal x0, main_loop<br/>Return to main loop check switches"]
```

## Register Usage Description

| Register | Purpose                      | Description                            |
| -------- | ---------------------------- | -------------------------------------- |
| x10      | GPIO Base Address            | 0x40100000                             |
| x11      | GPIO Config Register Address | x10 + 0x04                             |
| x12      | Config Value                 | 0xFF (lower 8 bits output)             |
| x13      | Current LED State            | Bit pattern indicating which LED is on |
| x14      | GPIO Output Register Address | x10 + 0x02                             |
| x15      | Direction Flag               | 0=forward, 1=backward                  |
| x16      | Run Flag                     | 0=stop, 1=run                          |
| x17      | GPIO Input Value             | Temporary storage                      |
| x18      | Processed Input Value        | Value after right shift by 8 bits      |
| x19      | GPIO[8] Status               | Run switch status                      |
| x20      | GPIO[9] Status               | Direction switch status                |
| x21      | Delay Counter                | Used for various delays                |
| x22      | Temporary LED State          | Result of shift operations             |
| x23      | Boundary Value               | Used for boundary checking             |

## Program Features

1. **Infinite Loop Design**: Program implements infinite loop through `jal x0, main_loop`
2. **Real-time Response**: Checks GPIO switch status every loop iteration
3. **Bidirectional Flow**: Supports both forward and backward flow directions
4. **Boundary Handling**: Automatically handles boundary conditions for water light
5. **Energy-saving Design**: Turns off all LEDs when stopped to reduce power consumption
6. **Precise Timing**: Delay loops designed for 1MHz clock frequency
