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