print('==================================================')
require "headphone.headphone"
require "hotkey.hotkey"
require "ime.ime"
require "reload.reload"
require "usb.usb"
require "wifi.wifi"
require "window.window"
require "clipboard.clipboard"
require "statuslets.statuslets"
require "volume.volume"
require "weather.weather"
require "speaker.speaker"

-- Private use
if (hs.host.localizedName() == 'kaboom的MacBook Pro') then
	require("autoscript.autoscript")
end
