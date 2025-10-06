# 2025-08-13: The Project is Public!

## Milestone
Today, I've made the repository public and started this development log. This marks the official start of the public phase of the project.

## Current Status
The majority of the conceptual CAD work for the core 3-axis mechanics is complete (around the 90% mark). I've been so focused on design iterations and preparing for the first printing tests that I haven't committed the CAD files to the repository yet.

## Next Steps
My immediate goal is to clean up the models and push the complete set of F3D/STEP files to the /cad directory by this Saturday (August 16th).

## Comment
If someone rly see this **hey,have a nice day! :>** i hope what i make that to this saturday cuz with this i need to start making PCB its little scary but we need this to 50 kHz. <Cya> 

## 2025-08-24: Stage II Begins - Electronics & First Working Prototype!

### Milestone
This weekend marks the official start of the electronics development phase. The core mechanical and electronic architectures are now finalized. Most importantly, the first PLA prototype of the 10:1 reducer module was printed, assembled, and **it works flawlessly!**

### Current Status
Following the successful test of the 10:1 reducer, I will be uploading its final STL files to the /manufacturingdirectory. The PDF overview of the electronics architecture is now also available in/hardware/docs.

The initial assembly of the reducer revealed a critical kinematic conflict: the drive did not work. After analysis, I identified a mistake in the clearance calculation for the output flange fingers. The holes in the cycloidal discs were recalculated and enlarged, which completely solved the issue.

### Next Steps
The primary focus now shifts to designing the **Power Blade** electronics. In parallel, I will continue printing and testing the complete mechanical assembly. I'm considering creating a **Telegram channel** to post real-time development updates, including videos and failures. Let me know if you'd be interested!

### Comment & Key Discovery
I have to admit, when the first reducer assembly seized up, I was worried about the entire design. But after thinking through the kinematics, I realized a fundamental principle for balanced cycloidal drives with a rigid output cage.

The standard formula for hole clearance, Hole_Diameter = Pin_Diameter + (2 * Eccentricity), is only valid for a single-disc or independently suspended dual-disc setup.

For a **rigidly connected, balanced (counter-rotating) dual-disc setup**, the required clearance is doubled. The correct formula is:

**Hole_Diameter = Pin_Diameter + (4 * Eccentricity)**

This was a scary realization, as it required making the holes in my very compact reducer significantly larger. However, the design had enough material to accommodate this. After reprinting the discs with the corrected hole diameter, the reducer works perfectly. This is a crucial finding for anyone building this type of drive.

This week, I will try to develop the full Power Blade schematic. And again i write this at midnight... <Cya guys, sleep well>

## 2025-09-02: Little sick but with power blade architecture!

### Milestone
Power blade architecture is DONE! The short shoulder module is printed.

### Current Status
The architecture was a little easy for me because I had been thinking about it for two weeks, so I just sat down and made it. But with printing, I am continuing my war with the 3D printer. It just stopped in the middle of the night while I slept and ruined about 90% of the print. I need to start again and buy more plastic, but the printer is far from me, so I will restart printing next weekend ":/"

### Next Steps
The next step is to totally finish the blade's schematic and start to test it in SPICE programs. In parallel, I need to pick components for the blade. And of course, printing, printing, printing....

### Comment & Key Discovery
All week I was sick, and after work, I just lay in bed and thought about how much I needed to do but couldn't. BUT on the weekend, I was fine and finished the architecture. That was a victory! -^-

## 2025-09-07: POWER BLADE SCHEME IS 90% DONE!!

### Milestone
Power blade scheme is 90% done. Printing new shoulder module.

