This document outlines the core hardware architecture and key component decisions for the project.
*If I write it 100 times, I won't forget it ~~(but that might not be true)~~.*

## 2025-08-14: Hardware Architecture Decisions

* **System Architecture:** The core control system will be a **unified motherboard**. This board will house the primary MCandFPGA, and provide standardized **blade ports** for connecting to the external **power stages** and other peripherals.

* **Performance Target:** The architecture is designed with a future performance target of **200+ kHz** for the core control loop, ensuring a high ceiling for future optimizations.

* **Core Philosophy:** A hybrid **MC + FPGA** approach. The microcontroller acts as the "smart" commander for high-level tasks, while the FPGA serves as the "fast and strong" hardware accelerator for real-time control loops.

* **Microcontroller (MC):** STM32H7A3. Chosen for its powerful Cortex-M7 core, large SRAM, and sufficient processing power to handle kinematics and trajectory planning without becoming a bottleneck.

* **FPGA:** Lattice ECP5, LFE5U-45F. This chip is selected for its excellent balance of price and performance. With **44K LUTs**, it has more than enough resources to implement six parallel, **hardware-accelerated FOC cores**, leaving significant potential for future features.

* **power on mainboard** POWER on board going from board with stabilizators, filters and maybe little MC who just watch for safe all board and stop the current if he is very high. And in future i want only 48 V for step down on blades(if that needs) and mother board.

* **power on input board** POWER on this board comming from any POWER supply who can give 300 W +- or any other count of W 

* **Input board** Thats board is not very smart. with simple MC and passive components who stabilize and filter input POWER.
Is step up or step down supply and send it to main board on two wire VCC and GND. Mb in very far future i make uart for errors from this stage but i think one LED is over and enough.

* **outcontrol blade** is technologist in my system, he can be very smart or very ..khm he can be SD and just talking simple commands, or its can be computer with cam with AI who can talk with this world of any protocol, but with arm he talking on speed of electricity (i just like how its sounds).

* **between FPGA and blade** While i dont forgeted, FPGA not strong enough for control blades and he need a help. For this on road from his leg to blade we need dif converter (working on RS-422) who can send his messages without noices to gate driver. This guy can control strong MOSFETs very fast and he is cheap we accept him to our team. 

## 2025-08-24: the architecture of my electronics

* **main date** so today i start develop my electronics, and start print mechanic. I add new directory to docs for top_sheet. i think i need develop electronics parralel work cuz develop electronics need more time for think than act. Have a good last days of summer -^-