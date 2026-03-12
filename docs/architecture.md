# Main CPU Firmware Architecture

## Overview

This firmware controls a robotic manipulator. The architecture is designed around
three principles:

1. **Portability** — algorithms are hardware-independent and can run on any MCU
2. **Extensibility** — new features are added without modifying existing code
3. **Determinism** — zero runtime overhead from the architecture itself

The system is split into four layers. Each layer has exactly one responsibility
and exactly one reason to change.

```
┌─────────────────────────────────────────────┐
│  logic/         Pure algorithms (C++)       │ ← portable
│  utility/       Reusable building blocks    │ ← portable
│  abstract/      Hardware contract (C)       │ ← stable, rarely changes
│  driver/        Chip-specific code (C/ASM)  │ ← replaced per platform
└─────────────────────────────────────────────┘
```

Data flows through a real-time cascade:

```
Trajectory (100 Hz)
    → Kinematics (100 Hz)
        → Servo loop (1 kHz)
            → FOC current loop (50 kHz)
                → PWM output
```

Each level only talks to its neighbors. FOC does not know about kinematics.
Kinematics does not know about PWM registers.

---

## System Context

Before diving into firmware, here is where the Main CPU sits in the
overall robot:

```
                           HSPS Robot
                              │
         ┌────────────────────┼────────────────────┐
         │                    │                    │
   [Power Blades]      [Motherboard]      [Technologist Module]
    6× motor               │       │          tool control
    drivers                │       │          high-level commands
    6× STM32G4             │       │
    (ADC current)          │       │
         │          [FPGA ECP5]  [MCU STM32H7A3] ──────┘
         │              │              │
         └── SPI ───────┘              │    ← THIS FIRMWARE
                        │              │
                        └──── bus ─────┘
                        data exchange
                        (abstracted transport)
```

The FPGA handles all real-time I/O in parallel: PWM generation, encoder
decoding, ADC data collection from the G4 MCUs on each Power Blade.
The main MCU handles all math: FOC, servo loops, kinematics, trajectory
planning.

Each Power Blade contains a STM32G4 that performs high-resolution ADC
sampling of two phase currents, triggered by the FPGA at the PWM center
point. The G4s communicate with the FPGA via SPI (FPGA = master).

The main MCU and FPGA communicate through a shared register interface.
The transport layer is **abstracted** — the firmware does not care whether
registers are accessed via SPI transactions or direct memory-mapped
writes via FMC. The FPGA always controls the exchange timing.

---

## Directory Structure

