local WEBHOOK_URL = "YOUR_WEBHOOK_HERE"

function SendToDiscord(title, description, color)
    if not WEBHOOK_URL or WEBHOOK_URL == "" then return end

    local embed = {{
        title = title,
        description = description,
        color = color,
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }}

    PerformHttpRequest(WEBHOOK_URL, function(err, text, headers)
        if err >= 400 and err ~= 204 then
            print("^1[NOCLIP] WEBHOOK FEL: " .. err .. " | Svar: " .. (text or "Inget svar") .. "^0")
        end
    end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
end

RegisterNetEvent('requestNoclipToggle', function()
    local src = source
    local player = Player(src)
    if not player then return end

    local allowed = IsPlayerAceAllowed(src, "command.noclip")
    if not allowed then
        TriggerClientEvent('chat:addMessage', src, {
            color = {255, 0, 0},
            args = {"Access denied for command noclip"}
        })
        return
    end

    local current = player.state.noclip or false
    local newState = not current
    player.state.noclip = newState

    TriggerClientEvent('noclipToggle', src, newState)

    local identifiers = GetPlayerIdentifiers(src)
    local steam, discord = "N/A", "N/A"
    for _, id in ipairs(identifiers) do
        if id:match("^steam:") then steam = id end
        if id:match("^discord:") then discord = "<@"..id:sub(9)..">" end
    end

    local status = newState and "AKTIVERAD" or "AVSTÄNGD"
    local color = newState and 65280 or 16711680 

    local logMsg = string.format(
        "**Spelare:** %s\n**Server ID:** %d\n**Steam:** `%s`\n**Discord:** %s",
        GetPlayerName(src), src, steam, discord
    )

    SendToDiscord("Noclip " .. status, logMsg, color)
end)
