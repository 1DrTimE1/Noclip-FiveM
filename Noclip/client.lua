local noclip = false
local baseSpeed = 1.3

RegisterCommand("noclip", function()
    TriggerServerEvent("requestNoclipToggle")
end, false)

RegisterNetEvent("noclipToggle")
AddEventHandler("noclipToggle", function(enabled)
    noclip = enabled
    local player = PlayerPedId()

    SetEntityInvincible(player, noclip)
    SetEntityVisible(player, not noclip, false)
    SetEntityCollision(player, not noclip, false)
    FreezeEntityPosition(player, noclip)

end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if noclip then
            local player = PlayerPedId()
            local coords = GetEntityCoords(player)
            SetEntityVelocity(player, 0.0, 0.0, 0.0)
            SetEntityCollision(player, false, false)

            local speed = baseSpeed
            if IsControlPressed(0, 21) then 
                speed = speed * 2.4
            end

            local camRot = GetGameplayCamRot(2)
            local heading = math.rad(camRot.z)
            local pitch = math.rad(camRot.x)

            local dirX = -math.sin(heading) * math.cos(pitch)
            local dirY = math.cos(heading) * math.cos(pitch)
            local dirZ = math.sin(pitch)

            if IsControlPressed(0, 32) then
                SetEntityCoordsNoOffset(player,
                    coords.x + dirX * speed,
                    coords.y + dirY * speed,
                    coords.z + dirZ * speed,
                    true, true, true)
          
            elseif IsControlPressed(0, 33) then
                SetEntityCoordsNoOffset(player,
                    coords.x - dirX * speed,
                    coords.y - dirY * speed,
                    coords.z - dirZ * speed,
                    true, true, true)
            end
        else
            local player = PlayerPedId()
            SetEntityCollision(player, true, true)
        end
    end
end)

