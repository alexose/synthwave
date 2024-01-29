# Alex's Guide to DIY Carbon Paper Electrodes

## Introduction

Carbon paper electrodes are a good starting point for many electrochemical experiments. While there are many styles,
these ones lend themselves to DIY production.

In this examples, we will be creating two types of electrodes. One made with bismuth powder, and the other with silver
chloride powder. These happen to be the same types needed for [Synthwave](https://github.com/alexose/synthwave).

Note that I'm just a hobbyist, not a professional electrochemist. It is likely that there are better techniques than
this one-- However, this is the one I've found that works best for my particular setup and workflow.

## Materials Needed

I've provided links below, but they're likely to fall victim to [link rot](https://en.wikipedia.org/wiki/Link_rot) over
time. If a link isn't working, just do your best to find a suitable replacement.

I also included amounts, but keep in mind that this will buy you much more than you need for a single set of electrodes.
The intention here is that you'll have enough material to make as many as you want.

-   50g
    [Carbon Black](https://www.msesupplies.com/products/mse-pro-50g-super-p-conductive-carbon-black-for-lithium-ion-battery)
    (Carbon Powder)
-   50g
    [Polyvinylidene Floride](https://www.msesupplies.com/products/mse-pro-100g-polyvinylidene-fluoride-pvdf-binder-for-lithium-battery-research?variant=31737001672762),
    a binding agent
-   Metal powders, in this example both [bismuth](https://www.rotometals.com/bismuth-powder-99-99-325-mesh-1-pound/) and
    [silver chloride](https://www.ebay.com/itm/395123679024?hash=item5bff34df30:g:QNQAAOSwjy1fVxHt)
-   500mL of
    [NMP](https://www.laballey.com/products/nmp-1-methyl-2-pyrrolidone-lab-grade?utm_source=Klaviyo&utm_medium=flow)
    solvent
-   At least a square foot of .005" thickness
    [Carbon Paper](https://www.amazon.com/MinGraph-Flexible-Graphite-Thickness-Homogeneous/dp/B07K8Y4269) (AKA Graphite
    Paper)
-   A razor scraper. I like [this one](https://www.thingiverse.com/thing:2029655), personally, but anything will work
-   Ink casting guides (see below)
-   A digital scale that works in the thousandth range
-   A plastic spoon
-   Latex gloves

## Ink casting guides

The key to electrode creation is achieving a very thin and very even spread of "ink" onto a the sheet of carbon paper.
The high-end way to do this is with a CNC-assisted spray nozzle. The low-end way is to do something called the "doctor
blade" method, which involves laying down several layers of scotch tape in lines to a desired thickness, then using a
razor blade to smoothly cast the ink between the lines.

I use a modified doctor blade method, where I 3D print stencils rather than using up a whole roll of tape. The
electrodes I'm aiming for are 20 cm^2 rectangles, cast a depth of 200 μm (0.2mm). The files I use are
[included in the Synthwave repo](https://github.com/alexose/synthwave/blob/main/model/ink_spreader.stl), but are easy to
create on your own using the CAD tool of your choice.

3d printers are excellent when it comes to making accurately-sized things. Do keep in mind that the first layer of any
3d print is mildly "squished", and may not end up _exactly_ the thickness you anticipate. Always good to verify with
calipers.

If you don't have a 3d printer, you may use the scotch tape method.

## Safety Precautions

While these ingredients aren't particularly toxic, please make sure to take proper safety precautions when handling
powders, solvents, and/or razor blades.

Carbon black is especially powdery, and is not very good for your when inhaled. Wear a mask!

This process can also be a little messy, so I like to wear latex gloves.

## Creating The Ink

Begin by weighing your ingredients. The [paper](https://pubs.rsc.org/en/content/articlelanding/2023/ee/d2ee03804h) that
I'm working from only states ratios, which is not particularly useful for knowing how much to make. For your
convenience, I've included exact weights for each ingredient, which will make enough ink to cover about 200 cm^2 of
surface area (so, 10 electrodes).

Tare your mortar and pestle on your scale, then carefully add:

-   0.4g carbon black
-   0.4g PVDF
-   3.2g bismuth powder (or silver chloride, depending on which you're making)
-   4.0g NMP solvent

Use your mortar and pestle to mix thoroughly. You're aiming for a perfectly smooth ink with no lumps.

When you've achieved this, use your disposable spoon to cast a small amount (think about 10% of what you just made) onto
the carbon paper, like so:

While holding your casting guide steady, use your razor scraper to spread the ink as evenly as you can.

Repeat until you have run out of ink.

## Drying the electrodes

If you're in a hurry, you can dry them in an 180F oven for 3-4 hours. Otherwise, you can leave them at room temperature
for 24 hours.

Once they're dry, you can cut them into their desired shapes using scissors:

Congratulations! You have now completed your first set of electrodes.
