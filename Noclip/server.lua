local webhookURL = "YOUR_DISCORD_WEEBHOOK_HERE"

function sendToDiscord(title, message, color)
    local embed = {
        {
            ["title"] = title,
            ["description"] = message,
            ["color"] = color
        }
    }

    PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode({
        username = "Noclip Logs",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent("logNoclipStatus")
AddEventHandler("logNoclipStatus", function(enabled)
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local steam, discord = "N/A", "N/A"

    for _, id in ipairs(identifiers) do
        if string.find(id, "steam:") then
            steam = id
        elseif string.find(id, "discord:") then
            discord = "<@" .. string.sub(id, 9) .. ">"
        end
    end

    local status = enabled and "ENABLED" or "DISABLED"
    local color = enabled and 65280 or 16711680

    sendToDiscord("Noclip " .. status,
        ("Player: **%s**\nSteam: `%s`\nDiscord: %s"):format(src, steam, discord),
        color)
end)

