# List of Materials

This should be everything you need to build a Synthwave. Note that these parts (and associated links) may change over
time. If in doubt, make sure to cross-reference with photos of existing builds.

## Custom Parts

Synthwave requires a few parts that can't be easily ordered off the internet. First is a 3d printed [shell](/model), as
well as several other 3d printed bits. I recommend using a good quality, large format 3d printer if possible. If you
only have access to a small printer, you may need to get creative.

You'll also need the official [Synthwave PCB](/pcb). This custom-designed board allows a simple ESP32 to control ten
different 12 volt devices at once, as well as breaking out various inputs and outputs needed for managing the
electrochemical process.

If you've never ordered a custom PCB, I highly recommend [OSHPark](https://oshpark.com/). You can order three boards for
about $40 (having extra is never a bad idea).

The board is designed to be populated by hand: Everything is through-hole, and nothing is surface mounted. If you're
experienced with soldering, this should take you about an hour or so. If you're not experienced with soldering, well,
this is a good opportunity to learn!

## Pumps

-   2 [DC 12V Water Flow Self Priming Diaphragm Micro Water Pumps](https://www.amazon.com/gp/product/B09NQZHBQ2) $25.18
    ($12.59 ea)
-   2
    [DC 12V Mini Vacuum Pump](https://www.amazon.com/gp/product/B071GL3XXQ/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)
    $51.98 ($25.99 ea)

## Solenoids

-   2 [1/2 inch NPT Thread 12V DC GRAVITY-FEED Plastic Nylon Solenoid Valve](https://www.ebay.com/itm/290763981675)
    $31.98 ($15.99 ea). It is very important that you use GRAVITY FEED valves. Don't sub these out for "regular" valves,
    which require a certain amount of pressure to open.
-   4 [12V Two-Position Three-Way Electric Solenoid Valve](https://www.aliexpress.us/item/3256804915255792.html) $20
    (about $5 each) (Note there are a wide variety of these three-way solenoids. I highly recommend the ones with the
    barbed fittings.)

## Membrane Contactor

-   1 [UDM-21110 Ultifuzor Degas Module](https://www.ebay.com/itm/115469063200) ~$180 (I bought used for $75)
-   4 [Luer lock to 1/4 barb fitting adapter](https://www.amazon.com/gp/product/B0BB649WM2/) $7.99 (10 pack)

## Sensors + Electronics

-   1 [SCD30 CO2 sensor](https://www.amazon.com/extralife-Quality-Sensors-Module-Measurements/dp/B0BBGSQTYJ) $30.40
-   2 [Gravity Arduino-compatible pH sensors](https://www.dfrobot.com/product-1782.html) $79.00 ($39.50 ea)
-   1
    [Heltec Wifi Kit 32 V3 Development Board with OLED](https://www.amazon.com/HiLetgo-Display-Bluetooth-Internet-Development/dp/B07DKD79Y9)
    $17.39
-   1 [15V DC 3A Power Supply](https://www.amazon.com/Adapter-Switching-Converter-100V-240V-Positive/dp/B08CZD4HWG)
    $12.99
-   1 [Adafruit 4489 L9110H H-Bridge](https://www.amazon.com/gp/product/B085KYNY3H/) $5.18
-   1 [L7805CV Voltage Regulator](https://www.amazon.com/dp/B0C5M51R2Z) $5.99 (12 pack) 1
    [3 pin DC Power Connector, DC005 5.5x2.1mm](https://www.amazon.com/dp/B081DYQSC9) $5.99 (20 pack)
-   10 [TIP120 NPN 5A 60V Transistors](https://www.amazon.com/gp/product/B08BFYYK7D/ref=ppx_yo_dt_b_search_asin_title)
    $8.99 (20 pack)
-   2
    [LM2596S Adjustable Buck Converter](https://www.amazon.com/DiGiYes-Converter-Efficiency-Regulator-Adjustable/dp/B0BPSFVDY4)
    $8.69 (5 pack)

## PCB

## Electrode Materials

## Misc.

-   20 [2.2kohm 1/4 watt resistors](https://www.amazon.com/dp/B08QRPRVMJ) (used as hardware pulldowns) $5.49 (100 pack)
-   10 [30v 1A diodes](https://www.amazon.com/ALLECIN-1N5818-Schottky-Rectifier-Switching/dp/B0CKSHS9CM) (used as
    flyback diodes) $6.49 (150 pack)
-   10 feet [1/4" ID 3/8" OD silicone tubing](https://www.amazon.com/dp/B07W918CBP) ~ $5
-   Solid core wire for electronics
-   Shrink tubing
-   Wire strippers, needlenose pliers, soldering iron, etc.

You should expect everything to cost around **$400** total. Of course, it is quite a bit cheaper to source all the parts
from China if you don't mind the wait.

The most expensive individual part is the membrane contactor. It would be interesting to come up with an alternative for
this part, but I'm not sure what this would be. The pH sensors are optional, but very useful to monitor system
performance.

With careful attention to price, it would be possible to build this device for around $200.