```
main_cpu/
│
├── logic/                          # Pure algorithms — PORTABLE
│   ├── 0_foc/                      # Field-Oriented Control
│   │   ├── foc.hpp                 # FOC controller class
│   │   ├── foc.cpp
│   │   ├── clarke_park.hpp         # Clarke/Park transforms (inline)
│   │   └── svpwm.hpp              # Space Vector PWM (inline)
│   │
│   ├── 1_servo/                    # Position/velocity servo loop
│   │   ├── servo.hpp
│   │   ├── servo.cpp
│   │   ├── servo_chain.hpp         # Compile-time extension pipeline
│   │   └── extensions/             # Servo loop extensions (infinite)
│   │       ├── damping/
│   │       │   └── damping.hpp
│   │       ├── friction/
│   │       │   └── friction.hpp
│   │       ├── cogging/
│   │       │   └── cogging.hpp
│   │       └── .../
│   │
│   ├── 2_kinematics/               # Forward/inverse kinematics
│   │   ├── forward.cpp
│   │   ├── inverse.cpp
│   │   └── jacobian.cpp
│   │
│   ├── 3_trajectory/               # Path planning
│   │   ├── planner.cpp
│   │   ├── interpolator.cpp
│   │   └── s_curve.cpp
│   │
│   ├── 4_runtime/                  # System orchestration
│   │   ├── state_machine.cpp       # Operating states
│   │   ├── homing.cpp             # Homing sequence
│   │   ├── protocol/              # Technologist module communication
│   │   │   ├── packet.cpp         # Packet parsing/building
│   │   │   ├── commands.cpp       # Command handlers
│   │   │   └── feedback.cpp       # Status reporting
│   │   └── modes/                 # Special operating modes (infinite)
│   │       └── resonance_scan/
│   │
│   └── safety/                     # Safety — ALWAYS ON, never disabled
│       ├── guardian.cpp            # Last barrier before hardware
│       └── watchdog.cpp           # Software watchdog
│
├── utility/                        # Reusable building blocks — PORTABLE
│   ├── math/
│   │   ├── matrix/                 # Matrix operations
│   │   ├── quaternion/            # Quaternion math
│   │   └── spline/                # Spline interpolation
│   ├── control/
│   │   ├── pid/                   # PID controller
│   │   └── filters/               # Notch, lowpass, Kalman
│   ├── signal/
│   │   └── dsp/                   # FFT, spectral analysis
│   └── utils/
│       ├── ring_buffer/
│       └── crc/
│
├── abstract/                       # Hardware contract — STABLE
│   ├── types.h                     # Shared data structures
│   └── hw_contract.h              # Documents required HW functions
│
├── driver/                         # Chip-specific — REPLACEABLE
│   ├── hw_impl.h                  # Inline HW functions (the bridge)
│   ├── hw_binding.c               # Peripheral initialization
│   ├── config.h                   # Pin assignments, frequencies
│   ├── startup/
│   │   ├── vectors.c
│   │   ├── reset_handler.c
│   │   └── linker_script.ld
│   ├── isr/
│   │   ├── foc_isr.c
│   │   └── servo_isr.c
│   ├── mcu/
│   │   ├── rcc.c                  # Clock tree
│   │   ├── gpio.c                 # Pin configuration
│   │   ├── adc.c                  # ADC + DMA
│   │   ├── tim.c                  # Timers
│   │   ├── dma.c                  # DMA channels
│   │   ├── cordic_hw.c            # Hardware CORDIC
│   │   └── spi.c                  # SPI peripheral
│   ├── fpga_bus/
│   │   ├── fpga_transport.h       # Transport abstraction
│   │   ├── fpga_spi.c            # Current: frame-based SPI (FPGA = master)
│   │   └── fpga_fmc.c            # Future: memory-mapped transport
│   ├── comms/
│   │   └── spi_tech.c            # SPI to technologist module
│   └── vendor/
│       └── CMSIS/                 # Vendor-provided headers (do not edit)
│           ├── stm32h7a3xx.h
│           ├── system_stm32h7xx.h
│           └── core_cm7.h
│
├── main.cpp                        # Entry point + configuration
├── CMakeLists.txt
└── Makefile
```

---

## The Four Layers

### logic/ — Pure Algorithms

**Language:** C++
**Knows about:** math, control theory, robotics
**Does NOT know about:** registers, DMA, SPI, what MCU is used

This layer contains the entire control cascade:

```
4_runtime    (main loop)    commands, state machine, modes
    │
3_trajectory (100 Hz)       path planning, S-curves
    │
2_kinematics (100 Hz)       joint angles ↔ Cartesian coordinates
    │
1_servo      (1 kHz)        position/velocity PID + extensions
    │
0_foc        (50 kHz)       current control, Clarke/Park, SVPWM
    │
    ▼
abstract/hw_contract        "give me currents, take my PWM"
```

Each level only calls the level below it. FOC does not know about
kinematics. Trajectory does not know about PWM registers.

