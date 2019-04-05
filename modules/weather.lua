local urlApi = 'https://www.tianqiapi.com/api/?version=v1'
local menubar = hs.menubar.new()
local menuData = {}

menubar:setTooltip("Weather Info")
menubar:setTitle('🌤')

function updateMenubar()
   menubar:setMenu(menuData)
end

function getWeather()
   code, body, htable = hs.http.get(urlApi, nil)
   if code ~= 200 then
      print('get weather error:'..code)
      return
   end
   rawjson = hs.json.decode(body)
   menuData = {}
   for k, v in pairs(rawjson.data) do
      if k == 1 then
         titlestr = string.format("%s %s %s %s %s %s", v.day, v.wea, v.tem, v.humidity, v.air, v.win_speed)
         item = { title = titlestr }
         table.insert(menuData, item)
         table.insert(menuData, {title = '-'})
      else
         titlestr = string.format("%s %s %s %s", v.day, v.wea, v.tem, v.win_speed)
         item = { title = titlestr }
         table.insert(menuData, item)
      end

   end
   updateMenubar()
end

getWeather()
updateMenubar()
timer = hs.timer.new(6, getWeather)
timer:start()
