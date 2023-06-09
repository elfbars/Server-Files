previewPed = nil
isInterfaceOpening = false
isModelLoaded = false

isPlayerReady = false
function PreparePlayer()
    if not IsScreenFadedOut() then
        DoScreenFadeOut(0)
    end
    Wait(7500)
    DoScreenFadeIn(500)
    isPlayerReady = true
end

Citizen.CreateThread(function()
    while GetIsLoadingScreenActive() do
        Citizen.Wait(100)
    end
    PreparePlayer()
end)

function IsPlayerFullyLoaded()
    return isPlayerReady
end

local initialized = false
local openTabs = {}
local currentTab = nil
local isVisible = false
local isCancelable = true
local playerLoaded = false
local firstSpawn = true
local identityLoaded = false
local preparingSkin = true
local isPlayerNew = false
local firstCharacter = false
local newCharacter = false
local currentChar = {}
local oldChar = {}
local oldLoadout = {}
local currentIdentity = nil

function BeginCharacterPreview()
    for k, v in pairs(currentChar) do
        oldChar[k] = v
    end
    SetEntityVisible(PlayerPedId(), false)
    local playerHeading = GetEntityHeading(PlayerPedId())
    previewPed = ClonePed(PlayerPedId(), false, false, true)
    FreezePedCameraRotation(previewPed, true)
    FreezeEntityPosition(previewPed, true)
    PlayIdleAnimation(previewPed)
end

function EndCharacterPreview(save)
    if previewPed then
        if save then
            local newModelHash = GetHashKey('mp_m_freemode_01')
            if currentChar.sex == 1 then
                newModelHash = GetHashKey('mp_f_freemode_01')
            end
            if GetEntityModel(PlayerPedId()) ~= newModelHash then
                LoadModel(newModelHash)
            end
            ClonePedToTarget(previewPed, PlayerPedId())
        else
            for k, v in pairs(oldChar) do
                currentChar[k] = v
            end
        end
        ClearAllAnimations(previewPed)
        DeleteEntity(previewPed)
        SetEntityVisible(PlayerPedId(), true)
        previewPed = nil
    end
end

function setVisible(visible)
    SetNuiFocus(visible, visible)
    SendNUIMessage({
        action = 'setVisible',
        show = visible
    })
    isVisible = visible
    DisplayRadar(not visible)
end

function ResetAllTabs()
    local clothes = nil
    for k, v in pairs(openTabs) do
        if openTabs[k] == 'apparel' then
            clothes = GetClothesData()
        end
    end
    SendNUIMessage({
        action = 'enableTabs',
        tabs = openTabs,
        character = currentChar,
        clothes = clothes,
        identity = currentIdentity
    })
end


AddEventHandler('FDMBarbers:close', function(save)
    if (not save) and (not isCancelable) then
        return
    end
    if save then
        print(json.encode(currentChar.mom))
        TriggerServerEvent('FDMBarbers:save', currentChar)
    end
    EndCharacterPreview(save)
    SetModelAsNoLongerNeeded(GetHashKey('mp_m_freemode_01'))
    SetModelAsNoLongerNeeded(GetHashKey('mp_f_freemode_01'))
    SetStreamedTextureDictAsNoLongerNeeded('mparrow')
    SetStreamedTextureDictAsNoLongerNeeded('mpleaderboard')
    if identityLoaded == true then
        SetStreamedTextureDictAsNoLongerNeeded('pause_menu_pages_char_mom_dad')
        SetStreamedTextureDictAsNoLongerNeeded('char_creator_portraits')
        identityLoaded = false
    end

    Camera.Deactivate()

    isCancelable = true
    setVisible(false)

    for i = 0, #openTabs do
        openTabs[i] = nil
    end
end)

RegisterNetEvent('FDMBarbers:open')
AddEventHandler('FDMBarbers:open', function(tabs, cancelable)
    if isInterfaceOpening then
        return
    end
    isInterfaceOpening = true
    if cancelable ~= nil then
        isCancelable = cancelable
    end

    while (not initialized) or (not isModelLoaded) or (not isPlayerReady) do
        Citizen.Wait(100)
    end

    -- Request character models and ui textures
    local maleModelHash = GetHashKey('mp_m_freemode_01')
    local femaleModelHash = GetHashKey('mp_f_freemode_01')
    RequestModel(maleModelHash)
    RequestModel(femaleModelHash)
    RequestStreamedTextureDict('mparrow')
    RequestStreamedTextureDict('mpleaderboard')
    while not HasStreamedTextureDictLoaded('mparrow') or 
          not HasStreamedTextureDictLoaded('mpleaderboard') or 
          not HasModelLoaded(maleModelHash) or
          not HasModelLoaded(femaleModelHash) do
        Wait(100)
    end

    BeginCharacterPreview()

    SendNUIMessage({
        action = 'clearAllTabs'
    })

    local firstTabName = ''
    local clothes = nil
    for i = 0, #openTabs do
        openTabs[i] = nil
    end

    for k, v in pairs(tabs) do
        if k == 1 then
            firstTabName = v
        end

        local tabName = tabs[k]
        table.insert(openTabs, tabName)
        if tabName == 'identity' then
            if not identityLoaded then
                RequestStreamedTextureDict('pause_menu_pages_char_mom_dad')
                RequestStreamedTextureDict('char_creator_portraits')
                while not HasStreamedTextureDictLoaded('pause_menu_pages_char_mom_dad') or not HasStreamedTextureDictLoaded('char_creator_portraits') do
                    Wait(100)
                end
                identityLoaded = true
            end
        end
    end

    SendNUIMessage({
        action = 'enableTabs',
        tabs = tabs,
        character = currentChar,
        clothes = clothes,
        identity = currentIdentity
    })

    SendNUIMessage({
        action = 'activateTab',
        tab = firstTabName
    })

    if newCharacter then
        Camera.Activate(500)
    else
        Camera.Activate()
    end

    SendNUIMessage({
        action = 'refreshViewButtons',
        view = Camera.currentView
    })

    SendNUIMessage({
        action = 'setCancelable',
        value = isCancelable
    })

    setVisible(true)
    isInterfaceOpening = false
end)

