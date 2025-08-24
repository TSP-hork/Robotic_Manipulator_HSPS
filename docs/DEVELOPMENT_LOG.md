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