**comment{14.08.25}** : I think thats be hardest Readme in all project.....

---

## Printing Guidelines & Settings

To ensure the mechanical strength, dimensional accuracy, and reliability required for this project, all parts must be printed with specific settings. These settings have been tested on a **Creality Ender 3 v3 SE**, but the principles apply to any well-calibrated FDM printer.

Do not rush the printing process. **Print quality is far more important than print speed.** Using incorrect settings will result in weak, inaccurate parts that will fail under load.

### 1. Filament Preparation is CRITICAL

**PETG is highly hygroscopic (absorbs moisture from the air).** Printing with "wet" PETG is the number one cause of weak, brittle parts with poor layer adhesion.

*   **Action:** **ALWAYS dry your PETG filament** for 4-6 hours at ~65°C before printing critical components. A dedicated filament dryer is highly recommended.

### 2. General Slicer Settings (OrcaSlicer Recommended)

These settings form the base for all prints. Two main profiles are used: one for fast prototyping and one for final, strong parts.

| Parameter | **PLA (Fast Prototypes)** | **PETG (FINAL MECHANICAL PARTS)** | Notes |
| :--- | :--- | :--- | :--- |
| **Layer Height** | `0.2 mm` | `0.2 mm` | The best balance of speed and strength. |
| **Wall Loops / Perimeters**| 3 | **5 (Minimum)** | **This is the most critical parameter for strength.** |
| **Top/Bottom Shell Layers**| 4 | **5** | Creates solid, durable surfaces. |
| **Infill Percentage** | 15-20% | **100%** | All final parts must be solid. |
| **Infill Pattern** | Gyroid / Cubic | `Rectilinear` or `Monotonic` | Best for solid, predictable infill. |
| **Seam Position** | Aligned | `Aligned` or `Back` | Hides the seam in a corner for better aesthetics. |
| **Supports** | As needed | **NONE.** | All parts are designed to be printed without supports. |
| **Adhesion** | Brim | **Brim (5-8 mm)** | Essential for preventing warping and ensuring dimensional accuracy. |

### 3. Speed Settings (Slow and Steady Wins the Race)

| Parameter | **PLA (Fast Prototypes)** | **PETG (FINAL MECHANICAL PARTS)** |
| :--- | :--- | :--- |
| **Outer Wall** | 60-80 mm/s | **30-40 mm/s** |
| **Inner Wall** | 80-100 mm/s | **40-50 mm/s** |
| **Infill** | 100-120 mm/s | **50-60 mm/s** |
| **Initial Layer** | **20-25 mm/s** | **20 mm/s** |

### 4. Filament-Specific Settings (Calibrate These Yourself!)

These settings depend on your specific brand of filament. Use the calibration tools in OrcaSlicer to find your ideal values.

| Parameter | **PLA (Example)** | **PETG (Example)** | Notes |
| :--- | :--- | :--- | :--- |
| **Nozzle Temperature**| 195-210 °C | **235-245 °C** | Print hotter for PETG to maximize layer adhesion. |
| **Bed Temperature** | 50-60 °C | **70-80 °C** | |
| **Part Cooling Fan** | 80-100% | **20-40% (VERY LOW)**| **Critical for PETG strength.** Too much cooling causes poor layer bonding. |
| **Flow Ratio** | Calibrated (~0.98) | Calibrated (~0.95) | Essential for dimensional accuracy. |
| **Pressure Advance** | Calibrated (~0.04) | Calibrated (~0.06) | Essential for clean corners and seam quality. |

---