AddEventHandler('FDMBarbers:getCurrentClothes', function(cb)
    local result = {}
    result.sex = currentChar.sex
    result.tshirt_1 = currentChar.tshirt_1
    result.tshirt_2 = currentChar.tshirt_2
    result.torso_1 = currentChar.torso_1
    result.torso_2 = currentChar.torso_2
    result.decals_1 = currentChar.decals_1
    result.decals_2 = currentChar.decals_2
    result.arms = currentChar.arms
    result.arms_2 = currentChar.arms_2
    result.pants_1 = currentChar.pants_1
    result.pants_2 = currentChar.pants_2
    result.shoes_1 = currentChar.shoes_1
    result.shoes_2 = currentChar.shoes_2
    result.mask_1 = currentChar.mask_1
    result.mask_2 = currentChar.mask_2
    result.bproof_1 = currentChar.bproof_1
    result.bproof_2 = currentChar.bproof_2
    result.neckarm_1 = currentChar.chain_1 or currentChar.neckarm_1
    result.neckarm_2 = currentChar.chain_2 or currentChar.neckarm_2
    result.helmet_1 = currentChar.helmet_1
    result.helmet_2 = currentChar.helmet_2
    result.glasses_1 = currentChar.glasses_1
    result.glasses_2 = currentChar.glasses_2
    result.lefthand_1 = currentChar.watches_1 or currentChar.lefthand_1
    result.lefthand_2 = currentChar.watches_2 or currentChar.lefthand_2
    result.righthand_1 = currentChar.bracelets_1 or currentChar.righthand_1
    result.righthand_2 = currentChar.bracelets_2 or currentChar.righthand_2
    result.bags_1 = currentChar.bags_1
    result.bags_2 = currentChar.bags_2
    result.ears_1 = currentChar.ears_1
    result.ears_2 = currentChar.ears_2
    cb(result)
end)


AddEventHandler('onClientResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Citizen.CreateThread(function()
            Citizen.Wait(250)
            TriggerServerEvent('FDMBarbers:requestPlayerData')
        end)
    end
end)

RegisterNetEvent('FDMBarbers:recievePlayerData')
AddEventHandler('FDMBarbers:recievePlayerData', function(playerData)
    isPlayerNew = playerData.newPlayer
    if not isPlayerNew then
        LoadCharacter(playerData.skin, false)
    else
        LoadCharacter(GetDefaultCharacter(true), true)
    end
    preparingSkin = false
    playerLoaded = true
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
end)

Citizen.CreateThread(function()
    while preparingSkin do
        Citizen.Wait(100)
    end
    TriggerEvent('FDMBarbers:playerPrepared', isPlayerNew)
    firstSpawn = false

    while not initialized do
        SendNUIMessage({
            action = 'loadInitData',
            hair = GetColorData(GetHairColors(), true),
            lipstick = GetColorData(GetLipstickColors(), false),
            facepaint = GetColorData(GetFacepaintColors(), false),
            blusher = GetColorData(GetBlusherColors(), false),
            naturaleyecolors = Config.UseNaturalEyeColors,

            -- esx identity integration
            esxidentity = Config.EnableESXIdentityIntegration,
            identitylimits = {
                namemax = Config.MaxNameLength,
                heightmin = Config.MinHeight,
                heightmax = Config.MaxHeight,
                yearmin = Config.LowestYear,
                yearmax = Config.HighestYear
            },
        })

        initialized = true
        Citizen.Wait(100)
    end
end)

RegisterNUICallback('setCameraView', function(data, cb)
    Camera.SetView(data['view'])
end)

RegisterNUICallback('updateCameraRotation', function(data, cb)
    Camera.mouseX = tonumber(data['x'])
    Camera.mouseY = tonumber(data['y'])
    Camera.updateRot = true
end)

RegisterNUICallback('updateCameraZoom', function(data, cb)
    Camera.radius = Camera.radius + (tonumber(data['zoom']))
    Camera.updateZoom = true
end)

RegisterNUICallback('playSound', function(data, cb)
    local sound = data['sound']
    if sound == 'tabchange' then
        PlaySoundFrontend(-1, 'Continue_Appears', 'DLC_HEIST_PLANNING_BOARD_SOUNDS', 1)
    elseif sound == 'mouseover' then
        PlaySoundFrontend(-1, 'Faster_Click', 'RESPAWN_ONLINE_SOUNDSET', 1)
    elseif sound == 'panelbuttonclick' then
        PlaySoundFrontend(-1, 'Reset_Prop_Position', 'DLC_Dmod_Prop_Editor_Sounds', 0)
    elseif sound == 'optionchange' then
        PlaySoundFrontend(-1, 'HACKING_MOVE_CURSOR', 0, 1)
    end
end)

