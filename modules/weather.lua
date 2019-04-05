local urlApi = 'https://www.tianqiapi.com/api/?version=v1'
local menubar = hs.menubar.new()
local menuData = {}

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

function updateMenubar()
   menubar:setMenu(menuData)
end

function getWeather()
   print('today is a good day.')
   code, body, htable = hs.http.get(urlApi, nil)
   if code ~= 200 then
      print('get weather error:'..code)
      return
   end
   rawjson = hs.json.decode(body)
   menuData = {}
   for k, v in pairs(rawjson.data) do
      item = { title = v.day }
      table.insert(menuData, item)
   end
   updateMenubar()
end


timer = hs.timer.new(60, getWeather)
timer:start()
