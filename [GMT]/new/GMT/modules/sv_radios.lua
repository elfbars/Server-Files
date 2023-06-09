local cfg = module("cfg/cfg_radios")

local function getRadioType(user_id)
    if GMT.hasPermission(user_id, "police.armoury") then
        return "Police"
    elseif GMT.hasPermission(user_id, "nhs.menu") then
        return "NHS"
    elseif GMT.hasPermission(user_id, "hmp.menu") then
        return "HMP"
    elseif GMT.hasPermission(user_id, "lfb.onduty.permission") then
        return "LFB"
    end
    return false
end

local radioChannels = {
    ['Police'] = {
        name = 'Police',
        players = {},
        channel = 1,
        callsign = true,
    },
    ['NHS'] = {
        name = 'NHS',
        players = {},
        channel = 2,
    },
    ['HMP'] = {
        name = 'HMP',
        players = {},
        channel = 3,
    },
    ['LFB'] = {
        name = 'LFB',
        players = {},
        channel = 4,
    },
}

function createRadio(source)
    local source = source
    local user_id = GMT.getUserId(source)
    local radioType = getRadioType(user_id)
    if radioType then
        Wait(1000)
        for k,v in pairs(cfg.sortOrder[radioType]) do
            if GMT.hasPermission(user_id, v) then
                local sortOrder = k
                local name = GetPlayerName(source)
                if radioChannels[radioType].callsign then
                    name = name.." ["..getCallsign(radioType, source, user_id, radioType).."]"
                end
                radioChannels[radioType]['players'][source] = {name = name, sortOrder = sortOrder}
                TriggerClientEvent('GMT:radiosCreateChannel', source, radioChannels[radioType].channel, radioChannels[radioType].name, radioChannels[radioType].players, true)
                TriggerClientEvent('GMT:radiosAddPlayer', -1, radioChannels[radioType].channel, source, {name = name, sortOrder = sortOrder})
            end
        end
    end
end

function removeRadio(source)
    for a,b in pairs(radioChannels) do
        if next(radioChannels[a]['players']) then
            for k,v in pairs(radioChannels[a]['players']) do
                if k == source then
                    TriggerClientEvent('GMT:radiosRemovePlayer', -1, radioChannels[a].channel, k)
                    radioChannels[a]['players'][source] = nil
                end
            end
        end
    end
end

RegisterServerEvent("GMT:clockedOnCreateRadio")
AddEventHandler("GMT:clockedOnCreateRadio", function(source)
    local source = source
    createRadio(source)
end)

RegisterServerEvent("GMT:clockedOffRemoveRadio")
AddEventHandler("GMT:clockedOffRemoveRadio", function(source)
    local source = source
    removeRadio(source)
end)

AddEventHandler("GMT:playerSpawn", function(user_id, source, first_spawn)
    local source = source
    createRadio(source)
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    removeRadio(source)
end)

RegisterServerEvent("GMT:radiosSetIsMuted")
AddEventHandler("GMT:radiosSetIsMuted", function(mutedState)
    local source = source
    local user_id = GMT.getUserId(source)
    local radioType = getRadioType(user_id)
    if radioType then
        for k,v in pairs(radioChannels[radioType]['players']) do
            if k == source then
                TriggerClientEvent('GMT:radiosSetPlayerIsMuted', -1, radioChannels[radioType].channel, k, mutedState)
            end
        end
    end
end)