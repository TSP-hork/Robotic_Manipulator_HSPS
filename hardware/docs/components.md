# Preface

In this document, I want to describe a list of components for the boards and explain why I chose this particular component.

# 06.09.2025 "components for axis channel"

* **RS-422** : <SN65HVD75DR> (I chose it because it's cheap, popular, and can handle my high frequency + we can use hot swap with it) **Data Rate 20Mbps**

* **Filter** : <simple RC> (I chose it cuz we fight with very fast high frequency signals(spines) and want to protect our square signals ) **10pF + 1kOm**

* **Gate-drivers** : <UCC27201ADDA> (Its fast,cheap and work with 3.3 logic we need this anyway)**Half-Bridge,Vmax:20V,Ipeak:3A**

* **Amplifier** : <INA240> (Cheap monster in this work. High CMRR, Zero-Drift, Wide Bandwidth and price like rice )**A1=20 V/V and +-6.75 mohm for shunt**

* **Shunt** : <WSLP25125L000FEA> (just `3W` just `cheap` just `1%` just 5mohm )

* **ADC** : <STM32G431RBT6> (Cheap and work like expencive ADC but also can in logic work and also rice price)

* **DC/DC(12V)** : <TPS54360BDDAR> (it's cheap as a bolt, but it has 60 V input and 800 mV-58 V output, and 3.5 A is just insane, no questions, we choose it)

* **LDO(3.3V)** : <LM1117-3.3> (no comments for legend)

* **LDO(5V)** : <LM7805> (another legend its just works)

* **N-MOSFET** : <NTMFS3D5N08XT1G> (Its fastest mosfet what i can found and its pretty cheap with good cool body just ideal) **QG=23 nC !!!!** **80V,3mOhms** 

* **N-MOSFET(similar)** : <BSC030N08NS5> (Just good and cheap but not fastest if u want u can use it u wellcome)**QG=73nC,80V,3mOhms**

**Comment**
**2025-09-07** : Siting after midnight and very happy cuz i found good silicon rock yeeey ^^! I hope u slept in this weekend night and have a good weekend ty for reading :)

**Comment**
**2025-09-16** : I change ADC from `STM32G474CEU6` to `STM32G431RBT6` cuz second is cheapest and have same 3 parallel ADC. we anyway want just this function and strengh is not priority for that. `STM32G431RBT6` will work like 20% of max power and for `STM32G474CEU6` its mb 12-15%. But why i really change ADC is my mistake, i dont know how but i found `STM32G474CEU6` with price 2$ and now i tryed found it again and found only prices over 6$ i think google give me price for another MC (i think price for  `STM32G431RBT6` cuz it 2$) and i dont checked name for MC cuz was happy for this low price, dont repeat my mistakes recheck names for MC

# 22.09.2025 "components for MOTHERboard"

* **slot for blade** : `10018783-10201TLF` (just cuz it cheapest fastest and just can be bough.  rly i spent 4 hours for just found any solution and use `PCI` is only what i can :/ )

**comment**
**25.09.25** : 64 pins is not enough i think i will pick PCI with 80+ but change schematic later sry

**comment**
**28.09.25** : We will use spice model from TI for similar MOSFET cuz they have same characteristics 