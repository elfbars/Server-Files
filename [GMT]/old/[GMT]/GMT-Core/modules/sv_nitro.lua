

RegisterServerEvent("CheckNitro")
AddEventHandler("CheckNitro", function()
    local source = source
    exports['GMT-Roles']:isRolePresent(source, {'984176149619966042'} --[[ can be a table or just a string. ]], function(hasRole, roles)
        if (not roles) then 
            TriggerClientEvent("NoGuild", source)
        end
        if hasRole == true then
            TriggerClientEvent("SpawningNitro", source)
        else
            TriggerClientEvent("NotBoosing", source)
        end
    end)
end)