The `safety/` module is special — it sits between `1_servo/` output and
`0_foc/` input as an unbypassable barrier. See [Safety](#safety) below.

**Numbering convention:** `0_` is the fastest loop (closest to hardware),
`4_` is the slowest (closest to the user). This makes the cascade
hierarchy immediately visible in any file listing.

```
0_foc        50 kHz    current control
1_servo       1 kHz    position/velocity control
2_kinematics  100 Hz   joint-to-cartesian transforms
3_trajectory  100 Hz   path planning
4_runtime     main()   state machine, commands, modes
```

### utility/ — Reusable Building Blocks

**Language:** C or C++

**Rules:**
- Pure math and utilities — no hardware, no state machines
- Each block is self-contained with its own `.h` and `.c`/`.cpp`
- ONLY placed in `utility/` if used by **more than one** module in `logic/`
- If used by only one module — keep it inside that module

**Grouping:**
- `math/` — linear algebra, quaternions, splines
- `control/` — PID, filters, observers
- `signal/` — FFT, spectral analysis
- `utils/` — ring buffers, CRC, data structures

### abstract/ — Hardware Contract

**Language:** C (with `extern "C"` guards for C++ compatibility)
**Contains:** only header files
**Changes:** almost never

This layer defines **what** the hardware must provide, not **how**.

`hw_contract.h` is a documentation file that lists every function
`driver/hw_impl.h` must implement:

```c
// hw_contract.h
//
// Every driver/ MUST provide hw_impl.h with these functions:
//
// --- Motor I/O ---
//   static inline phase_t  hw_read_currents(void);
//   static inline rotor_t  hw_read_rotor(uint8_t axis);
//   static inline void     hw_write_pwm(uint8_t axis, phase_t duty);
//
// --- Gate control ---
//   static inline void     hw_enable_gate(uint8_t axis);
//   static inline void     hw_disable_gate(uint8_t axis);
//
// --- Math acceleration ---
//   static inline void     hw_sincos(float angle, float *s, float *c);
//
// --- Timing ---
//   static inline uint32_t hw_micros(void);
//
// --- FPGA register access ---
//   static inline void     hw_fpga_write(uint16_t addr, uint32_t value);
//   static inline uint32_t hw_fpga_read(uint16_t addr);
```

Note: `hw_fpga_write` / `hw_fpga_read` are the **abstracted register
interface**. Logic calls them without knowing whether the transport is
SPI, FMC, or any future bus. See [FPGA Communication](#fpga-communication)
below.

### driver/ — Chip-Specific Implementation

**Language:** C + ASM

**Knows about:** everything hardware — registers, DMA, pin numbers, clock trees
**Scope:** when switching to a different MCU, **only this layer is rewritten**

`hw_impl.h` is the bridge file. It implements every function from
`hw_contract.h` as `static inline`, so the compiler inlines them directly
into the calling code. **Zero function call overhead.**

---

## FPGA Communication

### The Problem

The MCU and FPGA exchange data through a shared register space. The FPGA
exposes registers for:

- PWM duty cycles (MCU writes)
- Encoder positions (MCU reads)
- ADC current values (MCU reads)
- Configuration (MCU writes)

Today, this register access happens over **SPI** — the FPGA (as master)
sends full-duplex frames containing register snapshots and receives
computed outputs. Tomorrow, when the motherboard is manufactured with a
proper bus, the FPGA will appear as a **memory-mapped peripheral** via
FMC, and register access will be a simple pointer dereference.

### The Solution: Transport Abstraction Inside driver/

The abstraction happens **inside** `driver/fpga_bus/`, not in `abstract/`.
Why? Because both SPI and FMC are chip-specific — they both live in the
driver layer.

```
driver/fpga_bus/
├── fpga_transport.h       # common interface
├── fpga_spi.c            # SPI implementation (current)
└── fpga_fmc.c            # FMC implementation (future)
```

```c
// fpga_transport.h

#pragma once
#include <stdint.h>

// Only ONE of these is compiled (selected in CMakeLists.txt)
void     fpga_transport_init(void);
void     fpga_write_reg(uint16_t addr, uint32_t value);
uint32_t fpga_read_reg(uint16_t addr);
```

```c
// fpga_spi.c — current implementation (FPGA = SPI master)

#include "fpga_transport.h"
#include "mcu/spi.h"

// The FPGA drives CS and SCK. The MCU configures SPI as slave with DMA.
// On each FPGA sync event, a full-duplex frame is exchanged:
//   FPGA → MCU: register snapshot (encoder positions, ADC currents)
//   MCU → FPGA: computed outputs (PWM duties, enable flags)
//
// The transport layer unpacks the received frame into a register cache,
// and packs the outgoing register values into the TX frame.

static uint32_t reg_cache_rx[FPGA_REG_COUNT];  // received from FPGA
static uint32_t reg_cache_tx[FPGA_REG_COUNT];  // to be sent to FPGA

void fpga_transport_init(void) {
    spi_slave_init();  // configure SPI as slave + DMA + EXTI on CS
}

uint32_t fpga_read_reg(uint16_t addr) {
    return reg_cache_rx[addr];  // read from local cache (updated by DMA ISR)
}

void fpga_write_reg(uint16_t addr, uint32_t value) {
    reg_cache_tx[addr] = value;  // write to local cache (sent on next frame)
}
```

```c
// fpga_fmc.c — future implementation

#include "fpga_transport.h"

#define FPGA_BASE_ADDR  0x60000000  // FMC bank 1

static volatile uint32_t *fpga_mem =
    (volatile uint32_t *)FPGA_BASE_ADDR;

void fpga_transport_init(void) {
    fmc_init();  // configure FMC peripheral
}

void fpga_write_reg(uint16_t addr, uint32_t value) {
    fpga_mem[addr] = value;  // single bus write, ~10ns
}

uint32_t fpga_read_reg(uint16_t addr) {
    return fpga_mem[addr];   // single bus read, ~10ns
}
```

### How hw_impl.h Uses It

```c
// driver/hw_impl.h

#include "fpga_bus/fpga_transport.h"
#include "config.h"

static inline phase_t hw_read_currents(void) {
    return (phase_t){
        .a = (float)(int16_t)fpga_read_reg(FPGA_REG_CURRENT_A) * CURRENT_SCALE,
        .b = (float)(int16_t)fpga_read_reg(FPGA_REG_CURRENT_B) * CURRENT_SCALE,
        .c = (float)(int16_t)fpga_read_reg(FPGA_REG_CURRENT_C) * CURRENT_SCALE,
    };
}

static inline void hw_write_pwm(uint8_t axis, phase_t duty) {
    fpga_write_reg(FPGA_REG_PWM_A + axis * FPGA_AXIS_STRIDE,
                   (uint32_t)(duty.a * TIM_PERIOD));
    fpga_write_reg(FPGA_REG_PWM_B + axis * FPGA_AXIS_STRIDE,
                   (uint32_t)(duty.b * TIM_PERIOD));
    fpga_write_reg(FPGA_REG_PWM_C + axis * FPGA_AXIS_STRIDE,
                   (uint32_t)(duty.c * TIM_PERIOD));
}
```

### Switching Transport

```cmake
# CMakeLists.txt
option(FPGA_TRANSPORT_SPI "Use SPI for FPGA communication" ON)
option(FPGA_TRANSPORT_FMC "Use FMC for FPGA communication" OFF)

if(FPGA_TRANSPORT_SPI)
    target_sources(firmware PRIVATE driver/fpga_bus/fpga_spi.c)
elseif(FPGA_TRANSPORT_FMC)
    target_sources(firmware PRIVATE driver/fpga_bus/fpga_fmc.c)
endif()
```

Switching from SPI to FMC:
1. Change one CMake option
2. Rebuild

`logic/`, `utility/`, `abstract/` — **untouched**.
Even `hw_impl.h` — **untouched**. Only the transport file changes.

### Performance Comparison

| Transport | Write latency | Read latency | FOC overhead (6 reg ops) |
|-----------|--------------|-------------|--------------------------|
| SPI 20MHz | ~2 µs        | ~3 µs       | ~15 µs                   |
| FMC       | ~10 ns       | ~10 ns      | ~60 ns                   |

With FMC, FPGA register access becomes essentially free — just a memory
dereference.

---

## How It Works

### The Bridge: hw_impl.h

This single file connects portable algorithms to real hardware:

```c
// driver/hw_impl.h

static inline phase_t hw_read_currents(void) {
    // logic/ calls this. It has no idea this goes through FPGA registers.
    // With SPI: ~3µs. With FMC: ~10ns. Logic doesn't care.
    return (phase_t){
        .a = (float)(int16_t)fpga_read_reg(FPGA_REG_CURRENT_A) * CURRENT_SCALE,
        .b = (float)(int16_t)fpga_read_reg(FPGA_REG_CURRENT_B) * CURRENT_SCALE,
        .c = (float)(int16_t)fpga_read_reg(FPGA_REG_CURRENT_C) * CURRENT_SCALE,
    };
}
```

The compiler inlines everything. With FMC, the final assembly is just
three memory loads and three multiplies. **No function calls. No
indirection. No overhead from the architecture.**

### main.cpp — Entry Point and Configuration

```cpp
#include "hw_impl.h"
#include "logic/0_foc/foc.hpp"
#include "logic/1_servo/servo.hpp"
#include "logic/1_servo/extensions/damping/damping.hpp"
#include "logic/1_servo/extensions/friction/friction.hpp"

foc::FOC foc_instance;

// Compile-time servo chain — zero overhead
auto servo_chain = ServoChain{
    Damping{.freq = 45.0f, .gain = 0.3f},
    FrictionComp{.coulomb = 0.1f},
};

int main(void) {
    hw_binding_init();          // clocks, pins, DMA, FPGA transport
    foc_instance.init(PID_KP_D, PID_KI_D, PID_KP_Q, PID_KI_Q);
    servo_init();
    hw_enable_gate(0);

    while (1) {
        runtime_spin();         // state machine, technologist commands
    }
}
```

**main.cpp is the configuration file.** To see what the robot does, read
main.cpp. To change what the robot does, edit main.cpp.

### Interrupt-Driven Cascade

The FPGA controls all timing. It triggers the MCU at the FOC rate
(50 kHz) via a dedicated interrupt line. The MCU never uses its own
timers for the control loop — this guarantees that ADC sampling, FOC
computation, and PWM update are perfectly synchronized.

```c
// driver/isr/foc_isr.c — 50 kHz, triggered by FPGA
extern "C" void FPGA_SYNC_IRQHandler(void) {
    EXTI->PR1 = FPGA_SYNC_PIN;         // clear interrupt flag
    foc_instance.step();                // reads FPGA regs, computes, writes FPGA regs
}

// driver/isr/servo_isr.c — 1 kHz, decimated from FOC rate
// Called every N-th FOC cycle (e.g., every 50th = 1 kHz)
static uint32_t servo_divider = 0;
if (++servo_divider >= 50) {
    servo_divider = 0;
    servo_step(&axis);                  // PID + extensions + guardian
}
```

The servo loop runs at 1 kHz by decimating the FOC interrupt — no
separate timer needed. This keeps the servo perfectly phase-locked
to the FOC loop and avoids interrupt priority conflicts.

### Data Flow Per Control Cycle

```
FPGA (parallel, continuous):
  ├─ Decodes encoders          → writes to FPGA registers
  ├─ Receives ADC via SPI      → writes to FPGA registers (from G4s on Blades)
  └─ Generates PWM             ← reads from FPGA registers

MCU (interrupt-driven, 50 kHz):
  1. FPGA triggers sync interrupt
  2. foc_step() runs:
     a. hw_read_currents()     → reads FPGA registers (via SPI or FMC)
     b. hw_read_rotor()        → reads FPGA registers
     c. Clarke/Park transforms → pure math
     d. PID on Id, Iq          → pure math (utility/control/pid/)
     e. Inverse Park + SVPWM   → pure math
     f. hw_write_pwm()         → writes FPGA registers
  3. Return from interrupt

MCU (decimated from FOC, 1 kHz):
  1. Every 50th FOC cycle:
  2. servo_step() runs:
     a. Read position           → hw_read_rotor()
     b. PID position loop       → utility/control/pid/
     c. Extension pipeline      → damping, friction, etc. (compile-time)
     d. Guardian safety check   → safety/guardian
     e. Set torque target       → foc_instance.set_torque()
  3. Return from interrupt

MCU (main loop, continuous):
  1. runtime_spin()
     a. Check technologist commands  → protocol/
     b. Update state machine         → state_machine
     c. Run trajectory planner       → 3_trajectory/
     d. Run kinematics               → 2_kinematics/
```

---

## Safety

Safety is implemented as three independent, layered barriers:

```
    Extensions output (may contain bugs)
              │
    ╔═════════▼═══════════╗
    ║  GUARDIAN (software) ║
    ║  • NaN check        ║
    ║  • Torque limits    ║
    ║  • Velocity limits  ║
    ║  • Position limits  ║
    ║  • Following error  ║
    ║  • Watchdog         ║
    ╚═════════╤═══════════╝
              │ (clean, validated torque)
              ▼
    FOC overcurrent (software limit in 0_foc/)
              │
              ▼
    Hardware comparator (analog, on Power Blade)
              │
              ▼
    FPGA dead-time (hardware, cannot be bypassed by software)
```

**Guardian is NEVER disabled.** There is no `#if FEATURE_SAFETY`.
There is no configuration option to turn it off. It is always compiled,
always runs, always checks.

Even if all software fails, the hardware comparator on the Power Blade
will cut power to the motor if current exceeds the absolute maximum.
Even if the comparator fails, the FPGA dead-time prevents shoot-through.

---

## How to Extend

### Adding a Servo Extension

**You need to know:** how to write a struct with a `step()` method.
**You do NOT need to know:** FOC, registers, FPGA, interrupts, DMA.

**Step 1:** Create your extension

```
logic/1_servo/extensions/my_feature/
└── my_feature.hpp
```

```cpp
#pragma once
#include "abstract/types.h"

struct MyFeature {
    float my_param;

    float step(float torque, Axis& axis) {
        return torque + my_param * axis.velocity;
    }
};
```

**Step 2:** Add one line to `main.cpp`

```cpp
#include "logic/1_servo/extensions/my_feature/my_feature.hpp"

auto servo_chain = ServoChain{
    Damping{.freq = 45.0f, .gain = 0.3f},
    MyFeature{.my_param = 0.5f},             // ← add this
};
```

**Step 3:** Build. Done.

The compiler inlines `step()` directly into the servo loop. No function
pointers. No vtables. Identical performance to hand-written code.

To remove the feature, delete the line from `servo_chain`. The compiler
eliminates all dead code. Zero bytes remain in the binary.

### Adding a New Operating Mode

**Step 1:** Create mode directory

```
logic/4_runtime/modes/my_mode/
├── my_mode.hpp
└── my_mode.cpp
```

**Step 2:** Register in state machine

```cpp
// logic/4_runtime/state_machine.cpp
case STATE_MY_MODE:
    my_mode_step();
    break;
```

**Step 3:** Add technologist command

```cpp
// logic/4_runtime/protocol/commands.cpp
case CMD_START_MY_MODE:
    state_machine_enter(STATE_MY_MODE);
    break;
```

### Adding a New Sensor

**Step 1:** Add FPGA register address to `driver/config.h`

```c
#define FPGA_REG_NEW_SENSOR   0x40
```

**Step 2:** Add inline reader to `driver/hw_impl.h`

```c
static inline float hw_read_new_sensor(void) {
    return (float)(int16_t)fpga_read_reg(FPGA_REG_NEW_SENSOR) * SCALE;
}
```

**Step 3:** Document in `abstract/hw_contract.h`

```c
//   static inline float hw_read_new_sensor(void);
```

**Step 4:** Call from `logic/` — done

### Adding a Utility Block

```
utility/control/my_filter/
├── my_filter.h
└── my_filter.c
```

**Rule:** only move to `utility/` if used by more than one module in `logic/`.
Otherwise keep it inside the module that uses it.

---

## How to Port to a New MCU

1. Rewrite `driver/` contents for the new chip
2. Implement every function listed in `abstract/hw_contract.h`
3. Provide `startup/`, `isr/`, `mcu/` for the new chip
4. Provide `fpga_bus/` with the appropriate transport
5. **Do not touch `logic/`, `utility/`, or `abstract/`**

```
Changes:            driver/*          (rewrite)
                    main.cpp          (adjust init)

Stays identical:    logic/*           (all algorithms)
                    utility/*         (all building blocks)
                    abstract/*        (the contract)
```

---

## Language Policy

| Layer      | Language | Why                                          |
|------------|----------|----------------------------------------------|
| logic/     | C++      | Templates for zero-overhead extensions        |
| utility/   | C or C++ | Pure math, maximum compatibility              |
| abstract/  | C        | Must be usable from both C and C++            |
| driver/    | C + ASM  | Direct register access, CMSIS compatibility   |
| main.cpp   | C++      | Uses C++ servo chain template                 |

C++ features used: `templates`, `constexpr`, `inline`, `namespaces`,
`designated initializers`. No heap allocation. No exceptions. No RTTI.

---

## Build

```bash
# Build with SPI transport (current)
cmake -B build \
    -DCMAKE_TOOLCHAIN_FILE=cmake/arm-gcc.cmake \
    -DFPGA_TRANSPORT_SPI=ON
cmake --build build

# Build with FMC transport (future motherboard)
cmake -B build \
    -DCMAKE_TOOLCHAIN_FILE=cmake/arm-gcc.cmake \
    -DFPGA_TRANSPORT_FMC=ON
cmake --build build

# Flash
openocd -f target/stm32h7.cfg \
    -c "program build/firmware.elf verify reset exit"
```

---

## Architecture Diagram

```
main.cpp                     entry point + configuration
  │
  ▼
logic/4_runtime  ◄────────── protocol/ (technologist module, SPI)
  │ commands
  ▼
logic/3_trajectory
  │ waypoints
  ▼
logic/2_kinematics
  │ joint angles
  ▼
logic/1_servo    ◄────────── extensions/ (compile-time, zero overhead)
  │ torque
  ▼
safety/guardian  ◄────────── ALWAYS ON — NaN, limits, watchdog
  │ validated torque
  ▼
logic/0_foc
  │ PWM duty
  ▼
abstract/hw_contract ◄────── driver/hw_impl.h (static inline)
                                │
                                ▼
                         fpga_transport (SPI or FMC)
                                │
                                ▼
                           FPGA registers
                                │
                     ┌──────────┼──────────┐
                     ▼          ▼          ▼
                   PWM      Encoders     ADC
                     │          │          │
                     ▼          ▼          ▼
                  Motors    Encoders   Power Blades
                                      (G4 ADC × 6)
```

---

## FAQ

**Q: Where do I put a new algorithm?**
A: If it modifies servo torque → `logic/1_servo/extensions/`.
If it is a new robot mode → `logic/4_runtime/modes/`.
If it is reusable math → `utility/`.

**Q: Can I write extensions in pure C?**
A: Yes. Write a C function, call it from your C++ `step()` method.
The struct wrapper is one method, one line.

**Q: How do I add a sensor that the FPGA doesn't yet expose?**
A: First add the sensor register in FPGA RTL. Then add one `fpga_read_reg`
call in `driver/hw_impl.h`. Then call it from `logic/`.

**Q: What if SPI is too slow for 50 kHz FOC?**
A: Switch to FMC transport — one CMake option. SPI at 20 MHz adds ~15 µs
per FOC cycle (6 register operations). FMC reduces this to ~60 ns.
The 20 µs budget accommodates SPI for prototyping.

**Q: How do I disable a feature?**
A: Remove its line from `servo_chain` in `main.cpp`. Compiler eliminates
all dead code. Zero bytes in binary, zero cycles at runtime.

**Q: What guarantees safety?**
A: Four independent layers:
1. `safety/guardian` — software NaN/limit/watchdog checks
2. FOC overcurrent — software current limit in `0_foc/`
3. Hardware comparator — analog, on Power Blade, works if CPU hangs
4. FPGA dead-time — hardware, prevents shoot-through unconditionally

**Q: Why does the FPGA control the timing instead of the MCU?**
A: The FPGA owns the PWM generation. By triggering the MCU at the PWM
center point, ADC sampling, FOC computation, and PWM update are
inherently synchronized. No phase alignment issues, no missed samples.
The MCU simply responds to each sync event from the FPGA.

**Q: Why not use function pointers for the extension pipeline?**
A: Servo loop runs at 1 kHz. With 100 extensions, indirect calls add
~300 cycles (0.6 µs). C++ templates resolve at compile time — zero
overhead, same binary as hand-written code.

**Q: Is this architecture original?**
A: The principles (layered abstraction, compile-time polymorphism,
hardware contracts) are well-established in embedded systems. The specific
combination — FPGA co-processor with abstracted transport, C++ template
extension pipeline, four-layer safety, hot-swap module architecture — is
designed specifically for this robot and this use case.
