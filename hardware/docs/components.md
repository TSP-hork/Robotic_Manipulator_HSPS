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

* **LDO(3.3V)** : <TLV1117-33IDCYR> it's can work with ceramic capasitors and have better characteristics then lm1117. And it's pretty cheap. 

* <LM1117-3.3> (no comments for legend) 
**updated: 2025-11-18** BUT LEGEND DONT WORK WITH CERAMIC and when its will be on the plate it will generate many noise. be carefull rly. Just no need to use 

* **LDO(5V)** : <LM7805> (another legend its just works)

* **N-MOSFET** : <NTMFS3D5N08XT1G> (Its fastest mosfet what i can found and its pretty cheap with good cool body just ideal) **QG=23 nC !!!!** **80V,3mOhms** 

* **N-MOSFET(similar)** : <BSC030N08NS5> (Just good and cheap but not fastest if u want u can use it u wellcome)**QG=73nC,80V,3mOhms**

* **inductors for DC/DC** : 
    * <NPIM74C4R7MTRF> 4.7uH 5.5A <0.8$>
    * <IHLP2020CZER4R7M11> 4.7 uH 4.5A <0,7$>
    

**Comment**
**2025-09-07** : Siting after midnight and very happy cuz i found good silicon rock yeeey ^^! I hope u slept in this weekend night and have a good weekend ty for reading :)

**Comment**
**2025-09-16** : I change ADC from `STM32G474CEU6` to `STM32G431RBT6` cuz second is cheapest and have same 3 parallel ADC. we anyway want just this function and strengh is not priority for that. `STM32G431RBT6` will work like 20% of max power and for `STM32G474CEU6` its mb 12-15%. But why i really change ADC is my mistake, i dont know how but i found `STM32G474CEU6` with price 2$ and now i tryed found it again and found only prices over 6$ i think google give me price for another MC (i think price for  `STM32G431RBT6` cuz it 2$) and i dont checked name for MC cuz was happy for this low price, dont repeat my mistakes recheck names for MC

**Comment**
**2025-11-18** : I discovered this at the final routing stage. The LM1117 requires output capacitors with a specific ESR (Equivalent Series Resistance), typically found in tantalum capacitors. Using low-ESR ceramic capacitors will cause it to oscillate and generate massive noise on the output.
**WARNING** : If you use an LM1117 with only ceramic caps, your circuit WILL NOT WORK. Be really careful. Just don't use it in new designs.

# 22.09.2025 "components for MOTHERboard"

~~* **slot for blade** : `10018783-10201TLF` (just cuz it cheapest fastest and just can be bough.  rly i spent 4 hours for just found any solution and use `PCI` is only what i can :/ )~~

**comment**
**25.09.25** : 64 pins is not enough i think i will pick PCI with 80+ but change schematic later sry

**comment**
**28.09.25** : We will use spice model from TI for similar MOSFET cuz they have same characteristics 

* **slot for blade** : `10018784-10202TLF` 98 pos PCI 