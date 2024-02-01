A few known issues that need attention:

-   Pin 26 conflicts with the ESP32's wifi capability. Recommend switching this to pin 20
-   Pin 39 does not have a hardware pullup, recommend adding one
-   Fix issue with ground nets
-   Consider freeing up pin 41 and pin 42 for I2C
-   Consider 20-pin ribbon cable for devices
-   Consider 3-pin ribbon cables for pH meters
-   Consider magnetic connectors for electrodes and/or float sensors
