local displayCount = 1

RegisterNetEvent("fs-diceroll:client:roll")
AddEventHandler("fs-diceroll:client:roll", function(sourceId, maxDinstance, rollTable, sides)
    local rollString = CreateRollString(rollTable, sides)
    local offset = 1 + (displayCount*0.2)
    RequestAnimDict("anim@mp_player_intcelebrationmale@wank")
    while (not HasAnimDictLoaded("anim@mp_player_intcelebrationmale@wank")) do
        Wait(0)
    end
    TaskPlayAnim(GetPlayerPed(GetPlayerFromServerId(sourceId)), "anim@mp_player_intcelebrationmale@wank" ,"wank" ,8.0, -8.0, -1, 49, 0, false, false, false )
    Wait(2400)
    ClearPedTasks(GetPlayerPed(GetPlayerFromServerId(sourceId)))
    ShowRoll(rollString, GetPlayerFromServerId(sourceId), maxDinstance, offset)
end)

function ShowRoll(text, sourcePlayer, maxDistance, offset)
    local display = true
    CreateThread(function()
        Wait(7000)
        display = false
    end)

    CreateThread(function()
        displayCount = displayCount + 1
        while display do
            Wait(7)
            local sourcePos = GetEntityCoords(GetPlayerPed(sourcePlayer), false)
            local pos = GetEntityCoords(PlayerPedId(), false)
            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < maxDistance) then
                DrawText3D(sourcePos.x, sourcePos.y, sourcePos.z + offset - 1.25, text)
            end
        end
        displayCount = displayCount - 1
    end)
end

function CreateRollString(rollTable, sides)
    local s = "Roll: "
    local total = 0
    for k, roll in pairs(rollTable, sides) do
        total = total + roll
        if k == 1 then
            s = s .. roll .. "/" .. sides
        else
            s = s .. " | " .. roll .. "/" .. sides
        end
    end
    s = s .. " | (Total: "..total..")"
    return s
end

function DrawText3D(x,y,z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
		DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 100)
      end
  end