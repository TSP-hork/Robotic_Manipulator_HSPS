# GUIDE.md

Simulations are easy but have some strange things, like how to add new components. Here's how to do it.

# How to make a simulation

1.  **Clone my repo -^- and just use all my stuff, or...**

2.  Download `LTspice` and open it up.

3.  Download SPICE models from `ti.com` or a similar site.

    *   Just search for your component on their site.

    *   Find the **"Design & development"** or **"Design tools & simulation"** tab.

    *   You need to find the **Unencrypted PSpice Transient Model**. ~~(trans model)~~.

    *   After downloading the `.zip`, find the `YOUR_COMPONENT.lib` file inside.

4.  Now you have a `.lib` file with the model. **Open this `.lib` file with LTspice.**

5.  You'll see a scary file with many scary words. Scroll down until you find the line starting with:
    `**.SUBCKT .... ..... .....**`
    *   *For example, the gate driver's line looks like this:*
        `.SUBCKT UCC27201_TRANS HI VDD LI HB HO HS LO VSS`

6.  **Right-click on this `.SUBCKT` line** and choose **`Create Symbol`**. A window will pop up, just say `Yes`.

7.  Last step is just save this component to /Documents/LTspice/.. and now u have component in LTspice!

8.  Now you can run the simulation! You're great :)

