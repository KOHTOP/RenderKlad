script_author('KOHTOP')
script_description('Автор скрипта: Сообщество RushScript')
script_version('1.1v')
script_name('RenderKlad')

require "lib.moonloader"
local dlstatus = require('moonloader').download_status
local encoding = require 'encoding'
local inicfg = require 'inicfg'
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false

local script_vers = 1
local script_vers_text = "1.1v"

local update_url = "https://raw.githubusercontent.com/KOHTOP/RenderKlad/main/update.ini" -- тут тоже свою ссылку
local update_path = getWorkingDirectory() .. "/update.ini" -- и тут свою ссылку

local script_url = "" -- тут свою ссылку
local script_path = thisScript().path

local objs = {
	[19918] = "КЛАД",
}

local activ = false
local font = renderCreateFont('Impact',20,13)
function main()
    repeat wait(0) until isSampAvailable() 
    sampAddChatMessage('{ccff99}[RenderKlad]: {0099ff}Успешная загрузка. Для активации напишите {FF0000}/klad', -1)
    sampRegisterChatCommand('klad',function()
        activ = not activ
        printString('klad '..(activ and '~g~enable' or '~r~disable'),1700)
    end)
    sampRegisterChatCommand('test', cmd_test)

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.version.vers) > script_vers then
                sampAddChatMessage("{ccff99}[RenderKlad]: {0099ff}Найдено обновление! Версия: " .. updateIni.version.vers_text, -1)
                update_state = true
            elseif tonumber(updateIni.version.vers) == script_vers then
                sampAddChatMessage('{ccff99}[RenderKlad]: {0099ff}Обновлений не найдено!', -1)
            end
            os.remove(update_path)
        end
    end)

    while true do
        wait(0)

        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("Скрипт успешно обновлен!", -1)
                    thisScript():reload()
                end
            end)
            break
        end

        if activ then
            for _, obj_hand in pairs(getAllObjects()) do
                local modelid = getObjectModel(obj_hand)
                local _obj = objs[modelid]
                if _obj then
                    if isObjectOnScreen(obj_hand) then
                        local x,y,z = getCharCoordinates(PLAYER_PED)
                        local res,x1,y1,z1 = getObjectCoordinates(obj_hand)
                        if res then
                            local dist = math.floor(getDistanceBetweenCoords3d(x,y,z,x1,y1,z1))
                            local c1,c2 = convert3DCoordsToScreen(x,y,z)
                            local o1,o2 = convert3DCoordsToScreen(x1,y1,z1)
                            local text = '{6400FF}'.._obj..'\n{C0C0C0}дистанция: '..dist..'m.'
                            renderDrawLine(c1,c2,o1,o2,1, 0xFFD00000)
                            renderFontDrawText(font,text,o1,o2,-1)
                        end
                    end
                end
            end
        end
    end
end