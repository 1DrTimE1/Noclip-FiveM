local noclip = false
local baseSpeed = 1.3

RegisterCommand("noclip", function()
    TriggerServerEvent("requestNoclipToggle")
end, false)

RegisterNetEvent("noclipToggle")
AddEventHandler("noclipToggle", function(enabled)
    noclip = enabled
    local ped = PlayerPedId()

    SetEntityInvincible(ped, noclip)
    SetEntityVisible(ped, not noclip, false)
    SetEntityCollision(ped, not noclip, false)
    FreezeEntityPosition(ped, noclip)

    local statusText = enabled and "^2enabled" or "^1disabled"
    TriggerEvent('chat:addMessage', {
        color = { 255, 255, 0 },
        multiline = true,
        args = { "^1SYSTEM ", "Noclip has been set to " .. statusText }
    })
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if noclip then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            SetEntityVelocity(ped, 0.0, 0.0, 0.0)

            local speed = IsControlPressed(0, 21) and (baseSpeed * 2.4) or baseSpeed
            local camRot = GetGameplayCamRot(2)
            local heading = math.rad(camRot.z)
            local pitch = math.rad(camRot.x)

            local dir = vector3(
                -math.sin(heading) * math.cos(pitch),
                math.cos(heading) * math.cos(pitch),
                math.sin(pitch)
            )

            if IsControlPressed(0, 32) then -- W
                SetEntityCoordsNoOffset(ped, coords + dir * speed, true, true, true)
            elseif IsControlPressed(0, 33) then -- S
                SetEntityCoordsNoOffset(ped, coords - dir * speed, true, true, true)
            end
        end
    end
end)

