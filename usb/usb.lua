
function usbDeviceCallback(data)
  print("usbDeviceCallback: "..hs.inspect(data))
end



usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
usbWatcher:start()

