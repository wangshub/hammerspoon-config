local alert = require 'hs.alert'
local window = require 'hs.window'



local hyper = {'ctrl', 'cmd'}

hs.hotkey.bind({"cmd"}, "L", hs.caffeinate.systemSleep)

-- show front activated app infos
hs.hotkey.bind(
    hyper, ".",
    function()
        hs.alert.show(string.format("App path:        %s\nApp name:      %s\nIM source id:  %s",
                                    window.focusedWindow():application():path(),
                                    window.focusedWindow():application():name(),
                                    hs.keycodes.currentSourceID()))
    end)