RegisterNUICallback('setCurrentTab', function(data, cb)
    currentTab = data['tab']
end)

RegisterNUICallback('close', function(data, cb)
    TriggerEvent('FDMBarbers:close', data['save'])
end)

RegisterNUICallback('updateMakeupType', function(data, cb)
    --[[
            NOTE:   This is a pure control variable that does not call any natives.
                    It only modifies which options are going to be visible in the ui.

                    Since face paint replaces blusher and eye makeup,
                    we need to save in the database which type the player selected:

                    0 - 'None',
                    1 - 'Eye Makeup',
                    2 - 'Face Paint'
    ]]--
    local type = tonumber(data['type'])
    currentChar['makeup_type'] = type

    SendNUIMessage({
        action = 'refreshMakeup',
        character = currentChar
    })
end)

RegisterNUICallback('syncFacepaintOpacity', function(data, cb)
    local prevtype = data['prevtype']
    local currenttype = data['currenttype']
    local prevopacity = prevtype .. '_2'
    local currentopacity = currenttype .. '_2'
    currentChar[currentopacity] = currentChar[prevopacity]
end)

RegisterNUICallback('clearMakeup', function(data, cb)
    if data['clearopacity'] then
        currentChar['makeup_2'] = 100
        if data['clearblusher'] then
            currentChar['blush_2'] = 100
        end
    end

    currentChar['makeup_1'] = 255
    currentChar['makeup_3'] = 255
    currentChar['makeup_4'] = 255
    

    SetPedHeadOverlay(previewPed, 4, currentChar.makeup_1, currentChar.makeup_2 / 100 + 0.0) -- Eye Makeup
    SetPedHeadOverlayColor(previewPed, 4, 0, currentChar.makeup_3, currentChar.makeup_4)     -- Eye Makeup Color

    if data['clearblusher'] then
        currentChar['blush_1'] = 255
        currentChar['blush_3'] = 0
        SetPedHeadOverlay(previewPed, 5, currentChar.blush_1, currentChar.blush_2 / 100 + 0.0)   -- Blusher
        SetPedHeadOverlayColor(previewPed, 5, 2, currentChar.blush_3, 255)                       -- Blusher Color
    end
end)

RegisterNUICallback('updateGender', function(data, cb)
    currentChar.sex = tonumber(data['value'])
    local modelHash = nil
    local isMale = true
    if currentChar.sex == 0 then
        modelHash = GetHashKey('mp_m_freemode_01')
    elseif currentChar.sex == 1 then
        isMale = false
        modelHash = GetHashKey('mp_f_freemode_01')
    else
        return
    end

    -- NOTE: There seems to be no native for model change that preserves existing coords
    local previewCoords = GetEntityCoords(previewPed)
    DeleteEntity(previewPed)
    previewPed = CreatePed(4, modelHash, 397.92, -1004.4, -99.0, false, true)
    local defaultChar = GetDefaultCharacter(isMale)
    ApplySkinToPed(previewPed, defaultChar)
    for k, v in pairs(defaultChar) do
        currentChar[k] = v
    end
    ResetAllTabs()
    local playerCoords = GetEntityCoords(PlayerPedId())
    for height = playerCoords.z, 1000 do
        SetPedCoordsKeepVehicle(previewPed, previewCoords.x, previewCoords.y, height + 0.0)
        local foundGround, zPos = GetGroundZFor_3dCoord(previewCoords.x, previewCoords.y, height + 0.0)
        if foundGround then
            SetPedCoordsKeepVehicle(previewPed, previewCoords.x, previewCoords.y, zPos)
            break
        end
    end
    PlayIdleAnimation(previewPed)
end)

RegisterNUICallback('updateHeadBlend', function(data, cb)
    local weightFace = currentChar.face_md_weight / 100 + 0.0
    local weightSkin = currentChar.skin_md_weight / 100 + 0.0
    currentChar.mom = data.value;
    currentChar.dad = data.value;
    SetPedHeadBlendData(previewPed, 0, 0, 0, data.value, data.value, 0, weightFace, weightSkin, 0.0, false)
end)

RegisterNUICallback('updateFaceFeature', function(data, cb)
    local key = data['key']
    local value = tonumber(data['value'])
    local index = tonumber(data['index'])
    currentChar[key] = value
    SetPedFaceFeature(previewPed, index, (currentChar[key] / 100) + 0.0)
end)

RegisterNUICallback('updateEyeColor', function(data, cb)
    local value = tonumber(data['value'])
    currentChar['eye_color'] = value
    SetPedEyeColor(previewPed, currentChar.eye_color)
end)

RegisterNUICallback('updateHairColor', function(data, cb)
    local key = data['key']
    local value = tonumber(data['value'])
    local highlight = data['highlight']
    currentChar[key] = value

    if highlight then
        SetPedHairColor(previewPed, currentChar['hair_color_1'], currentChar[key])
    else
        SetPedHairColor(previewPed, currentChar[key], currentChar['hair_color_2'])
    end
end)

RegisterNUICallback('updateHeadOverlay', function(data, cb)
    local key = data['key']
    local keyPaired = data['keyPaired']
    local value = tonumber(data['value'])
    local index = tonumber(data['index'])
    local isOpacity = (data['isOpacity'])
    currentChar[key] = value

    if isOpacity then
        SetPedHeadOverlay(previewPed, index, currentChar[keyPaired], currentChar[key] / 100 + 0.0)
    else
        SetPedHeadOverlay(previewPed, index, currentChar[key], currentChar[keyPaired] / 100 + 0.0)
    end
end)