### Current Status
Updated settings for 3D printer and start printing part of shoulder module again. Ears printed and i think it okay. Today i buyed shafts and other steel staff they gonna come like... 2-3 weeks... I added datasheets and file "components" for (You won't believe it :> ) components for boards and add all components for axis channel. My win today is scheme power blade done on 90% its just need to make footprints and past. Ye i needed to test power blade today in spice program but without footprints its unreal and i dont make it not proud for that..

### Next Steps
The next step is stay same test and finishing scheme and after i can make pcb.

### Comment & Key Discovery
**DAY NOT OVER WHILE I DONT LAY!** 
Weekend again was hard cuz i have no time for help familly and no time for this robotic arm, but i sit here and now is totaly early morning i writing this and go to sleep. Printer is printing night going to over. on this week i will be study and work and free time on week is die. Have a good night guys <cya>

## 2025-09-14: Real-World Assembly & Design Evolution

### Milestone
The first full two-stage reducer prototype was assembled and tested. While encountering critical issues, the tests successfully validated the core kinematic design and led to a significantly improved and more robust architecture.

### Current Status & Key Discoveries
This weekend was dedicated to the first physical assembly of the two-stage balanced cycloidal reducer. The test was a partial success:

    The Good: The core mechanism works. When assembled, all parts fit, and the kinematics are correct — the drive rotates and provides reduction. The new, longer stator pins, when press-fitted (with a hammer), provide excellent structural rigidity without interfering with the cycloidal discs' motion.

    The Bad (Problems Found):

        Structural Failure: The bottom wall of the main reducer shaft proved to be too thin. It cracked and crumbled under the stress of assembly (e.g., inserting an M8 nut).

        Stator Pin Instability: The stator pins were not sufficiently constrained and could be dislodged, leading to mechanism failure.

    The Ugly (Resource Loss): Lost two major prints (~800g of PETG and ~40 hours of print time) this past week due to a corrupted SD card file and suboptimal print settings that caused delamination. This is a painful but valuable lesson in process reliability.

### Design Evolution (The Solutions)
Based on the test results, I've developed a new, more robust design:

    Motor-to-Reducer Coupling: The initial concept for the input shaft was flawed. The final design will be: a pneumatic collet fitting (with metric M6 thread) screwed into a heat-set brass insert in the 3D-printed reducer shaft. The entire assembly will be locked by a transverse pin ("the nail") secured with a retaining ring. This provides a robust, balanced, and modular interface.

    Stator Assembly: The stator pin instability will be solved by:

        Closing the open holes in the stator plates.

        Adding an intermediate stator plate between the two stages for added support.

        Increasing the contact surface area between the stators and the pins.

The CAD models will be updated with these improvements next week. The only potential delay is sourcing the non-standard M6 heat-set inserts.

### Next Steps & Plan Adjustment
The initial plan to start the PCB layout this week is postponed. The unexpected but critical mechanical redesign takes priority.

    This Week (Evenings): Continue with the Power Blade schematic design. The goal is to have it 100% complete by the next weekend.

    Next Weekend: Finalize the mechanical redesign in CAD and begin printing the new, improved parts.

    Documentation: I will update the repo with the final printer settings, add component libraries, etc.

### Comment
This was the first major "slip" in the schedule due to the demanding university timetable and unforeseen design flaws. I had planned to be working on the schematic this weekend but spent almost all of it on mechanical assembly and problem-solving. This is frustrating but also incredibly productive. The design is now an order of magnitude better.

In same situations i remember this quote:

    You know, the world isn't run by the laws written on paper. It's run by people. Some according to laws, others not. It depends on each individual how his world will be, what he will make of it... I dreamed of fortunes, cars, freedom, women, respect... I got it all more or less, but with it came prison, constant fear, and the blood of my comrades.

    — Mafia: The City of Lost Heaven

But unlike that story, **we don't give up so easily.** There is more to come and rest will be after revolution in robots :)

Thanks for following along. <Cya guys!>

## 2025-09-15: little steps 

### Milestone
I finished schematics for components everything except `ADC` and add `PRINTER.md` to docs 

### Comment

**I think for little commits on week i will be use milestones and comments, cuz i cant doing many work for my robot and u can see other information like next steps u can see upper.**

For today i maked 2 scheme of components DC/DC and LDO 5V and i bought components for connect reducer shaft and motor shaft. after they come i assembly reducers and test it and i think now that will be immortal connection ~~(sounds like joke)~~ but anyway we can see it later. For other i add my config for 3d printer to `docs/guides/PRINTER.md` u can check what settings i using for printing mb its can help u :)

## 2025-09-16: schematics for components are completed !!!

### Milestone
I completed scheme for STM32G4 and add all schematics to repository !!!!!

### Comment
So so so that was too long for one component but all functions for every pin from datasheet in schem and that now have footprint. 
I change MC cuz i little mistake with price for `STM32G474CEU6` u can read about that to `hardware/docs/components.md`. time to sleep.. <Cya>

