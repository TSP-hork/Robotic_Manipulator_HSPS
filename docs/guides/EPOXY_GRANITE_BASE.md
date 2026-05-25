# DIY Epoxy Granite Robot Base: Casting Guide & Mistakes

## 1. Introduction & Philosophy

This guide covers the process of casting a heavy (around 55 kg) epoxy granite base for a robotic manipulator. The core philosophy here is mass, vibration dampening, and using accessible materials. 

This is a very dirty, physical process. I did it outside, and you should too (or at least in a very well-ventilated area). I made some mistakes along the way, so this guide includes not just what to do, but what *not* to do, based on my actual build. 

If you have patience and don't mind getting your hands dirty, you can reproduce this and get an indestructible base that costs a fraction of a cast iron one.

Lets start!

---

## 2. Safety & Preparation

This is not a clean indoor project. 
*   **Work outside:** Epoxy can smell, and the dry powders will get everywhere.
*   **Wear gloves:** I didn't wear gloves at first and mixed the heavy aggregate with a small garden hoe. I ended up with blisters and swollen hands by the end of the day. Epoxy is also extremely hard to wash off your skin. Use thick construction or nitrile gloves.
*   **Tools:** Assume whatever you use for mixing (like my garden hoe or buckets) will be permanently covered in a layer of epoxy. Don't use your favorite tools.

---

## 3. Materials & Proportions

The total weight of my base is around 53-55 kg. The goal is to fill all gaps: large stones form the skeleton, sand fills the gaps between stones, and quartz flour fills the micro-gaps.

**The 55kg Recipe:**
*   **Epoxy Resin with Hardener:** 5 liters/kg (I used tabletop epoxy because it was cheaper and cures slower, giving me 48 hours. Construction epoxy works too).
*   **Gravel/Crushed Stone:** 25 kg. I bought landscaping gravel from a local supply yard. I used 5-20mm, but honestly, I highly recommend using 5-10mm. It will make the mixing process much easier and more uniform.
*   **Quartz Sand:** 15 kg. You can get this at hardware stores (used for sandblasting or pool filters).
*   **Quartz Flour:** 10 kg. Ordered from a marketplace. It is literally like flour and will coat every surface around you.

**Preparation:**
Wash all your gravel to remove dirt. I washed mine and left it outside to dry in the sun (since I wasn't allowed to use the oven). It must be 100% dry before mixing.

---

## 4. The Mold: Design & Dimensions

I originally used a 90-liter plastic tub as the outer shell, but in hindsight, don't buy a tub. The cheapest and best way is to make the entire mold out of PET plastic sheets, tape it together, and just destroy it after the cast.

*   **Material:** Buy PET plastic sheet. I used 0.5mm, and it was barely enough. Ideally, use 1mm thick PET. It will solve a lot of deformation problems.
*   **The Flat Patterns (Unfolding):** If you are building the mold purely out of PET for a base with a 50cm bottom, 27cm top, and 22cm height, you need to cut three specific shapes.
    *   **Bottom Base:** Cut a simple flat circle with a 50 cm diameter. 
    *   **Inner Tube (15 cm diameter):** This is a rectangle. The circumference is 47 cm, plus 5 cm for overlap. Cut a piece 52 cm long and 25 cm high.
    *   **Outer Cone:** A truncated cone unrolls into a "rainbow" shape. Make a DIY compass: take a pushpin with a plastic handle (it sticks into PET really well), tie a piece of string to it, and tie a marker to the other end. Stick the pin in the plastic. Draw the first inner arc at a radius of 33.5 cm. Draw the second outer arc at a radius of 56 cm. Measure exactly 157 cm along that outer arc (this is your 50 cm base circumference), add 8-10 cm for the overlap, and mark your cut lines to the center.
*   **Cutting:** Use garden shears or good scissors. The trick for 0.5mm PET is to take it on a slight bend/angle and slice through it like paper or fabric. It cuts pretty easily this way.
*   **Assembly & Sealing:** Roll the tube and the cone, aligning your overlap marks. Do NOT use silicone sealant. I tried it, it failed completely, and my mold started floating up during the pour. Tape all vertical seams and the bottom joints (where the cone and tube meet the flat base circle) tightly with 2-4 layers of clear or reinforced duct tape. 
*   **Inner Tube Warning:** The pressure of the heavy stones pushed my central PET tube inward, making the center hole much smaller. You must reinforce it. Put something solid and round inside it during the pour.
*   **Release Agent:** I smeared Solidol (grease) all over the inside. Don't rely heavily on grease. The most reliable method is to just line the inside of the mold with a single layer of packing tape. The epoxy will peel right off.

---

## 5. The Embedded Hardware

To mount the robot (or the slewing drive/bearing), you need threads cast into the stone.
*   I bought M6x80mm bolts. 
*   Threaded a ton of regular nuts onto them (about 15 nuts per bolt).
*   Put the bolts through a 3D-printed template.
*   **Smear the bolt threads completely in Solidol/grease** so the epoxy doesn't lock them. (They unscrewed perfectly later).

If your mold deforms (like mine did, losing some height), your template might end up sitting directly on the inner PET tube and not touching the epoxy with its flat surface. Tape the bottom of your template just in case it touches the wet mix.

---

## 6. Mixing Methodology

**CRITICAL: Mix all dry ingredients together first.**
I ended up with about 5 buckets of dry mixed aggregate. If you add epoxy to unmixed powders, the epoxy instantly absorbs into the flour, creating impossible lumps, and you'll be trying to transfer epoxy from these lumps onto dry rocks.

**Do it in 5 batches:**
I did exactly 5 separate mixes to avoid the epoxy boiling and to make it physically manageable.
For each batch:
1. Scoop out a proportional amount of your pre-mixed dry aggregate.
2. Weigh exactly 1 kg of mixed epoxy (resin + hardener) on a scale.
3. Combine and mix thoroughly. 

---

## 7. Pouring, Vibrating, and Leveling

*   **Vibration is key:** For the first few layers, I placed my mold directly on the housing of my bench grinder. The vibration was incredibly strong, and the mixture flowed and leveled out like a pure liquid. 
*   **Tamping:** For the later layers, the mold was too heavy to lift onto the grinder, and I had less epoxy ratio in the mix. I had to pack it down manually with a stick. If you have a concrete vibrator or a vibrating table, use it.
*   **Leveling:** When inserting the bolt template at the top, you need to level it. I placed my phone on top of the template and used a level app. I got it to about 1 degree. Since the robot arm uses software calibration anyway, 1 degree of physical tilt is perfectly fine. 

---

## 8. Demolding & Final Results

Since I used tabletop epoxy, it cured for 48 hours.

Because my tub wasn't perfectly greased, the base got slightly stuck. I had to sharply flip the 90L tub upside down on the street to get the 53+ kg donut to fall out. (If you build the mold entirely out of taped PET sheets as described above, you can just cut the tape and peel the plastic away without this struggle).

Extracting the bolts from the template was a bit tricky. My 15-hour 3D printed template cracked from the tension of a rising bolt when I was unscrewing them, so I just smashed it with a hammer to speed things up. 

Because my central PET tube had collapsed inward, I had to work like a stonemason with a hammer and chisel to clear the hole. I hit it with severe force, and the epoxy granite didn't care at all. The material is brutally strong. The sides and bottom against the PET came out incredibly smooth and void-free.

That's it. Cut the PET, mix dry first, use smaller gravel, and vibrate well. You will get a massive, dead-solid base for your machine.