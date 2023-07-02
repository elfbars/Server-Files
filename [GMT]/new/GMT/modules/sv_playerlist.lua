local staffGroups = {
    ['Founder'] = true,
    ['Lead Developer'] = true,
    ['Developer'] = true,
    ['Staff Manager'] = true,
    ['Community Manager'] = true,
    ['Head Administrator'] = true,
    ['Senior Administrator'] = true,
    ['Administrator'] = true,
    ['Senior Moderator'] = true,
    ['Moderator'] = true,
    ['Support Team'] = true,
    ['Trial Staff'] = true,
}
local pdGroups = {
    ["Commissioner Clocked"]=true,
    ["Deputy Commissioner Clocked"] =true,
    ["Assistant Commissioner Clocked"]=true,
    ["Dep. Asst. Commissioner Clocked"] =true,
    ["Commander Clocked"]=true,
    ["Chief Superintendent Clocked"]=true,
    ["Superintendent Clocked"]=true,
    ["Chief Inspector Clocked"]=true,
    ["Inspector Clocked"]=true,
    ["Sergeant Clocked"]=true,
    ["Senior Constable Clocked"]=true,
    ["PC Clocked"]=true,
    ["PCSO Clocked"]=true,
    ["Special Constable Clocked"]=true,
    ["NPAS Clocked"]=true,
}
local nhsGroups = {
    ["NHS Trainee Paramedic Clocked"] = true,
    ["NHS Paramedic Clocked"] = true,
    ["NHS Critical Care Clocked"] = true,
    ["NHS Junior Doctor Clocked"] = true,
    ["NHS Doctor Clocked"] = true,
    ["NHS Senior Doctor Clocked"] = true,
    ["NHS Specialist Clocked"] = true,
    ["NHS Consultant Clocked"] = true,
    ["NHS Captain Clocked"] = true,
    ["NHS Deputy Chief Clocked"] = true,
    ["NHS Assistant Chief Clocked"] = true,
    ["NHS Head Chief Clocked"] = true,
    ["HEMS Clocked"]=true,
}
local lfbGroups = {
    ["Provisional Firefighter Clocked"] = true,
    ["Junior Firefighter Clocked"] = true,
    ["Firefighter Clocked"] = true,
    ["Senior Firefighter Clocked"] = true,
    ["Advanced Firefighter Clocked"] = true,
    ["Specalist Firefighter Clocked"] = true,
    ["Leading Firefighter Clocked"] = true,
    ["Sector Command Clocked"] = true,
    ["Divisional Command Clocked"] = true,
    ["Chief Fire Command Clocked"] = true
}
local hmpGroups = {
    ["Governor Clocked"] = true,
    ["Deputy Governor Clocked"] = true,
    ["Divisional Commander Clocked"] = true,
    ["Custodial Supervisor Clocked"] = true,
    ["Custodial Officer Clocked"] = true,
    ["Honourable Guard Clocked"] = true,
    ["Supervising Officer Clocked"] = true,
    ["Principal Officer Clocked"] = true,
    ["Specialist Officer Clocked"] = true,
    ["Senior Officer Clocked"] = true,
    ["Prison Officer Clocked"] = true,
    ["Trainee Prison Officer Clocked"] = true
}
local aaGroups = {
    ["AA Mechanic"] = true,
}
local defaultGroups = {
    ["Royal Mail Driver"] = true,
    ["Bus Driver"] = true,
    ["Deliveroo"] = true,
    ["Scuba Diver"] = true,
    ["G4S Driver"] = true,
    ["Taco Seller"] = true,
    ["Burger Shot Cook"] = true,
}
local tridentGroups = {
    ["Trident Officer Clocked"] = true,
    ["Trident Command Clocked"] = true,
}
function getGroupInGroups(id, type)
    if type == 'Staff' then
        for k,v in pairs(GMT.getUserGroups(id)) do
            if staffGroups[k] then 
                return k
            end 
        end
    elseif type == 'Police' then
        for k,v in pairs(GMT.getUserGroups(id)) do
            if pdGroups[k] or tridentGroups[k] then 
                return k
            end 
        end
    elseif type == 'NHS' then
        for k,v in pairs(GMT.getUserGroups(id)) do
            if nhsGroups[k] then 
                return k
            end 
        end
    elseif type == 'LFB' then
        for k,v in pairs(GMT.getUserGroups(id)) do
            if lfbGroups[k] then 
                return k
            end 
        end
    elseif type == 'HMP' then
        for k,v in pairs(GMT.getUserGroups(id)) do
            if hmpGroups[k] then 
                return k
            end 
        end
    elseif type == 'AA' then
        for k,v in pairs(GMT.getUserGroups(id)) do
            if aaGroups[k] then 
                return k
            end 
        end
    elseif type == 'Default' then
        for k,v in pairs(GMT.getUserGroups(id)) do
            if defaultGroups[k] then 
                return k
            end 
        end
        return "Unemployed"
    end
end

local hiddenUsers = {}
RegisterNetEvent("GMT:setUserHidden")
AddEventHandler("GMT:setUserHidden",function(state)
    local source=source
    local user_id=GMT.getUserId(source)
    if tGMT.getStaffLevel >= 8 then
        if state then
            hiddenUsers[user_id] = true
        else
            hiddenUsers[user_id] = nil
        end
    end
end)