# 2025-09-23: Principle scheme is complete!

## Milestone
Completed the schematic; simulations and printing are underway

## Current Status
I completed the schematic, started printing the second part of the shoulder module, and successfully assembled the shoulder module on the shaft. I also started the simulation using the INA240 in LTspice

## Next Steps
Finish simulations and start PCB design and create a Telegram channel

## Comment
This weekend was tough: I started around 9:00 PM and worked until about 4:30 AM on Saturday and 5:00 AM on Sunday. On Monday I worked and fixed the schematic — the pin headers for the joke turned out to be harder than 60% of the circuit design. I spent 4 hours figuring out how to use PCI — it's just a connector I can use for the board. Before that I considered a mezzanine connector but couldn't find one compatible with my board that didn't cost almost as much as the whole board with all components. Now we're using PCI at a reasonable price. During the week I will create a Telegram channel to document activity like videos and fails, since using Git for that is inconvenient; I'll be there all week.

# 2025-09-23: Simulation INA240 are complete!!!!

### Milestone
* Add all spice schematics for axis channel blade
* Create directory `simulatons` 
* Made 4 simulations for `INA240` amplifier.
* Made telegram channel 

### Comment
All week i working and afer work i just lay and its all what i did and that will be true if i was a just good worker who woudnt sleep tomorrow, for that after work maked simulations and learn LTspice...khm.. i working in this program before but with simple simulations and now i tryed be serios so today we have complete simulation for first component! <Good night~>

# 2025-09-28: ALL SIMULATIONS COMPLETE. STARTING PCB!!!!

## Milestone
Completed all simulations and the final schematic for the Axis Channel. Remodeled the head of the shoulder module and the shaft for the 10:1 reducer.

## Current Status
- **Simulations:** Successfully completed and verified the DC/DC, Current Amplifier, and Half-Bridge circuits.
- **Documentation:** Created a guide on how to import SPICE models.
- **CAD:** Remodeled the shoulder modules and the reducer shaft. Started printing the main shoulder part.

## Next Steps
- **Start the PCB layout** for the Axis Channel blade.
- **Finish** the CAD models for the reducer and shoulder assembly.

## Comment

I thought the simulations would be the easy part - just load models and run. The DC/DC simulation, on the other hand, was done in 30 minutes. The half-bridge, however, took an entire day just to get it to work at all.

In the end, I got the basic simulation running and saw the square waves, which is a success. Honestly, I hoped to simulate a real "hell" scenario for it with all the parasitics and protections, but that's a project in itself, and I just don't have that much time to spend only on simulations.

So I made a pragmatic engineering decision: I based the final schematic on proven reference designs from datasheets and application notes, using LTspice just for a basic "does it switch?" sanity check, without the deep, "hard tests". It's a calculated risk, but a necessary one to move forward.

Now, I continue my war with the reducer models. It needs so many iterations of printing parts, which is not easy when I can only print 2 days a week. I spent most of this weekend just modeling because I messed up the sizes for the main shaft bearing... I don't know how it happened, but it is what it is.

So, time is again not on my side. Looks like another night of 4 hours of sleep... Thanks for your attention, have good dreams :)

# 2025-10-06: SCHEMATICS ARE DONE. PCB HELL BEGINS.

## Milestone
* Started printing the lower part of the long shoulder module.
* Configuration of Altium for starting the PCB is over.
* Created all remaining components for the Axis Channel blade with their footprints.
* Imported all components into the PCB project.

## Current Status
- **Schematics:** Replaced all default Altium components with my own custom ones.
- **Libraries:** Built a complete library with every single component for the Axis Channel blade.
- **PCB:** The PCB file is created. The board outline is set to 100x100mm. The layer stack is defined. All components have been imported.

## Next Steps
- **PCB:** FINALLY START IT!!!!!
- **CAD:** Continue printing and assembling parts.
- **LTspice:** Run one or two more simulations for the LDOs.

## Comment

It's 3:40 AM on a Monday morning.... **[dying sounds]**

That was insane, really. So many hours creating footprints, hunting for datasheets, and fighting with Altium settings. But it's finally over. We are starting a new part of this strange story!

**AND for now!!!** <Have a good night, guys :)>