RegisterNUICallback('updateHeadOverlayExtra', function(data, cb)
    local key = data['key']
    local keyPaired = data['keyPaired']
    local value = tonumber(data['value'])
    local index = tonumber(data['index'])
    local keyExtra = data['keyExtra']
    local valueExtra = tonumber(data['valueExtra'])
    local indexExtra = tonumber(data['indexExtra'])
    local isOpacity = (data['isOpacity'])

    currentChar[key] = value

    if isOpacity then
        currentChar[keyExtra] = value
        SetPedHeadOverlay(previewPed, index, currentChar[keyPaired], currentChar[key] / 100 + 0.0)
        SetPedHeadOverlay(previewPed, indexExtra, valueExtra, currentChar[key] / 100 + 0.0)
    else
        currentChar[keyExtra] = valueExtra
        SetPedHeadOverlay(previewPed, index, currentChar[key], currentChar[keyPaired] / 100 + 0.0)
        SetPedHeadOverlay(previewPed, indexExtra, currentChar[keyExtra], currentChar[keyPaired] / 100 + 0.0)
    end
end)

RegisterNUICallback('updateOverlayColor', function(data, cb)
    local key = data['key']
    local value = tonumber(data['value'])
    local index = tonumber(data['index'])
    local colortype = tonumber(data['colortype'])
    currentChar[key] = value

    SetPedHeadOverlayColor(previewPed, index, colortype, currentChar[key])
end)

RegisterNUICallback('updateComponent', function(data, cb)
    local drawableKey = data['drawable']
    local drawableValue = tonumber(data['dvalue'])
    local textureKey = data['texture']
    local textureValue = tonumber(data['tvalue'])
    local index = tonumber(data['index'])
    currentChar[drawableKey] = drawableValue
    currentChar[textureKey] = textureValue

    SetPedComponentVariation(previewPed, index, currentChar[drawableKey], currentChar[textureKey], 2)
end)

RegisterNUICallback('updateApparelComponent', function(data, cb)
    local drawableKey = data['drwkey']
    local textureKey = data['texkey']
    local component = tonumber(data['cmpid'])
    currentChar[drawableKey] = tonumber(data['drwval'])
    currentChar[textureKey] = tonumber(data['texval'])

    SetPedComponentVariation(previewPed, component, currentChar[drawableKey], currentChar[textureKey], 2)

    -- Some clothes have 'forced components' that change torso and other parts.
    -- adapted from: https://gist.github.com/root-cause/3b80234367b0c856d60bf5cb4b826f86
    local hash = GetHashNameForComponent(previewPed, component, currentChar[drawableKey], currentChar[textureKey])
    --print('main component hash ' .. hash)
    local fcDrawable, fcTexture, fcType = -1, -1, -1
    local fcCount = GetShopPedApparelForcedComponentCount(hash) - 1
    --print('found ' .. fcCount + 1 .. ' forced components')
    for fcId = 0, fcCount do
        local fcNameHash, fcEnumVal, f5, f7, f8 = -1, -1, -1, -1, -1
        fcNameHash, fcEnumVal, fcType = GetForcedComponent(hash, fcId)
        --print('forced component [' .. fcId .. ']: nameHash: ' .. fcNameHash .. ', enumVal: ' .. fcEnumVal .. ', type: ' .. fcType--[[.. ', field5: ' .. f5 .. ', field7: ' .. f7 .. ', field8: ' .. f8 --]])

        -- only set torsos, using other types here seems to glitch out
        if fcType == 3 then
            if (fcNameHash == 0) or (fcNameHash == GetHashKey('0')) then
                fcDrawable = fcEnumVal
                fcTexture = 0
            else
                fcType, fcDrawable, fcTexture = GetComponentDataFromHash(fcNameHash)
            end

            -- Apply component to ped, save it in current character data
            if IsPedComponentVariationValid(previewPed, fcType, fcDrawable, fcTexture) then
                currentChar['arms'] = fcDrawable
                currentChar['arms_2'] = fcTexture
                SetPedComponentVariation(previewPed, fcType, fcDrawable, fcTexture, 2)
            end
        end
    end

    -- Forced components do not pick proper torso for 'None' variant, need manual correction
    if GetEntityModel(previewPed) == GetHashKey('mp_f_freemode_01') then
        if (GetPedDrawableVariation(previewPed, 11) == 15) and (GetPedTextureVariation(previewPed, 11) == 16) then
            currentChar['arms'] = 15
            currentChar['arms_2'] = 0
            SetPedComponentVariation(previewPed, 3, 15, 0, 2);
        end
    elseif GetEntityModel(previewPed) == GetHashKey('mp_m_freemode_01') then
        if (GetPedDrawableVariation(previewPed, 11) == 15) and (GetPedTextureVariation(previewPed, 11) == 0) then
            currentChar['arms'] = 15
            currentChar['arms_2'] = 0
            SetPedComponentVariation(previewPed, 3, 15, 0, 2);
        end
    end
end)

