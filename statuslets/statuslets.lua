---- From https://github.com/cmsj/hammerspoon-config/blob/master/init.lua

local statusletTimer

-- Draw little text/dot pairs in the bottom right corner of the primary display, to indicate firewall/backup status of my machine
function renderStatuslets()
    -- if (hostname ~= "pixukipa") then
    --     return
    -- end
    -- Destroy existing Statuslets
    if firewallStatusText then firewallStatusText:delete() end
    if firewallStatusDot then firewallStatusDot:delete() end
    if cccStatusText then cccStatusText:delete() end
    if cccStatusDot then cccStatusDot:delete() end
    if arqStatusText then arqStatusText:delete() end
    if arqStatusDot then arqStatusDot:delete() end

    -- Defines for statuslets - little coloured dots in the corner of my screen that give me status info, see:
    -- https://www.dropbox.com/s/3v2vyhi1beyujtj/Screenshot%202015-03-11%2016.13.25.png?dl=0
    local initialScreenFrame = hs.screen.allScreens()[1]:fullFrame()

    -- Start off by declaring the size of the text/circle objects and some anchor positions for them on screen
    local statusDotWidth = 10
    local statusTextWidth = 30
    local statusTextHeight = 15
    local statusText_x = initialScreenFrame.x + initialScreenFrame.w - statusDotWidth - statusTextWidth
    local statusText_y = initialScreenFrame.y + initialScreenFrame.h - statusTextHeight
    local statusDot_x = initialScreenFrame.x + initialScreenFrame.w - statusDotWidth
    local statusDot_y = statusText_y

    -- Now create the text/circle objects using the sizes/positions we just declared (plus a little fudging to make it all align properly)
    firewallStatusText = hs.drawing.text(hs.geometry.rect(statusText_x + 5,
                                                          statusText_y - (statusTextHeight*2) + 2,
                                                          statusTextWidth,
                                                          statusTextHeight), "FW:")
    cccStatusText = hs.drawing.text(hs.geometry.rect(statusText_x,
                                                     statusText_y - statusTextHeight + 1,
                                                     statusTextWidth,
                                                     statusTextHeight), "CCC:")
    arqStatusText = hs.drawing.text(hs.geometry.rect(statusText_x + 4,
                                                     statusText_y,
                                                     statusTextWidth,
                                                     statusTextHeight), "Arq:")

    firewallStatusDot = hs.drawing.circle(hs.geometry.rect(statusDot_x,
                                                           statusDot_y - (statusTextHeight*2) + 4,
                                                           statusDotWidth,
                                                           statusDotWidth))
    cccStatusDot = hs.drawing.circle(hs.geometry.rect(statusDot_x,
                                                      statusDot_y - statusTextHeight + 3,
                                                      statusDotWidth,
                                                      statusDotWidth))
    arqStatusDot = hs.drawing.circle(hs.geometry.rect(statusDot_x,
                                                      statusDot_y + 2,
                                                      statusDotWidth,
                                                      statusDotWidth))

    -- Finally, configure the rendering style of the text/circle objects, clamp them to the desktop, and show them
    firewallStatusText:setBehaviorByLabels({"canJoinAllSpaces", "stationary"}):setTextSize(11):sendToBack():show()
    cccStatusText:setBehaviorByLabels({"canJoinAllSpaces", "stationary"}):setTextSize(11):sendToBack():show()
    arqStatusText:setBehaviorByLabels({"canJoinAllSpaces", "stationary"}):setTextSize(11):sendToBack():show()

    firewallStatusDot:setBehaviorByLabels({"canJoinAllSpaces", "stationary"}):setFillColor(hs.drawing.color.osx_yellow):setStroke(false):sendToBack():show()
    cccStatusDot:setBehaviorByLabels({"canJoinAllSpaces", "stationary"}):setFillColor(hs.drawing.color.osx_yellow):setStroke(false):sendToBack():show()
    arqStatusDot:setBehaviorByLabels({"canJoinAllSpaces", "stationary"}):setFillColor(hs.drawing.color.osx_yellow):setStroke(false):sendToBack():show()
end

function updateStatuslets()
    -- if (hostname ~= "pixukipa") then
    --     return
    -- end
    print("updateStatuslets")
    _,_,fwcode = os.execute('sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode | grep "Stealth mode enabled"')
    _,_,ccccode = os.execute('grep -q "$(date +%d/%m/%Y)" ~/.cccLast')
    _,_,arqcode = os.execute('grep -q "Arq.*finished backup" /var/log/system.log')

    if fwcode == 0 then
        firewallStatusDot:setFillColor(hs.drawing.color.osx_green)
    else
        firewallStatusDot:setFillColor(hs.drawing.color.osx_red)
    end

    if ccccode == 0 then
        cccStatusDot:setFillColor(hs.drawing.color.osx_green)
    else
        cccStatusDot:setFillColor(hs.drawing.color.osx_red)
    end

    if arqcode == 0 then
        arqStatusDot:setFillColor(hs.drawing.color.osx_green)
    else
        arqStatusDot:setFillColor(hs.drawing.color.osx_red)
    end
end

-- Render our statuslets, trigger a timer to update them regularly, and do an initial update
renderStatuslets()
statusletTimer = hs.timer.new(hs.timer.minutes(5), updateStatuslets)
statusletTimer:start()
updateStatuslets()

