# Preface

In this document, I want to describe a list of components for the boards and explain why I chose this particular component.

# 06.09.2025 "components for axis channel"

* **RS-422** : <SN65HVD75DR> (I chose it because it's cheap, popular, and can handle my high frequency) **Data Rate 20Mbps**

* **Filter** : <simple RC> (I chose it cuz we fight with very fast high frequency signals(spines) and want to protect our square signals ) **10pF + 1kOm**

* **Gate-drivers** : <UCC27201ADDA> (Its fast,cheap and work with 3.3 logic we need this anyway)**Half-Bridge,Vmax:20V,Ipeak:3A**

* **Amplifier** : <INA240> (Cheap monster in this work. High CMRR, Zero-Drift, Wide Bandwidth and price like rice )**A1=20 V/V,A2=50 V/V**

* **ADC** : <STM32G474CEU6> (Cheap and work like expencive ADC but also can in logic work and also rice price)

* **DC/DC(12V)** : <TPS54360BDDAR> (it's cheap as a bolt, but it has 60 V input and 800 mV-58 V output, and 3.5 A is just insane, no questions, we choose it)

* **LDO(3.3V)** : <LM1117-3.3> (no comments for legend)

* **LDO(5V)** : <LM7805> (another legend its just works)

* **N-MOSFET** : <NTMFS3D5N08XT1G> (Its fastest mosfet what i can found and its pretty cheap with good cool body just ideal) **QG=23 nC !!!!** **80V,3mOhms** 

* **N-MOSFET** : <BSC030N08NS5> (Just good and cheap but not fastest if u want u can use it u wellcome)**QG=73nC,80V,3mOhms**

**Comment**
Siting after midnight and very happy cuz i found good silicon rock yeeey ^^! I hope u slept in this weekend night and have a good weekend ty for reading :)