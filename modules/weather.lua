local menubar = hs.menubar.new()

menubar:setTooltip("Weather Info")
menubar:setTitle('🌤')

popupMenu = function(key)
   menuData = {
      { title = "hello title" },
      { title = "my menu item", fn = function() print("you clicked my menu item!") end },{ title = "-" },
      { title = "disabled item", disabled = true },
      { title = "checked item", checked = true },
      { title = "disabled item", disabled = true },
      { title = "checked item", checked = true },
   }
   return menuData
end

menubar:setMenu(popupMenu)


function getWeather()
   print('today is a good day.')
end


timer = hs.timer.new(6, getWeather)
timer:start()
