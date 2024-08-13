lib.addCommand('cam', {
    help = 'Activate freecam and take a screenshot',
    restricted = false,
}, function(source, args)
    TriggerClientEvent('devm:startcam', source)
end)

RegisterNetEvent('devm:rapikey')
AddEventHandler('devm:rapikey', function()
    local src = source
    TriggerClientEvent('devm:apikey', src, SvConfig.ApiKey)
end)

RegisterNetEvent('devm:webhook')
AddEventHandler('devm:webhook', function(screenshotUrl)
    local embedContent = {
        {
            title = "Devm-Camera",
            description = "URL: " .. screenshotUrl,
            image = {
                url = screenshotUrl
            },
            color = 5814783,
        }
    }

    local webhookPayload = {
        username = "Devm-Camera",
        avatar_url = "https://r2.fivemanage.com/pub/r53fk8odx2y2.png",
        embeds = embedContent
    }

    PerformHttpRequest(SvConfig.WebhookUrl, function(err, text, headers)
    end, 'POST', json.encode(webhookPayload), {['Content-Type'] = 'application/json'})
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    if GetCurrentResourceName() ~= 'Devm-Camera' then
        annoyingPrint()
        return
    end

    Wait(5000)

    resourceName = ""..GetCurrentResourceName()..""
    
    function checkVersion(err,responseText, headers)
        curVersion =  GetResourceMetadata(GetCurrentResourceName(), 'version', 0)

    	if responseText:gsub("%s+", "") ~= curVersion:gsub("%s+", "") then
            print(""..resourceName.." is outdated. \nLatest Version: ^2"..responseText.."\n^7Current Version: ^1"..curVersion.."\n^7Download The New One From Github!")
        else
            print(resourceName.." is up to date, 📷 Enjoy Taking Pictures!")
        end
    end
    
    PerformHttpRequest("https://raw.githubusercontent.com/Awleks/version-check/main/camera", checkVersion, "GET")
end)
  

function annoyingPrint()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            print('^1Please rename ' .. GetCurrentResourceName() .. ' script back to its original name (Devm-Camera) in order for it to function properly')
        end
    end) 
end
