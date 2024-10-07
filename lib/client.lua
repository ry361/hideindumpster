local isInDumpster = false
local dumpsterLocations = {
    vector4(-498.29, -671.37, 32.01, 180.65)
}
local dumpsters = {}
local savedIndex = nil

RegisterNetEvent('ry-dumpster:enter', function(coords, rotation)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    local dumpsterModel = GetHashKey("prop_cs_dumpster_01a")
    local lidLeftModel = GetHashKey("prop_cs_dumpster_lidl")
    local lidRightModel = GetHashKey("prop_cs_dumpster_lidr")
    local searchRadius = 5.0

    local dumpster = CreateObject(GetHashKey("prop_cs_dumpster_01a"), coords.x, coords.y, coords.z - 0.5, true, true, false)
    local lidLeft = CreateObject(GetHashKey("prop_cs_dumpster_lidl"), coords.x, coords.y, coords.z, true, true, false)
    local lidRight = CreateObject(GetHashKey("prop_cs_dumpster_lidr"), coords.x, coords.y, coords.z, true, true, false)
    SetEntityRotation(dumpster, rotation - 180)

    
    RequestAnimDict("rcmpaparazzo_3leadinoutpap_3_rcm")
    while not HasAnimDictLoaded("rcmpaparazzo_3leadinoutpap_3_rcm") do
        Citizen.Wait(100)
    end

    local dumpsterCoords = GetEntityCoords(dumpster)
    local dumpsterRotation = GetEntityRotation(dumpster)

    local scene = NetworkCreateSynchronisedScene(dumpsterCoords.x, dumpsterCoords.y, dumpsterCoords.z, dumpsterRotation.x, dumpsterRotation.y, dumpsterRotation.z, 2, true, false, 1065353216, 0, 1.3)

    NetworkAddPedToSynchronisedScene(playerPed, scene, "rcmpaparazzo_3leadinoutpap_3_rcm", "leadout_pap_3_rcm_beverly", 8.0, -8.0, 0, 0, 1000.0, 0)
    
    NetworkAddEntityToSynchronisedScene(dumpster, scene, "rcmpaparazzo_3leadinoutpap_3_rcm", "leadout_pap_3_rcm_dumpster", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(lidLeft, scene, "rcmpaparazzo_3leadinoutpap_3_rcm", "leadout_pap_3_rcm_lid_l", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(lidRight, scene, "rcmpaparazzo_3leadinoutpap_3_rcm", "leadout_pap_3_rcm_lid_r", 4.0, -8.0, 1)
    
    NetworkStartSynchronisedScene(scene)
    Wait(9000)
    isInDumpster = true
end)

function spawnDumpsters()
    local dumpsterModel = GetHashKey("prop_cs_dumpster_01a")
    local lidLeftModel = GetHashKey("prop_cs_dumpster_lidl")
    local lidRightModel = GetHashKey("prop_cs_dumpster_lidr")
    

    for i = 1, #NMConfig['Coords'] do
        RequestModel(dumpsterModel) while not HasModelLoaded(dumpsterModel) do Citizen.Wait(10) end

        local coord = NMConfig['Coords'][i]['coords']
        print(coord)

        local dumpster = CreateObject(dumpsterModel, coord.x, coord.y, coord.z, true, true, false)
        SetEntityHeading(dumpster, coord.w)

        RequestModel(lidLeftModel) while not HasModelLoaded(lidLeftModel) do Citizen.Wait(10) end
        RequestModel(lidRightModel) while not HasModelLoaded(lidRightModel) do Citizen.Wait(10) end

        local lidLeft = CreateObject(lidLeftModel, coord.x, coord.y, coord.z, true, true, false)
        local lidRight = CreateObject(lidRightModel, coord.x, coord.y, coord.z, true, true, false)

        AttachEntityToEntity(lidLeft, dumpster, 0, -0.45, 0.5, 0.9, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        AttachEntityToEntity(lidRight, dumpster, 0, 0.45, 0.5, 0.9, 0.0, 0.0, 0.0, false, false, false, false, 2, true)

        SetEntityAsMissionEntity(dumpster, true, true)
        SetEntityAsMissionEntity(lidLeft, true, true)
        SetEntityAsMissionEntity(lidRight, true, true)
        SetModelAsNoLongerNeeded(dumpsterModel)
        SetModelAsNoLongerNeeded(lidLeftModel)
        SetModelAsNoLongerNeeded(lidRightModel)

        FreezeEntityPosition(dumpster, true)
        FreezeEntityPosition(lidLeft, true)
        FreezeEntityPosition(lidRight, true)

        table.insert(dumpsters, {id = i, prop = dumpster, prop2 = lidLeft, prop3 = lidRight})
        Wait(500)
    end
end

RegisterNetEvent('ry-dumpster:exit', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    local dumpsterModel = GetHashKey("prop_cs_dumpster_01a")
    local lidLeftModel = GetHashKey("prop_cs_dumpster_lidl")
    local lidRightModel = GetHashKey("prop_cs_dumpster_lidr")
    local searchRadius = 5.0

    local dumpster = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, searchRadius, dumpsterModel, false, false, false)
    local lidLeft = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, searchRadius, lidLeftModel, false, false, false)
    local lidRight = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, searchRadius, lidRightModel, false, false, false)

    if dumpster == 0 or lidLeft == 0 or lidRight == 0 then
        print("Yakında çöp kutusu bulunamadı!")
        return
    end

    RequestAnimDict("rcmpaparazzo_3leadinoutpap_3_rcm")
    while not HasAnimDictLoaded("rcmpaparazzo_3leadinoutpap_3_rcm") do
        Citizen.Wait(100)
    end

    local dumpsterCoords = GetEntityCoords(dumpster)
    local dumpsterRotation = GetEntityRotation(dumpster)

    local scene = NetworkCreateSynchronisedScene(dumpsterCoords.x, dumpsterCoords.y, dumpsterCoords.z, dumpsterRotation.x, dumpsterRotation.y, dumpsterRotation.z, 2, true, false, 1065353216, 0, 1.3)

    NetworkAddPedToSynchronisedScene(playerPed, scene, "rcmpaparazzo_3leadinoutpap_3_rcm", "leadin_pap_3_rcm_beverly", 8.0, -8.0, 0, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(dumpster, scene, "rcmpaparazzo_3leadinoutpap_3_rcm", "leadin_pap_3_rcm_dumpster", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(lidLeft, scene, "rcmpaparazzo_3leadinoutpap_3_rcm", "leadin_pap_3_rcm_lid_l", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(lidRight, scene, "rcmpaparazzo_3leadinoutpap_3_rcm", "leadin_pap_3_rcm_lid_r", 4.0, -8.0, 1)

    NetworkStartSynchronisedScene(scene)
    Wait(3000)
    local prop = dumpster
    local propCoords = GetEntityCoords(prop)
    local propHeading = GetEntityHeading(prop)
    local offset = -1.1
    local playerPed = PlayerPedId()
    local propFrontCoords = GetOffsetFromEntityInWorldCoords(prop, 0.0, offset, 0.0)
    SetEntityCoords(playerPed, propFrontCoords.x, propFrontCoords.y, propFrontCoords.z)
    SetEntityHeading(playerPed, propHeading - 180)
    DeleteEntity(dumpster)
    DeleteEntity(lidLeft)
    DeleteEntity(lidRight)
    spawnDumpsterSaved()
    isInDumpster = false

    -- Restores the camera for default mode after leaving the dumpster
    SetFollowPedCamViewMode(1)
end)

function spawnDumpsterSaved()
    local dumpsterModel = GetHashKey("prop_cs_dumpster_01a")
    local lidLeftModel = GetHashKey("prop_cs_dumpster_lidl")
    local lidRightModel = GetHashKey("prop_cs_dumpster_lidr")
    RequestModel(dumpsterModel)
    while not HasModelLoaded(dumpsterModel) do
        Citizen.Wait(10)
    end

    local coord = NMConfig['Coords'][savedIndex]['coords']

    local dumpster = CreateObject(dumpsterModel, coord.x, coord.y, coord.z, true, true, false)
    SetEntityHeading(dumpster, coord.w)

    RequestModel(lidLeftModel)
    while not HasModelLoaded(lidLeftModel) do
        Citizen.Wait(10)
    end

    RequestModel(lidRightModel)
    while not HasModelLoaded(lidRightModel) do
        Citizen.Wait(10)
    end

    local lidLeft = CreateObject(lidLeftModel, coord.x, coord.y, coord.z, true, true, false)
    local lidRight = CreateObject(lidRightModel, coord.x, coord.y, coord.z, true, true, false)

    AttachEntityToEntity(lidLeft, dumpster, 0, -0.45, 0.5, 0.9, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    AttachEntityToEntity(lidRight, dumpster, 0, 0.45, 0.5, 0.9, 0.0, 0.0, 0.0, false, false, false, false, 2, true)

    SetEntityAsMissionEntity(dumpster, true, true)
    SetEntityAsMissionEntity(lidLeft, true, true)
    SetEntityAsMissionEntity(lidRight, true, true)
    SetModelAsNoLongerNeeded(dumpsterModel)
    SetModelAsNoLongerNeeded(lidLeftModel)
    SetModelAsNoLongerNeeded(lidRightModel)

    FreezeEntityPosition(dumpster, true)
    FreezeEntityPosition(lidLeft, true)
    FreezeEntityPosition(lidRight, true)

    table.insert(dumpsters, {id = savedIndex, prop = dumpster, prop2 = lidLeft, prop3 = lidRight})
    print(json.encode(dumpsters))
end

RegisterNetEvent('babapro', function()
    spawnDumpsters()
end)

RegisterCommand('dumpster', function()
    if not isInDumpster then
        local closestIndex = nil
        local closestDistance = math.huge
        
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        for index, coord in ipairs(NMConfig['Coords']) do
            local coordVec = coord['coords']
            local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, coordVec.x, coordVec.y, coordVec.z)
        
            if distance < closestDistance then
                closestDistance = distance
                closestIndex = index
            end
        end
        
        if closestIndex then
            if closestDistance < 5 then
                local targetId = closestIndex
        
                local foundDumpster = nil
        
                for _, dumpster in ipairs(dumpsters) do
                    if dumpster.id == targetId then
                        foundDumpster = dumpster
                        break
                    end
                end
        
                if foundDumpster then
                    TriggerEvent('ry-dumpster:enter', GetEntityCoords(foundDumpster.prop), GetEntityRotation(foundDumpster.prop))
                    DeleteEntity(foundDumpster.prop)
                    DeleteEntity(foundDumpster.prop2)
                    DeleteEntity(foundDumpster.prop3)
                    savedIndex = foundDumpster.id
                    for i, dumpster in ipairs(dumpsters) do
                        if dumpster.id == savedIndex then
                            table.remove(dumpsters, i)
                            print(json.encode(dumpsters))
                            break
                        end
                    end
                end
            end
        else
            print("Koordinat bulunamadı.")
        end
    else
        TriggerEvent('ry-dumpster:exit')
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if isInDumpster then
            sleep = 5
            if GetFollowPedCamViewMode() ~= 4 then
                SetFollowPedCamViewMode(4)
            end
        end
        Wait(sleep)
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    spawnDumpsters()
end)
  
