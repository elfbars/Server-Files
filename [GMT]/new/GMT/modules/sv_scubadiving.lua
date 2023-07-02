local a = module("cfg/cfg_scubadiving")
local currentDivers = {}
local scubaLocations = {
    'Heroin Tunnel',
    'Plane Crash',
    'Boat Crash',
}

RegisterNetEvent("GMT:requestScubaJob")
AddEventHandler("GMT:requestScubaJob", function()
    local source=source
    local user_id=GMT.getUserId(source)
    if GMT.hasGroup(user_id,"Scuba Diver")then
        if currentDivers[user_id]==nil then
            currentDivers[user_id]={currentJob=""}
            currentDivers[user_id].currentJob={jobActive = true}
            local randomJob = math.random(1,#scubaLocations)
            for k,v in pairs(a.locations)do
                if v.name==scubaLocations[randomJob] then
                    local jobInfo={
                        name=v.name,
                        position=v.position,
                        dinghySpawnPositions=v.dinghySpawnPositions,
                        dinghySpawnHeading=v.dinghySpawnHeading,
                        blipId=v.blipId,
                        blipColour=v.blipColour,
                        rewardObjects=v.rewardObjects,
                    }
                    TriggerClientEvent("GMT:createScubaJob",source,jobInfo,GMT.getUserId(source))
                end
            end
        end
    else
        GMTclient.notify(source,{"~r~You are not clocked on as a Scuba Diver."})
    end
end)

RegisterNetEvent("GMT:scubaSetVehicle")
AddEventHandler("GMT:scubaSetVehicle", function(PermID,Vehicle)
    local source = source
    local user_id = GMT.getUserId(source)
    if PermID == user_id then
        if currentDivers[PermID]~=nil and currentDivers[PermID].currentJob.jobActive==true then
            currentDivers[PermID].currentJob.dinghy=Vehicle
        end
    end
end)

RegisterNetEvent("GMT:finishScubaJob")
AddEventHandler("GMT:finishScubaJob", function(PermID,CollectedPackages)
    local source = source
    local user_id = GMT.getUserId(source)
    if PermID == user_id then
        if currentDivers[PermID]~=nil and currentDivers[PermID].currentJob.jobActive==true then
            currentDivers[PermID].currentJob.jobActive=false
            currentDivers[PermID].currentJob.collectedPackages=CollectedPackages
        end
    end
end)

RegisterNetEvent("GMT:claimScubaReward")
AddEventHandler("GMT:claimScubaReward", function(PermID)
    local source = source
    local user_id = GMT.getUserId(source)
    if PermID == user_id then
        if currentDivers[PermID]~=nil and currentDivers[PermID].currentJob.jobActive==false then
            local reward = grindBoost*math.random(a.payPerItemMin*currentDivers[PermID].currentJob.collectedPackages,a.payPerItemMax*currentDivers[PermID].currentJob.collectedPackages)
            GMT.giveBankMoney(PermID,reward)
            GMTclient.notify(source, {"~g~You have been paid £"..getMoneyStringFormatted(reward).." for collecting "..currentDivers[PermID].currentJob.collectedPackages.." treasures."})
            currentDivers[PermID]=nil
        end
    end
end)