local apiKey = nil
local isFreecamActive = false
local cam = nil
local speed = Config.Speed or 1.0
local maxDistance = Config.MaxDistance or 100.0
local initialCoords = nil
local offsetRotX = 0.0
local offsetRotY = 0.0
local offsetRotZ = 0.0
local precision = Config.Precision or 2.0
local hasPermission = false
local permissionChecked = false

function StartFreecam()
    if not hasPermission then
        lib.notify({
            type = 'error',
            description = 'You do not have permission to use this command.',
            duration = 5000
        })
        return
    end

    isFreecamActive = true
    local playerPed = PlayerPedId()
    initialCoords = GetEntityCoords(playerPed)
    DisplayRadar(false)
    DisplayHud(false)

    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, initialCoords.x, initialCoords.y, initialCoords.z + 1.5)
    SetCamRot(cam, 0.0, 0.0, GetEntityHeading(playerPed))
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)

    FreezeEntityPosition(playerPed, true)

    lib.showTextUI([[
    W - Move Forward
    S - Move Backward
    A - Move Left
    D - Move Right
    Q - Move Up
    E - Move Down
    Mouse - Rotate Camera
    Mouse Wheel - Adjust Speed
    X - Exit Freecam
    Enter - Take Screenshot
    ]], {
        position = "right-center"
    })

    Citizen.CreateThread(function()
        while isFreecamActive do
            local camCoords = GetCamCoord(cam)
            local camRot = GetCamRot(cam, 2)
            local forward = RotAnglesToVec(camRot)
            local right = RotAnglesToVec(camRot + vector3(0.0, 0.0, -90.0))

            local newCamCoords = camCoords
            if IsControlPressed(0, 32) and #(newCamCoords + forward * speed - initialCoords) < maxDistance then
                newCamCoords = newCamCoords + forward * speed
            end
            if IsControlPressed(0, 33) and #(newCamCoords - forward * speed - initialCoords) < maxDistance then
                newCamCoords = newCamCoords - forward * speed
            end
            if IsControlPressed(0, 34) and #(newCamCoords - right * speed - initialCoords) < maxDistance then
                newCamCoords = newCamCoords - right * speed
            end
            if IsControlPressed(0, 35) and #(newCamCoords + right * speed - initialCoords) < maxDistance then
                newCamCoords = newCamCoords + right * speed
            end
            if IsControlPressed(0, 44) and #(newCamCoords + vector3(0.0, 0.0, speed) - initialCoords) < maxDistance then
                newCamCoords = newCamCoords + vector3(0.0, 0.0, speed)
            end
            if IsControlPressed(0, 38) and #(newCamCoords - vector3(0.0, 0.0, speed) - initialCoords) < maxDistance then
                newCamCoords = newCamCoords - vector3(0.0, 0.0, speed)
            end
            SetCamCoord(cam, newCamCoords.x, newCamCoords.y, newCamCoords.z)

            offsetRotX = offsetRotX - (GetDisabledControlNormal(1, 2) * precision)
            offsetRotZ = offsetRotZ - (GetDisabledControlNormal(1, 1) * precision)
            if IsDisabledControlPressed(1, 24) then
                offsetRotY = offsetRotY - precision
            end
            if IsDisabledControlPressed(1, 25) then
                offsetRotY = offsetRotY + precision
            end
            offsetRotX = math.max(math.min(offsetRotX, 90.0), -90.0)
            offsetRotY = math.max(math.min(offsetRotY, 90.0), -90.0)
            offsetRotZ = (offsetRotZ + 360.0) % 360.0
            SetCamRot(cam, offsetRotX, offsetRotY, offsetRotZ, 2)

            if IsControlJustPressed(0, 241) then
                speed = speed + 0.5
            elseif IsControlJustPressed(0, 242) then
                speed = math.max(speed - 0.5, 0.1)
            end

            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)

            if IsControlJustPressed(0, 73) then
                DisplayRadar(true)
                DisplayHud(true)
                StopFreecam()
                break
            end

            Citizen.Wait(0)
        end
    end)
end

function StopFreecam()
    isFreecamActive = false
    local playerPed = PlayerPedId()
    
    RenderScriptCams(false, false, 0, true, true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    
    offsetRotX, offsetRotY, offsetRotZ = 0.0, 0.0, 0.0

    FreezeEntityPosition(playerPed, false)
    EnableAllControlActions(0)
    SetGameplayCamRelativeHeading(0)
    SetGameplayCamRelativePitch(0, 1.0)

    lib.hideTextUI()
end

function RotAnglesToVec(rot)
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

RegisterNetEvent('devm:apikey')
AddEventHandler('devm:apikey', function(receivedKey)
    apiKey = receivedKey
end)

RegisterNetEvent('devm:permissions')
AddEventHandler('devm:permissions', function(permission)
    hasPermission = permission
    permissionChecked = true
end)

RegisterNetEvent('devm:startcam')
AddEventHandler('devm:startcam', function()
    TriggerServerEvent('devm:checkperms')

    Citizen.CreateThread(function()
        while not permissionChecked do
            Citizen.Wait(0)
        end

        if hasPermission then
            StartFreecam()

            Citizen.CreateThread(function()
                while isFreecamActive do
                    DisplayHud(false)
                    DisplayRadar(false)

                    if IsControlJustReleased(0, 191) then
                        lib.hideTextUI()
                    
                        DisplayHud(false)
                        DisplayRadar(false)
                    
                        Citizen.Wait(500)
                    
                        TriggerServerEvent('devm:rapikey')
                    
                        Citizen.Wait(100)
                    
                        if apiKey then
                            exports['screenshot-basic']:requestScreenshotUpload('https://api.fivemanage.com/api/image', 'image', {
                                headers = {
                                    Authorization = apiKey
                                }
                            }, function(data)
                                local resp = json.decode(data)
                                if resp and resp.url then
                                    TriggerServerEvent('devm:webhook', resp.url)
                                    lib.notify({
                                        type = 'success',
                                        description = 'Screenshot uploaded!',
                                        duration = 10000
                                    })
                                else
                                    lib.notify({
                                        type = 'error',
                                        description = 'Failed to upload screenshot.',
                                        duration = 5000
                                    })
                                end
                    
                                DisplayHud(true)
                                DisplayRadar(true)
                                StopFreecam()
                            end)
                        else
                            lib.notify({
                                type = 'error',
                                description = 'Failed to obtain API key.',
                                duration = 5000
                            })
                    
                            DisplayHud(true)
                            DisplayRadar(true)
                        end
                    
                        break
                    end
                    Citizen.Wait(0)
                end
            end)
        else
            lib.notify({
                type = 'error',
                description = 'You do not have permission to use this command.',
                duration = 5000
            })
        end
    end)
end)
