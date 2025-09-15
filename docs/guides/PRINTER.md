# HSPS Project: Printing Configuration & Replication Guide

## 1. Introduction & Philosophy

This guide provides the exact slicer settings and printing methodology used to create the strong, dimensionally accurate mechanical parts for the HSPS Robotic Manipulator.

The core philosophy is **Strength and Accuracy over Speed**. The goal is not to print fast, but to produce engineering-grade components. Please keep in mind that this is my personal, tested configuration; for your specific printer and filament, some values might need adjustment.

I encourage you to use these settings as a strong starting point. I've tested them, and they produce truly strong parts. It's an interesting and straightforward process, and you can do it too! All you need is time and filament. (I use cheap filament, around $5-6 per kg, so I believe anyone with a 3D printer can afford to experiment and succeed :>)

After some time, I might update this file with new findings, but for now, I consider these settings final and will be printing all core components with them.

I bet anyone can repeat this, because if I could do it (with almost no prior printing experience), you can too!

Lets start!
---

## 2. Hardware & Software Baseline

*   **Printer Model:** Creality Ender 3 v3 SE (Stock)
*   **Nozzle:** Standard Brass 0.4mm
*   **Slicer:** OrcaSlicer (This guide is based on Version 2.3.0)

---

## 3. CRITICAL Pre-Print Ritual: Filament Preparation

This is the most important step. PETG is extremely hygroscopic.
*   **Action:** **ALWAYS dry your PETG filament** before any critical print (65°C for 6-8 hours is recommended).

---

## 4. OrcaSlicer Configuration: Step-by-Step

To replicate the setup, create a new set of profiles and input the following parameters precisely.

### 4.1. Printer Profile (`Creality Ender-3 V3 SE 0.4 nozzle`)

#### Extruder 1 Tab:
*   **Retraction -> Length:** `0.8 mm`
*   **Retraction -> Retraction Speed:** `40 mm/s`
*   **Z Hop -> Z hop when retracting:** `0.2 mm`
*   **Z Hop -> Z hop type:** `Spiral`

### 4.2. Filament Profile (`PETG1`)

#### Filament Tab:
*   **Flow Ratio:** `0.96` (or your calibrated value, `1.05` for extra strength)
*   **Pressure advance (PA):** `0.05` (or your calibrated value)
*   **Temperature -> Nozzle -> First layer:** `250 °C`
*   **Temperature -> Nozzle -> Other layers:** `240 °C`
*   **Temperature -> Bed -> First layer:** `85 °C`
*   **Temperature -> Bed -> Other layers:** `75 °C`
*   **Max volumetric speed:** `9 mm³/s`

#### Cooling Tab:
*   **Keep fan always on:** `Enabled`
*   **Fan Speed -> Min fan speed:** `30 %`
*   **Fan Speed -> Max fan speed:** `30 %`
*   **Slow down for better layer cooling:** `Enabled`
    *   **Slow down if layer print time is below:** `15 s`
    *   **Min print speed:** `20 mm/s`
*   **Overhang Fan Speed -> Fan speed for overhangs:** `60 %`

### 4.3. Process Profile (`PETG_STRENGTH`)

#### Quality Tab:
*   **Layer height:** `0.2 mm`
*   **Initial layer height:** `0.2 mm`
*   **Extrusion width -> Outer wall:** `0.42 mm`
*   **Extrusion width -> Inner wall:** `0.45 mm`
*   **Extrusion width -> Infill:** `0.45 mm`
*   **Seam -> Seam position:** `Random`
*   **Wall generator:** `Arachne`
*   **Wall generator -> Wall transition threshold angle:** `59 °` (just max cuz that help fill 100%)
*   **Wall generator -> Number of wall transitions:** `4` or `5`
*   **Wall generator -> Minimal perimeter width:** `25 %`
*   **Perimeters -> Wall sequence:** `Inner/Outer`

#### Strength Tab:
*   **Wall loops:** `5`
*   **Top shell layers:** `5`
*   **Bottom shell layers:** `5`
*   **Sparse infill density:** `100 %`
*   **Sparse infill pattern:** `Rectilinear`
*   **Infill/Perimeter Overlap:** `30 %`
*   **Infill after perimeters:** `Disabled` 

#### Speed Tab:
*   **Outer wall:** `35 mm/s`
*   **Inner wall:** `45 mm/s`
*   **Sparse infill:** `50 mm/s`
*   **Initial layer:** `20 mm/s`
*   **Initial layer infill:** `20 mm/s`
*   **Number of slow layers:** `3`

---