RegisterNUICallback('updateApparelProp', function(data, cb)
    local drawableKey = data['drwkey']
    local textureKey = data['texkey']
    local prop = tonumber(data['propid'])
    currentChar[drawableKey] = tonumber(data['drwval'])
    currentChar[textureKey] = tonumber(data['texval'])

    if currentChar[drawableKey] == -1 then
        ClearPedProp(previewPed, prop)
    else
        SetPedPropIndex(previewPed, prop, currentChar[drawableKey], currentChar[textureKey], false)
    end
end)

function GetHairColors()
    local result = {}
    local i = 0

    if Config.UseNaturalHairColors then
        for i = 0, 18 do
            table.insert(result, i)
        end
        table.insert(result, 24)
        table.insert(result, 26)
        table.insert(result, 27)
        table.insert(result, 28)
        for i = 55, 60 do
            table.insert(result, i)
        end
    else
        for i = 0, 60 do
            table.insert(result, i)
        end
    end

    return result
end

function GetLipstickColors()
    local result = {}
    local i = 0

    for i = 0, 31 do
        table.insert(result, i)
    end
    table.insert(result, 48)
    table.insert(result, 49)
    table.insert(result, 55)
    table.insert(result, 56)
    table.insert(result, 62)
    table.insert(result, 63)

    return result
end

function GetFacepaintColors()
    local result = {}
    local i = 0

    for i = 0, 63 do
        table.insert(result, i)
    end

    return result
end

function GetBlusherColors()
    local result = {}
    local i = 0

    for i = 0, 22 do
        table.insert(result, i)
    end
    table.insert(result, 25)
    table.insert(result, 26)
    table.insert(result, 51)
    table.insert(result, 60)

    return result
end

function RGBToHexCode(r, g, b)
    local result = string.format('#%x', ((r << 16) | (g << 8) | b))
    return result
end

function GetColorData(indexes, isHair)
    local result = {}
    local GetRgbColor = nil

    if isHair then
        GetRgbColor = function(index)
            return GetPedHairRgbColor(index)
        end
    else
        GetRgbColor = function(index)
            return GetPedMakeupRgbColor(index)
        end
    end

    for i, index in ipairs(indexes) do
        local r, g, b = GetRgbColor(index)
        local hex = RGBToHexCode(r, g, b)
        table.insert(result, { index = index, hex = hex })
    end

    return result
end

function GetComponentDataFromHash(hash)
    local blob = string.rep('\0\0\0\0\0\0\0\0', 9 + 16)
    if not Citizen.InvokeNative(0x74C0E2A57EC66760, hash, blob) then
        return nil
    end

    -- adapted from: https://gist.github.com/root-cause/3b80234367b0c856d60bf5cb4b826f86
    local lockHash = string.unpack('<i4', blob, 1)
    local hash = string.unpack('<i4', blob, 9)
    local locate = string.unpack('<i4', blob, 17)
    local drawable = string.unpack('<i4', blob, 25)
    local texture = string.unpack('<i4', blob, 33)
    local field5 = string.unpack('<i4', blob, 41)
    local component = string.unpack('<i4', blob, 49)
    local field7 = string.unpack('<i4', blob, 57)
    local field8 = string.unpack('<i4', blob, 65)
    local gxt = string.unpack('c64', blob, 73)

    return component, drawable, texture, gxt, field5, field7, field8
end

function GetPropDataFromHash(hash)
    local blob = string.rep('\0\0\0\0\0\0\0\0', 9 + 16)
    if not Citizen.InvokeNative(0x5D5CAFF661DDF6FC, hash, blob) then
        return nil
    end

    -- adapted from: https://gist.github.com/root-cause/3b80234367b0c856d60bf5cb4b826f86
    local lockHash = string.unpack('<i4', blob, 1)
    local hash = string.unpack('<i4', blob, 9)
    local locate = string.unpack('<i4', blob, 17)
    local drawable = string.unpack('<i4', blob, 25)
    local texture = string.unpack('<i4', blob, 33)
    local field5 = string.unpack('<i4', blob, 41)
    local prop = string.unpack('<i4', blob, 49)
    local field7 = string.unpack('<i4', blob, 57)
    local field8 = string.unpack('<i4', blob, 65)
    local gxt = string.unpack('c64', blob, 73)

    return prop, drawable, texture, gxt, field5, field7, field8
end

function GetComponentsData(id)
    local result = {}

    local componentBlacklist = nil

    if blacklist ~= nil then
        if GetEntityModel(previewPed) == GetHashKey('mp_m_freemode_01') then
            componentBlacklist = blacklist.components.male
        elseif GetEntityModel(previewPed) == GetHashKey('mp_f_freemode_01') then
            componentBlacklist = blacklist.components.female
        end
    end

    local drawableCount = GetNumberOfPedDrawableVariations(previewPed, id) - 1

    for drawable = 0, drawableCount do
        local textureCount = GetNumberOfPedTextureVariations(previewPed, id, drawable) - 1

        for texture = 0, textureCount do
            local hash = GetHashNameForComponent(previewPed, id, drawable, texture)

            if hash ~= 0 then
                local component, drawable, texture, gxt = GetComponentDataFromHash(hash)
                -- only named components
                if gxt ~= '' then
                    label = GetLabelText(gxt)
                    if label ~= 'NULL' then
                        local blacklisted = false

                        if componentBlacklist ~= nil then
                            if componentBlacklist[component] ~= nil then
                                if componentBlacklist[component][drawable] ~= nil then
                                    if componentBlacklist[component][drawable][texture] ~= nil then
                                        blacklisted = true
                                    end
                                end
                            end
                        end
    
                        if not blacklisted then
                            table.insert(result, {
                                name = label,
                                component = component,
                                drawable = drawable,
                                texture = texture
                            })
                        end
                    end
                end
            end
        end
    end

    return result