local uptime = 0
local function playerListMetaUpdates()
    local uptimemessage = ''
    if uptime < 60 then
        uptimemessage = math.floor(uptime) .. ' seconds'
    elseif uptime >= 60 and uptime < 3600 then
        uptimemessage = math.floor(uptime/60) .. ' minutes and ' .. math.floor(uptime%60) .. ' seconds'
    elseif uptime >= 3600 then
        uptimemessage = math.floor(uptime/3600) .. ' hours and ' .. math.floor((uptime%3600)/60) .. ' minutes and ' .. math.floor(uptime%60) .. ' seconds'
    end
    return {uptimemessage, #GetPlayers(), GetConvarInt("sv_maxclients",64)}
end

Citizen.CreateThread(function()
    while true do
        local time = os.date("*t")
        uptime = uptime + 1
        TriggerClientEvent('GMT:playerListMetaUpdate', -1, playerListMetaUpdates())
        TriggerClientEvent('GMT:setHiddenUsers', -1, hiddenUsers)
        if os.date('%A') == 'Sunday' and tonumber(time["hour"]) == 23 and tonumber(time["min"]) == 0 and tonumber(time["sec"]) == 0 then
            exports['ghmattimysql']:execute("UPDATE gmt_police_hours SET weekly_hours = 0")
            exports['ghmattimysql']:execute("UPDATE gmt_staff_tickets SET ticket_count = 0")
        end
        Citizen.Wait(1000)
    end
end)

RegisterNetEvent('GMT:getPlayerListData')
AddEventHandler('GMT:getPlayerListData', function()
    local source = source
    local user_id = GMT.getUserId(source)
    local staff = {}
    local police = {}
    local nhs = {}
    local lfb = {}
    local hmp = {}
    local aa = {}
    local civillians = {}
    for k,v in pairs(GMT.getUsers()) do
        if not hiddenUsers[k] then
            local name = GetPlayerName(v)
            if name ~= nil then
                local minutesPlayed = GMT.getUserDataTable(k).PlayerTime or 0
                local hours = math.floor(minutesPlayed/60)
                if GMT.hasPermission(k, 'admin.tickets') then
                    staff[k] = {name = name, rank = getGroupInGroups(k, 'Staff'), hours = hours}
                end
                if GMT.hasPermission(k, 'police.armoury') and not GMT.hasPermission(k, 'police.undercover') then
                    police[k] = {name = name, rank = string.gsub(getGroupInGroups(k, 'Police'), ' Clocked', ''), hours = hours}
                elseif GMT.hasPermission(k, 'nhs.menu') then
                    nhs[k] = {name = name, rank = string.gsub(getGroupInGroups(k, 'NHS'), ' Clocked', ''), hours = hours}
                elseif GMT.hasPermission(k, 'lfb.onduty.permission') then
                    lfb[k] = {name = name, rank = string.gsub(getGroupInGroups(k, 'LFB'), ' Clocked', ''), hours = hours}
                elseif GMT.hasPermission(k, 'hmp.menu') then
                    hmp[k] = {name = name, rank = string.gsub(getGroupInGroups(k, 'HMP'), ' Clocked', ''), hours = hours}
                elseif GMT.hasPermission(k, 'aa.menu') then
                    aa[k] = {name = name, rank = string.gsub(getGroupInGroups(k, 'AA'), ' Clocked', ''), hours = hours}
                end
                if (not GMT.hasPermission(k, "police.armoury") or GMT.hasPermission(k, 'police.undercover')) and not GMT.hasPermission(k, "nhs.menu") and not GMT.hasPermission(k, "lfb.onduty.permission") and not GMT.hasPermission(k, "hmp.menu") and not GMT.hasPermission(k, "aa.menu")then
                    civillians[k] = {name = name, rank = getGroupInGroups(k, 'Default'), hours = hours}
                end
            end
        end
    end
    TriggerClientEvent('GMT:gotFullPlayerListData', source, staff, police, nhs, lfb, hmp, aa, civillians)
    TriggerClientEvent('GMT:gotJobTypes', source, nhsGroups, pdGroups, lfbGroups, hmpGroups, aaGroups, tridentGroups)
end)



-- Pay checks

local paycheckscfg = module('cfg/cfg_factiongroups')

local function paycheck(tempid, permid, money)
    local pay = grindBoost*money
    GMT.giveBankMoney(permid, pay)
    GMTclient.notifyPicture(tempid, {'CHAR_BANK_MAZE', 'CHAR_BANK_MAZE', 'Payday: ~g~£'..getMoneyStringFormatted(tostring(pay)), "", 'PAYE', '', 1})
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000*60*30)
        for k,v in pairs(GMT.getUsers()) do
            if GMT.hasPermission(k, "police.armoury") then
                for a,b in pairs(paycheckscfg.metPoliceRanks) do
                    if b[1] == string.gsub(getGroupInGroups(k, 'Police'), ' Clocked', '') then
                        paycheck(v, k, b[2])
                    end
                end
            elseif GMT.hasPermission(k, "nhs.menu") then
                for a,b in pairs(paycheckscfg.nhsRanks) do
                    if b[1] == string.gsub(getGroupInGroups(k, 'NHS'), ' Clocked', '') then
                        paycheck(v, k, b[2])
                    end
                end
            elseif GMT.hasPermission(k, "lfb.onduty.permission") then
                for a,b in pairs(paycheckscfg.lfbRanks) do
                    if b[1] == string.gsub(getGroupInGroups(k, 'LFB'), ' Clocked', '') then
                        paycheck(v, k, b[2])
                    end
                end
            elseif GMT.hasPermission(k, "hmp.menu") then
                for a,b in pairs(paycheckscfg.hmpRanks) do
                    if b[1] == string.gsub(getGroupInGroups(k, 'HMP'), ' Clocked', '') then
                        paycheck(v, k, b[2])
                    end
                end
            end
        end
    end
end)