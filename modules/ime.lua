

local function Chinese()
    hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
end

local function English()
    hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end

-- Handle cursor focus and application's screen manage.
function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
      Chinese()
    end
end


appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