end

function GetPropsData(id)
    local result = {}

    local propBlacklist = nil

    if blacklist ~= nil then
        if GetEntityModel(previewPed) == GetHashKey('mp_m_freemode_01') then
            propBlacklist = blacklist.props.male
        elseif GetEntityModel(previewPed) == GetHashKey('mp_f_freemode_01') then
            propBlacklist = blacklist.props.female
        end
    end

    local drawableCount = GetNumberOfPedPropDrawableVariations(previewPed, id) - 1

    for drawable = 0, drawableCount do
        local textureCount = GetNumberOfPedPropTextureVariations(previewPed, id, drawable) - 1

        for texture = 0, textureCount do
            local hash = GetHashNameForProp(previewPed, id, drawable, texture)

            if hash ~= 0 then
                local prop, drawable, texture, gxt = GetPropDataFromHash(hash)

                -- only named props
                if gxt ~= '' then
                    label = GetLabelText(gxt)
                    if label ~= 'NULL' then
                        local blacklisted = false

                        if propBlacklist ~= nil then
                            if propBlacklist[prop] ~= nil then
                                if propBlacklist[prop][drawable] ~= nil then
                                    if propBlacklist[prop][drawable][texture] ~= nil then
                                        blacklisted = true
                                    end
                                end
                            end
                        end

                        if not blacklisted then
                            table.insert(result, {
                                name = label,
                                prop = prop,
                                drawable = drawable,
                                texture = texture
                            })
                        end
                    end
                end
            end
        end
    end

    return result
end

function GetClothesData()
    local result = {
        topsover = {},
        topsunder = {},
        pants = {},
        shoes = {},
        bags = {},
        masks = {},
        neckarms = {},
        hats = {},
        ears = {},
        glasses = {},
        lefthands = {},
        righthands = {},
    }

    result.topsover = GetComponentsData(11)
    result.topsunder = GetComponentsData(8)
    result.pants = GetComponentsData(4)
    result.shoes = GetComponentsData(6)
    -- result.bags = GetComponentsData(5)   -- there seems to be no named components in this category
    result.masks = GetComponentsData(1)
    result.neckarms = GetComponentsData(7)  -- chains/ties/suspenders/bangles

    result.hats = GetPropsData(0)
    result.ears = GetPropsData(2)
    result.glasses = GetPropsData(1)
    result.lefthands = GetPropsData(6)
    result.righthands = GetPropsData(7)
    return result
end

function GetDefaultCharacter(isMale)
    local result = {
        sex = 1,
        mom = 21,
        dad = 0,
        face_md_weight = 50,
        skin_md_weight = 50,
        nose_1 = 0,
        nose_2 = 0,
        nose_3 = 0,
        nose_4 = 0,
        nose_5 = 0,
        nose_6 = 0,
        cheeks_1 = 0,
        cheeks_2 = 0,
        cheeks_3 = 0,
        lip_thickness = 0,
        jaw_1 = 0,
        jaw_2 = 0,
        chin_1 = 0,
        chin_2 = 0,
        chin_3 = 0,
        chin_4 = 0,
        neck_thickness = 0,
        hair_1 = 0,
        hair_2 = 0,
        hair_color_1 = 0,
        hair_color_2 = 0,
        tshirt_1 = 0,
        tshirt_2 = 0,
        torso_1 = 0,
        torso_2 = 0,
        decals_1 = 0,
        decals_2 = 0,
        arms = 15,
        arms_2 = 0,
        pants_1 = 0,
        pants_2 = 0,
        shoes_1 = 0,
        shoes_2 = 0,
        mask_1 = 0,
        mask_2 = 0,
        bproof_1 = 0,
        bproof_2 = 0,
        neckarm_1 = 0,
        neckarm_2 = 0,
        helmet_1 = -1,
        helmet_2 = 0,
        glasses_1 = -1,
        glasses_2 = 0,
        lefthand_1 = -1,
        lefthand_2 = 0,
        righthand_1 = -1,
        righthand_2 = 0,
        bags_1 = 0,
        bags_2 = 0,
        eye_color = 0,
        eye_squint = 0,
        eyebrows_2 = 100,
        eyebrows_1 = 0,
        eyebrows_3 = 0,
        eyebrows_4 = 0,
        eyebrows_5 = 0,
        eyebrows_6 = 0,
        makeup_type = 0,
        makeup_1 = 255,
        makeup_2 = 100,
        makeup_3 = 255,
        makeup_4 = 255,
        lipstick_1 = 255,
        lipstick_2 = 100,
        lipstick_3 = 0,
        lipstick_4 = 0,
        ears_1 = -1,
        ears_2 = 0,
        chest_1 = 255,
        chest_2 = 100,
        chest_3 = 0,
        chest_4 = 0,
        bodyb_1 = 255,
        bodyb_2 = 100,
        bodyb_3 = 255,
        bodyb_4 = 100,
        age_1 = 255,
        age_2 = 100,
        blemishes_1 = 255,
        blemishes_2 = 100,
        blush_1 = 255,
        blush_2 = 100,
        blush_3 = 0,
        complexion_1 = 255,
        complexion_2 = 100,
        sun_1 = 255,
        sun_2 = 100,
        moles_1 = 255,
        moles_2 = 100,
        beard_1 = 255,
        beard_2 = 100,
        beard_3 = 0,
        beard_4 = 0
    }

    if isMale then
        result['sex'] = 0
        result['torso_1'] = 15
        result['tshirt_1'] = 15
        result['pants_1'] = 61
        result['shoes_1'] = 34
    else
        result['torso_1'] = 18
        result['tshirt_1'] = 2
        result['pants_1'] = 19
        result['shoes_1'] = 35
    end

    return result
