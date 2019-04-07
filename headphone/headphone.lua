
-- SONY MDR-1000X
local bleDeviceID = '04-5d-4b-52-d0-0a'


function bluetoothSwitch(state)
  -- state: 0(off), 1(on)
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

caffeinateWatcher = hs.caffeinate.watcher.new(caffeinateCallback)
caffeinateWatcher:start()
