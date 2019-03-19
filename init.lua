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
speaker = speech.new()
speaker:speak("Boss, I am online!")
print('--------------------------------------------------------------------')

-- Key to launch application.
local key2App = {
    i = {'/Applications/iTerm.app', 'English', 2},
    e = {'/Applications/Emacs.app', 'English', 2},
    c = {'/Applications/Google Chrome.app', 'English', 1},
    f = {'/System/Library/CoreServices/Finder.app', 'English', 1},
    n = {'/Applications/NeteaseMusic.app', 'Chinese', 1},
    w = {'/Applications/WeChat.app', 'Chinese', 1},
    s = {'/Applications/System Preferences.app', 'English', 1},
    p = {'/Applications/Preview.app', 'Chinese', 2},
  }


-- Manage application's inputmethod status.
local function Chinese()
    hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
end

local function English()
    hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end


function updateFocusAppInputMethod()
    for key, app in pairs(key2App) do
        local appPath = app[1]
        local inputmethod = app[2]

        if window.focusedWindow():application():path() == appPath then
            if inputmethod == 'English' then
                English()
            else
                Chinese()
            end

            break
        end
    end
end

-- Build better app switcher.
switcher = hs.window.switcher.new(
    hs.window.filter.new()
        :setAppFilter('Emacs', {allowRoles = '*', allowTitles = 1}), -- make emacs window show in switcher list
    {
        showTitles = true,               -- don't show window title
        thumbnailSize = 200,              -- window thumbnail size
        showSelectedThumbnail = false,    -- don't show bigger thumbnail
        backgroundColor = {0, 0, 0, 0.8}, -- background color
        highlightColor = {0.3, 0.3, 0.3, 0.8}, -- selected color
    }
)


hs.hotkey.bind("alt-shift", "tab", function()
                   switcher:previous()
                   updateFocusAppInputMethod()
end)

hs.hotkey.bind("alt", "tab", function()
	switcher:next()
	updateFocusAppInputMethod()
end)

-- Handle cursor focus and application's screen manage.
startAppPath = ""
function applicationWatcher(appName, eventType, appObject)
    -- Move cursor to center of application when application activated.
    -- Then don't need move cursor between screens.
    -- print(string.format("%s is activated %s", appName, eventType))
    -- print(inspect(appObject))
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

-- Hello world Hammerspoon
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  hs.alert.show("Hello World!")
end)

-- show fromt app infos
hs.hotkey.bind(
    hyper, ".",
    function()
        hs.alert.show(string.format("App path:        %s\nApp name:      %s\nIM source id:  %s",
                                    window.focusedWindow():application():path(),
                                    window.focusedWindow():application():name(),
                                    hs.keycodes.currentSourceID()))
end)


