local function isPlayerWhitelisted(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)
    local steamHex = nil

    for _, id in ipairs(identifiers) do
        if string.sub(id, 1, 6) == "steam:" then
            steamHex = id
            break
        end
    end

    for _, allowedHex in ipairs(SvConfig.AllowedSteamHexes) do
        if steamHex == allowedHex then
            return true
        end
    end
    return false
end


RegisterNetEvent('devm:checkperms')
AddEventHandler('devm:checkperms', function()
    local src = source

    if not Config.Permissions then
        TriggerClientEvent('devm:permissions', src, true)
        return
    end

    local hasPermission = isPlayerWhitelisted(src)
    TriggerClientEvent('devm:permissions', src, hasPermission)
end)
