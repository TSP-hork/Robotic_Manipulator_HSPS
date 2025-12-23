# Project Components Bible

This document contains a curated list of all components used in the project, with technical specifications and the reasoning behind each choice.

---

# Axis Channel Blade

This section details all components for the modular Axis Channel power blade.

## Power Supply
### DC/DC Converters: TPS54360BDDAR

#### TPS54360BDDAR
- **Type:** Step-Down DC/DC Converter
- **Specs:** 60V max input, 3.5A output
- **Comment:** *It's cheap as a bolt, but it has a 60V input and a 3.5A output, which is just insane. No questions, we're choosing it.*

### LDO (+3.3V): TLV1117-33IDCYR

#### TLV1117-33IDCYR
-   **Type:** Low-Dropout Regulator
-   **Specs:** 3.3V output, 800mA max current, **Stable with Ceramic Capacitors**.
-   **Comment:** *(no comments for legend)*

- **updated: 2025-11-18** BUT LEGEND DONT WORK WITH CERAMIC and when its will be on the plate it will generate many noise. be carefull rly. Just no need to use *

#### LM1117-3.3
-   **Type:** Low-Dropout Regulator
-   **Specs:** 3.3V output, 800mA max current.
-   **Reason for Rejection:** *LEGEND DONT WORK WITH CERAMIC and when its will be on the plate it will generate many noise. be carefull rly. Just no need to use*

### LDO (+5V): LM7805 (DPAK/TO-252)

#### LM7805 (DPAK/TO-252)
- **Type:** Linear Voltage Regulator
- **Specs:** 5V output, 1.5A max current
- **Comment:** *Another legend. It just works.*

### Power Inductors for DC/DC : MWSA0603S-4R7MT

#### MWSA0603S-4R7MT
- **Specs:** 33mΩ 4.7uH 6A 9A ±20%
- **Price:** ~$0.11


#### NPIM74C4R7MTRF
- **Specs:** 4.7uH, 5.5A Saturation Current
- **Price:** ~$0.8

---

## Power Stage & Drivers 
### N-Channel MOSFET: NTMFS3D5N08XT1G

#### NTMFS3D5N08XT1G
- **Type:** Power MOSFET, SMD
- **Specs:** 80V, 3mOhms, Qg = 23nC
- **Comment:** *It's the fastest MOSFET I could find, it's pretty cheap, and has a good thermal package (SuperSO8). Just ideal. The Qg of 23nC is insane!*

#### BSC030N08NS5
- **Type:** Power MOSFET, SMD
- **Specs:** 80V, 3mOhms, Qg = 73nC
- **Comment:** *Just a good and cheap alternative, but not the fastest. If you want, you can use it, you're welcome.*

### Gate Driver: IRS21867S 

#### IRS21867S (Infineon / International Rectifier)
-   **Type:** High and Low Side Driver
-   **Specs:** 600V Max, **4.0A / 4.0A** Peak Current, 3.3V/5V Logic Compatible.
-   **Comment:** *Cheap (0.60$). good specs. over 5k in stock. why not*

#### UCC27282DR (Texas Instruments)
-   **Type:** Half-Bridge Gate Driver
-   **Specs:** 120V Max, 3A Peak Current, 3.3V/5V Logic Compatible, **Input Interlock**.
-   **Reason for Rejection:** *Too expensive.... (on JLCPCB 1$) and only 3A*

#### NCP5106BDR2G (OnSemi)
-   **Type:** Half-Bridge Gate Driver
-   **Specs:** 600V Max, 0.25A/0.5A Peak Current, **100ns internal Dead-Time**.
-   **Reason for Rejection:** *Initially looked like a great cheap and safe option due to the fixed hardware dead-time. However, a deeper look into the datasheet revealed the **output current is too low (0.5A)**. This would lead to slow switching times and massive overheating of the MOSFETs at our target frequencies. A critical flaw.*

#### UCC27201ADDA (Texas Instruments)
-   **Type:** Half-Bridge Gate Driver
-   **Specs:** 20V Max, 3A Peak Current, 3.3V Logic Compatible.
-   **Reason for Rejection:** *This was the first "ideal" candidate. It's powerful and compatible. However, its price is significantly higher (~$1.2+) than comparable or even superior alternatives from other manufacturers.*

#### UCC27282DR-JSM 
-   **Type:** Half-Bridge Gate Driver (Clone)
-   **Specs:** 250V Max, 4A Peak Current, Fixed 250ns Dead-Time.
-   **Reason for Rejection:** *The specs looked good, but this is a clone from a lesser-known Chinese manufacturer (JSMICRO) with a Chinese-only datasheet. I was concerned about long-term availability and reliability. If this driver dies, I don't know where I would find a replacement. So, I just continued my search for a more standard, tier-1 component.*

#### TC4424A (Microchip)
-   **Type:** Dual Low-Side Driver
-   **Specs:** 18V Max, 4.5A Peak Current.
-   **Reason for Rejection:** *Fundamentally unsuitable. This is **not a half-bridge driver**. It cannot drive the high-side MOSFET in our configuration as it lacks a bootstrap circuit. It would be instantly destroyed.*

---

## Measurement & Feedback
### Current Sense Amplifier: INA240A1DR

#### INA240A1DR
- **Type:** Zero-Drift, High-Side/Low-Side Current Sense Amplifier
- **Specs:** Gain = 20 V/V
- **Comment:** *A cheap monster for this job. High CMRR, Zero-Drift, Wide Bandwidth, and a price like rice.*

### Current Sense Shunt Resistor: WSLP25125L000FEA

#### WSLP25125L000FEA
- **Type:** Metal Strip Current Sense Resistor
- **Specs:** 5mOhms, 3W, 1%
- **Comment:** *Just 3 Watts, just cheap, just 1% tolerance. Perfect.*

### ADC & On-Board Logic: STM32G431RBT6

#### STM32G431RBT6
- **Type:** Microcontroller with advanced analog peripherals
- **Specs:** 3x Synchronizable 12-bit ADCs, Cortex-M4 @ 170MHz
- **Comment:** *It's cheap and works like an expensive ADC, but it can also handle logic tasks. The price is like rice. I initially made a mistake and almost ordered the more expensive G474, thinking it was $2. Don't repeat my mistakes, always re-check part names!*

---

## Interface
### RS-485 Transceiver: SN65HVD75DR

#### SN65HVD75DR
- **Type:** 3.3V RS-485/RS-422 Transceiver
- **Specs:** 20 Mbps, 16kV ESD Protection
- **Comment:** *Cheap, popular, can handle my high frequencies, and robust enough for hot-swapping.*

### Input Filter (Encoder): Simple RC Filter

#### Simple RC Filter
- **Type:** Passive Low-Pass Filter
- **Specs:** R=330 Ohm, C=33 pF
- **Comment:** *Chosen because we need to fight very fast high-frequency signals (spikes) and protect the clean square waves from the encoders.*

---

# Motherboard

## Main Connector (Blade Slot): 10018784-10202TLF

#### 10018784-10202TLF
- **Type:** PCIe x8, 98-position, Vertical, Through-Hole Card Edge Connector
- **Comment:** *Spent 4 hours just to find any solution, and using a standard PCIe connector is the only thing I can think of that's cheap, fast, and widely available. I realized 64 pins wasn't enough, so I upgraded to 98.*

---

# Input Board

*(Components for this board will be detailed later)*