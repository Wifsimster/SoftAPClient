-- Connect to Soft AP
wifi.setmode(wifi.STATION)
wifi.sta.config("PORTAIL","192Portail!!")
wifi.sta.connect()

-- Setting up GPIO
gpio0 = 3
gpio2 = 4
-- GPIO0 LED FOR CONNECTION
gpio.mode(gpio0, gpio.OUTPUT)
-- GPIO2 CONTACT
gpio.mode(gpio2, gpio.INPUT)
gpio.write(gpio2, gpio.HIGH)

prev_value = 0

-- Send value throught HTTP request to AP
function sendData(value)
    conn=net.createConnection(net.TCP, 0)
    conn:on("receive", function(conn, payload) print(payload) end )
    conn:on("connection", function(c)
            conn:send(value)
        end)
    conn:connect(80,"192.168.1.1")
end

local cnt = 0
val = 1

-- Trying to connect to AP
tmr.alarm(0, 1000, 1, function()
    if (wifi.sta.getip() == nil) and (cnt < 20) then
        gpio.write(gpio0, gpio.HIGH)
        print("Trying Connect to AP, Waiting...")
        cnt = cnt + 1
        gpio.write(gpio0, gpio.LOW)
    else
        tmr.stop(0)
        if (cnt < 60) then
            print("Config done, IP is "..wifi.sta.getip())
            gpio.write(gpio0, gpio.HIGH)
            
            -- Send GPIO2 when value change
            gpio.trig(gpio2, 'both', function()
                if(gpio.read(gpio2) ~= val) then
                    val = gpio.read(gpio2)
                    sendData(val)
                    print("Send: "..val)
                end
            end)
        else
            print("Wifi setup time more than 60s")
            gpio.write(gpio0, gpio.LOW)
        end
        cnt = nil;
        collectgarbage();
    end
end)
