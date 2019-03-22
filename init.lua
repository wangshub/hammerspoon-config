local alert = require 'hs.alert'
local application = require 'hs.application'
local geometry = require 'hs.geometry'
local grid = require 'hs.grid'
local hints = require 'hs.hints'
local hotkey = require 'hs.hotkey'
local layout = require 'hs.layout'
local window = require 'hs.window'
local speech = require 'hs.speech'
local inspect = require('inspect')

local hyper = {'ctrl', 'cmd'}
local bleDeviceID = '04-5d-4b-52-d0-0a'

print('--------------------------------------------------------------')

-- show fromt app infos
hs.hotkey.bind(
    hyper, ".",
    function()
        hs.alert.show(string.format("App path:        %s\nApp name:      %s\nIM source id:  %s",
                                    window.focusedWindow():application():path(),
                                    window.focusedWindow():application():name(),
                                    hs.keycodes.currentSourceID()))
    end)

-- Handle cursor focus and application's screen manage.
function applicationWatcher(appName, eventType, appObject)
    -- Move cursor to center of application when application activated.
    -- Then don't need move cursor between screens.
    print(hs.inspect(appObject))
end


function screensChangedCallback()
    print("screensChangedCallback")
    --hs.layout.apply(dual_display)
end

function usbDeviceCallback(data)
  print("usbDeviceCallback: "..hs.inspect(data))
end

function bluetoothSwitch(state)
  -- state: 0(off), 1(on)
  -- blueutil --disconnect 04-5d-4b-52-d0-0a
  cmd = "/usr/local/bin/blueutil --power "..(state)
  print(cmd)
  result = hs.osascript.applescript(string.format('do shell script "%s"', cmd))
end

function disconnectBluetooth()
  cmd = "/usr/local/bin/blueutil --disconnect "..(bleDeviceID)
  result = hs.osascript.applescript(string.format('do shell script "%s"', cmd))
end


function connectBluetooth()
  cmd = "/usr/local/bin/blueutil --connect "..(bleDeviceID)
  result = hs.osascript.applescript(string.format('do shell script "%s"', cmd))
end


function caffeinateCallback(eventType)
    if (eventType == hs.caffeinate.watcher.screensDidSleep) then
      print("screensDidSleep")
    elseif (eventType == hs.caffeinate.watcher.screensDidWake) then
      print("screensDidWake")
    elseif (eventType == hs.caffeinate.watcher.screensDidLock) then
      print("screensDidLock")
      disconnectBluetooth()
    elseif (eventType == hs.caffeinate.watcher.screensDidUnlock) then
      print("screensDidUnlock")
      connectBluetooth()
    end
end

function ssidChangedCallback()
    ssid = hs.wifi.currentNetwork()
    print("ssid = "..(ssid))
end

function reloadConfig(paths)
    doReload = false
    for _,file in pairs(paths) do
        if file:sub(-4) == ".lua" then
            print("A lua config file changed, reload")
            doReload = true
        end
    end
    if not doReload then
        print("No lua file changed, skipping reload")
        return
    end

    hs.reload()
end

-------------------------------
-- Register callback functions |
-------------------------------

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

screenWatcher = hs.screen.watcher.new(screensChangedCallback)
screenWatcher:start()

caffeinateWatcher = hs.caffeinate.watcher.new(caffeinateCallback)
caffeinateWatcher:start()

usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
usbWatcher:start()

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()

configFileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig)
configFileWatcher:start()

-- lock mac by "win + L", same as Windows and Ubuntu
hs.hotkey.bind({"cmd"}, "L", hs.caffeinate.systemSleep)

speaker = speech.new()
speaker:speak("Hammerspoon is online")
hs.notify.new({title="Hammerspoon launch", informativeText="Boss, at your service"}):send()
