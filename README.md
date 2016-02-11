# Client for an soft Access Point

This LUA script is for ESP8266 hardware.

1. Try to connect to a soft AP
2. Light on green led on GPIO_0 if connection is successful
3. Detect change of value on GPIO_2
4. Send the new value to the soft AP thought HTTP request

![scheme](https://github.com/Wifsimster/SoftAPClient/blob/master/scheme.png)
