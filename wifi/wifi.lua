function ssidChangedCallback()
    ssid = hs.wifi.currentNetwork()
    if (ssid ~= nil) then
        print("ssid = "..(ssid))
    end
end


wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()

