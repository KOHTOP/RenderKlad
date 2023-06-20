local objs = {
	[19918] = "КЛАД",
}

local activ = false
local font = renderCreateFont('Impact',20,13)
function main()
    repeat wait(0) until isSampAvailable() 
    sampAddChatMessage('{ccff99}[RenderKlad]: {0099ff}Скрипт загружен. Для активации напишите {FF0000}/klad', -1)
    sampRegisterChatCommand('klad',function()
        activ = not activ
        printString('klad '..(activ and '~g~enable' or '~r~disable'),1700)
    end)
    while true do
        wait(0)
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