end

function LoadModel(hash, setModel)
    isModelLoaded = false
    local playerPed = PlayerPedId()

    if IsModelInCdimage(hash) and IsModelValid(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(0)
        end
        if setModel then
            SetPlayerModel(PlayerId(), hash)
            FreezePedCameraRotation(playerPed, true)
        end
    end
    isModelLoaded = true
end

function PlayIdleAnimation(ped)
    local animDict = nil

    if GetEntityModel(ped) == GetHashKey('mp_m_freemode_01') then
        animDict = 'anim@heists@heist_corona@team_idles@male_c'
    elseif GetEntityModel(ped) == GetHashKey('mp_f_freemode_01') then
        animDict = 'anim@heists@heist_corona@team_idles@female_a'
    else
        return
    end

    while not HasAnimDictLoaded(animDict) do
        RequestAnimDict(animDict)
        Wait(100)
    end

    ClearPedTasksImmediately(ped)
    TaskPlayAnim(ped, animDict, 'idle', 1.0, 1.0, -1, 1, 1, 0, 0, 0)
end

function ClearAllAnimations(ped)
    ClearPedTasksImmediately(ped)

    if HasAnimDictLoaded('anim@heists@heist_corona@team_idles@female_a') then
        RemoveAnimDict('anim@heists@heist_corona@team_idles@female_a')
    end

    if HasAnimDictLoaded('anim@heists@heist_corona@team_idles@male_c') then
        RemoveAnimDict('anim@heists@heist_corona@team_idles@male_c')
    end
end

-- Loading character data
function ApplySkinToPed(ped, skin)
    -- Face Blend
    local weightFace = skin.face_md_weight / 100 + 0.0
    local weightSkin = skin.skin_md_weight / 100 + 0.0
    SetPedHeadBlendData(ped, skin.mom, skin.dad, 0, skin.mom, skin.dad, 0, weightFace, weightSkin, 0.0, false)

    -- Facial Features
    SetPedFaceFeature(ped, 0,  (skin.nose_1 / 100)         + 0.0)  -- Nose Width
    SetPedFaceFeature(ped, 1,  (skin.nose_2 / 100)         + 0.0)  -- Nose Peak Height
    SetPedFaceFeature(ped, 2,  (skin.nose_3 / 100)         + 0.0)  -- Nose Peak Length
    SetPedFaceFeature(ped, 3,  (skin.nose_4 / 100)         + 0.0)  -- Nose Bone Height
    SetPedFaceFeature(ped, 4,  (skin.nose_5 / 100)         + 0.0)  -- Nose Peak Lowering
    SetPedFaceFeature(ped, 5,  (skin.nose_6 / 100)         + 0.0)  -- Nose Bone Twist
    SetPedFaceFeature(ped, 6,  (skin.eyebrows_5 / 100)     + 0.0)  -- Eyebrow height
    SetPedFaceFeature(ped, 7,  (skin.eyebrows_6 / 100)     + 0.0)  -- Eyebrow depth
    SetPedFaceFeature(ped, 8,  (skin.cheeks_1 / 100)       + 0.0)  -- Cheekbones Height
    SetPedFaceFeature(ped, 9,  (skin.cheeks_2 / 100)       + 0.0)  -- Cheekbones Width
    SetPedFaceFeature(ped, 10, (skin.cheeks_3 / 100)       + 0.0)  -- Cheeks Width
    SetPedFaceFeature(ped, 11, (skin.eye_squint / 100)     + 0.0)  -- Eyes squint
    SetPedFaceFeature(ped, 12, (skin.lip_thickness / 100)  + 0.0)  -- Lip Fullness
    SetPedFaceFeature(ped, 13, (skin.jaw_1 / 100)          + 0.0)  -- Jaw Bone Width
    SetPedFaceFeature(ped, 14, (skin.jaw_2 / 100)          + 0.0)  -- Jaw Bone Length
    SetPedFaceFeature(ped, 15, (skin.chin_1 / 100)         + 0.0)  -- Chin Height
    SetPedFaceFeature(ped, 16, (skin.chin_2 / 100)         + 0.0)  -- Chin Length
    SetPedFaceFeature(ped, 17, (skin.chin_3 / 100)         + 0.0)  -- Chin Width
    SetPedFaceFeature(ped, 18, (skin.chin_4 / 100)         + 0.0)  -- Chin Hole Size
    SetPedFaceFeature(ped, 19, (skin.neck_thickness / 100) + 0.0)  -- Neck Thickness

    -- Appearance
    SetPedComponentVariation(ped, 2, skin.hair_1, skin.hair_2, 2)                  -- Hair Style
    SetPedHairColor(ped, skin.hair_color_1, skin.hair_color_2)                     -- Hair Color
    SetPedHeadOverlay(ped, 2, skin.eyebrows_1, skin.eyebrows_2 / 100 + 0.0)        -- Eyebrow Style + Opacity
    SetPedHeadOverlayColor(ped, 2, 1, skin.eyebrows_3, skin.eyebrows_4)            -- Eyebrow Color
    SetPedHeadOverlay(ped, 1, skin.beard_1, skin.beard_2 / 100 + 0.0)              -- Beard Style + Opacity
    SetPedHeadOverlayColor(ped, 1, 1, skin.beard_3, skin.beard_4)                  -- Beard Color

    SetPedHeadOverlay(ped, 0, skin.blemishes_1, skin.blemishes_2 / 100 + 0.0)      -- Skin blemishes + Opacity
    SetPedHeadOverlay(ped, 12, skin.bodyb_3, skin.bodyb_4 / 100 + 0.0)             -- Skin blemishes body effect + Opacity

    SetPedHeadOverlay(ped, 11, skin.bodyb_1, skin.bodyb_2 / 100 + 0.0)             -- Body Blemishes + Opacity

    SetPedHeadOverlay(ped, 3, skin.age_1, skin.age_2 / 100 + 0.0)                  -- Age + opacity
    SetPedHeadOverlay(ped, 6, skin.complexion_1, skin.complexion_2 / 100 + 0.0)    -- Complexion + Opacity
    SetPedHeadOverlay(ped, 9, skin.moles_1, skin.moles_2 / 100 + 0.0)              -- Moles/Freckles + Opacity
    SetPedHeadOverlay(ped, 7, skin.sun_1, skin.sun_2 / 100 + 0.0)                  -- Sun Damage + Opacity
    SetPedEyeColor(ped, skin.eye_color)                                            -- Eyes Color
    SetPedHeadOverlay(ped, 4, skin.makeup_1, skin.makeup_2 / 100 + 0.0)            -- Makeup + Opacity
    SetPedHeadOverlayColor(ped, 4, 0, skin.makeup_3, skin.makeup_4)                -- Makeup Color
    SetPedHeadOverlay(ped, 5, skin.blush_1, skin.blush_2 / 100 + 0.0)              -- Blush + Opacity
    SetPedHeadOverlayColor(ped, 5, 2,	skin.blush_3)                                -- Blush Color
    SetPedHeadOverlay(ped, 8, skin.lipstick_1, skin.lipstick_2 / 100 + 0.0)        -- Lipstick + Opacity
    SetPedHeadOverlayColor(ped, 8, 2, skin.lipstick_3, skin.lipstick_4)            -- Lipstick Color
    SetPedHeadOverlay(ped, 10, skin.chest_1, skin.chest_2 / 100 + 0.0)             -- Chest Hair + Opacity
    SetPedHeadOverlayColor(ped, 10, 1, skin.chest_3, skin.chest_4)                 -- Chest Hair Color
end

function LoadCharacter(data,  setModel)
    for k, v in pairs(data) do
        currentChar[k] = v
    end

    local modelHash = nil
    if data.sex == 0 then
        modelHash = GetHashKey('mp_m_freemode_01')
    else
        modelHash = GetHashKey('mp_f_freemode_01')
    end
    LoadModel(modelHash, setModel)

    local playerPed = PlayerPedId()
    ApplySkinToPed(playerPed, data)
end

-- Map Locations
local closestCoords = nil
local closestType = ''
local distToClosest = 1000.0
local inMarkerRange = false

function DisplayTooltip(suffix)
    SetTextComponentFormat('STRING')
    AddTextComponentString('Press ~INPUT_PICKUP~ to ' .. suffix)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function UpdateClosestLocation(locations, type)
    local pedPosition = GetEntityCoords(PlayerPedId())
    for i = 1, #locations do
        local loc = locations[i]
        local distance = GetDistanceBetweenCoords(pedPosition.x, pedPosition.y, pedPosition.z, loc[1], loc[2], loc[3], false)
        if (distToClosest == nil or closestCoords == nil) or (distance < distToClosest) or (closestCoords == loc) then
            distToClosest = distance
            closestType = type
            closestCoords = vector3(loc[1], loc[2], loc[3])
        end

        if (distToClosest < 20.0) and (distToClosest > 1.0) then
            inMarkerRange = true
        else
            inMarkerRange = false
        end
    end
end

Citizen.CreateThread(function()
    while true do
        if Config.EnableBarberShops then
            UpdateClosestLocation(Config.BarberShops, 'barber')
        end
        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
    while true do
        if inMarkerRange then
            if not HasStreamedTextureDictLoaded("clothing") then
				RequestStreamedTextureDict("clothing", true)
				while not HasStreamedTextureDictLoaded("clothing") do
					Wait(1)
				end
			else
			    DrawMarker(9, closestCoords.x, closestCoords.y, closestCoords.z, 0.0, 0.0, 0.0, 90.0, 0.0, 0.0, 0.7, 0.7, 0.7, 250, 0, 0, 1.0,false, false, 2, true, "clothing", "nade", false)
            end 
        end
        if distToClosest < 1.0 and (not isVisible) then
            if closestType == 'barber' then
                DisplayTooltip('use barber shop.')
                if IsControlJustPressed(1, 38) then
                    TriggerEvent('FDMBarbers:open', {'features', 'style'}, false)
                end
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    for k, v in ipairs(Config.BarberShops) do
        local blip = AddBlipForCoord(v)
        SetBlipSprite(blip, 71)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Barber Shop')
        EndTextCommandSetBlipName(blip)
    end
end)