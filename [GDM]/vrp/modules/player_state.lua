local cfg = module("cfg/player_state")
local lang = vRP.lang

-- client -> server events
AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    Debug.pbegin("playerSpawned_player_state")
    local player = source
    local data = vRP.getUserDataTable(user_id)
    local tmpdata = vRP.getUserTmpTable(user_id)

    if first_spawn then -- first spawn
        -- cascade load customization then weapons
        if data.customization == nil then
            data.customization = cfg.default_customization
        end

        if data.position == nil and cfg.spawn_enabled then
            local x = cfg.spawn_position[1] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local y = cfg.spawn_position[2] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local z = cfg.spawn_position[3] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            data.position = {
                x = x,
                y = y,
                z = z
            }
        end

        if data.position ~= nil then -- teleport to saved pos
            vRPclient.teleport(source, {data.position.x, data.position.y, data.position.z})
        end

        if data.customization ~= nil then
            vRPclient.setCustomization(source, {data.customization},
                function() -- delayed weapons/health, because model respawn
                    if data.weapons ~= nil then -- load saved weapons
                        vRPclient.giveWeapons(source, {data.weapons, true})

                        if data.health ~= nil then -- set health
                            vRPclient.setHealth(source, {data.health})
                            SetTimeout(5000, function() -- check coma, kill if in coma
                                vRPclient.isInComa(player, {}, function(in_coma)
                                    vRPclient.killComa(player, {})
                                end)
                            end)
                        end
                        
                        if data.armour ~= nil then
                            vRPclient.setArmour(source, {data.armour})
                        end
                    end
                end)
        else
            if data.weapons ~= nil then -- load saved weapons
                vRPclient.giveWeapons(source, {data.weapons, true})
            end
            if data.armour ~= nil then
                vRPclient.setArmour(source, {data.armour})
            end
            if data.health ~= nil then
                vRPclient.setHealth(source, {data.health})
            end
        end

        -- notify last login
    else -- not first spawn (player died), don't load weapons, empty wallet, empty inventory

        if cfg.clear_phone_directory_on_death then
            data.phone_directory = {} -- clear phone directory after death
        end

        if cfg.lose_aptitudes_on_death then
            data.gaptitudes = {} -- clear aptitudes after death
        end

        if vRPConfig.LoseItemsOnDeath then 
            vRP.clearInventory(user_id) 
        end
        
        vRP.setMoney(user_id, 0)

        -- disable handcuff
        vRPclient.setHandcuffed(player, {false})

        if cfg.spawn_enabled then -- respawn (CREATED SPAWN_DEATH)
            local x = cfg.spawn_death[1] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local y = cfg.spawn_death[2] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local z = cfg.spawn_death[3] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            data.position = {
                x = x,
                y = y,
                z = z
            }
            vRPclient.teleport(source, {x, y, z})
        end

        -- load character customization
        if data.customization ~= nil then
            vRPclient.setCustomization(source, {data.customization})
        end
    end
    Debug.pend()
end)

-- updates


function tvRP.updatePos(x, y, z)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local data = vRP.getUserDataTable(user_id)
        local tmp = vRP.getUserTmpTable(user_id)
        if data ~= nil and (tmp == nil or tmp.home_stype == nil) then -- don't save position if inside home slot
            data.position = {
                x = tonumber(x),
                y = tonumber(y),
                z = tonumber(z)
            }
        end
    end
end

function tvRP.updateWeapons(weapons)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local data = vRP.getUserDataTable(user_id)
        if data ~= nil then
            data.weapons = weapons
        end
    end
end

function tvRP.updateCustomization(customization)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local data = vRP.getUserDataTable(user_id)
        if data ~= nil then
            data.customization = customization
        end
    end
end

function tvRP.updateHealth(health)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local data = vRP.getUserDataTable(user_id)
        if data ~= nil then
            data.health = health
        end
    end
end

function tvRP.updateArmour(armour)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local data = vRP.getUserDataTable(user_id)
        if data ~= nil then
            data.armour = armour
        end
    end
end

function tvRP.UpdatePlayTime()
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local data = vRP.getUserDataTable(user_id)
        if data ~= nil then
            if data.PlayerTime ~= nil then
                data.PlayerTime = tonumber(data.PlayerTime) + 1
            else
                data.PlayerTime = 1
            end
        end
    end
end

function tvRP.saveLoadout(weapontable, loadoutname)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        loadout = json.encode(weapontable)
        exports['ghmattimysql']:execute("INSERT INTO vrp_user_loadouts (`user_id`, `loadout_name`, `loadout`) VALUES (@user_id, @loadout_name, @loadout);", {user_id = user_id, loadout_name = loadoutname, loadout = loadout}, function() end) 
        TriggerEvent('Loadout:getLoadouts')
    end
end

RegisterNetEvent("Loadout:selectLoadout")
AddEventHandler("Loadout:selectLoadout", function(loadoutname)
    local source = source
    local user_id = vRP.getUserId(source)
    if GetPlayerRoutingBucket(source) ~= 0 then
        vRPclient.notify(source,{'~r~You cannot retrieve a loadout in this mode.'})
    else
        if loadoutname == 'staffloadout' then
            if vRP.hasPermission(user_id, "admin.tickets") then
                loadout = json.decode('{"WEAPON_REMINGTON700":{"ammo":250},"WEAPON_GURA":{"ammo":250}}')
                vRPclient.giveLoadout(source, {loadout, true})
                vRPclient.notify(source,{'~g~You have received your loadout.'})
            end
        else
            exports['ghmattimysql']:execute("SELECT loadout FROM `vrp_user_loadouts` WHERE loadout_name = @loadout_name", {loadout_name = loadoutname}, function(result)
                if result ~= nil then 
                    for k, v in pairs(result) do
                        loadout = json.decode(v.loadout)
                        vRPclient.giveLoadout(source, {loadout, true})
                        vRPclient.notify(source,{'~g~You have received your loadout.'})
                    end
                end
            end)
        end
    end
end)

RegisterNetEvent("Loadout:deleteLoadout")
AddEventHandler("Loadout:deleteLoadout", function(loadoutname)
    local source = source
    local user_id = vRP.getUserId(source)
    exports['ghmattimysql']:execute("DELETE FROM `vrp_user_loadouts` WHERE loadout_name = @loadout_name", {loadout_name = loadoutname}, function() end)
    vRPclient.notify(source,{'~g~Successfully deleted '..loadoutname..' from your loadouts.'})
    TriggerEvent('Loadout:getLoadouts')
end)

RegisterNetEvent("Loadout:getLoadouts")
AddEventHandler("Loadout:getLoadouts", function()
    local staff = false
    local source = source
    local user_id = vRP.getUserId(source)
    local loadouts = {}
    exports['ghmattimysql']:execute("SELECT * FROM `vrp_user_loadouts` WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k, v in pairs(result) do
                table.insert(loadouts, v.loadout_name)
            end
            if vRP.hasPermission(user_id, "admin.tickets") then
                staff = false
                --staff = true
            end
            TriggerClientEvent('Loadout:sendLoadouts', source, loadouts, staff)
        end
    end)
end)


Citizen.CreateThread(function()
    Wait(2500)
    exports['ghmattimysql']:execute([[
        CREATE TABLE IF NOT EXISTS `vrp_user_loadouts` (
            `loadout_id` int(11) NOT NULL AUTO_INCREMENT,
            `user_id` int(11) NOT NULL,
            `loadout_name` VARCHAR(100) NOT NULL,
            `loadout` TEXT,
            PRIMARY KEY (`loadout_id`)
            );]])
    print("[GDM] - Loadouts initialised.")
end)



local isStoring = {}
function tvRP.StoreWeaponsDead()
    local player = source 
    local user_id = vRP.getUserId(player)
	vRPclient.getWeapons(player,{},function(weapons)
        if not isStoring[player] then
            isStoring[player] = true
            vRPclient.giveWeapons(player, {{}, true}, function(removedwep)
                for k,v in pairs(weapons) do
                    vRP.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                    if v.ammo > 0 then
                        vRP.giveInventoryItem(user_id, "wammo|"..k, v.ammo, true)
                    end
                end
                vRPclient.notify(player,{"~g~Weapons Stored"})
                SetTimeout(10000,function()
                    isStoring[player] = nil 
                end)
            end)
        else
            vRPclient.notify(player,{"~o~Your weapons are already being stored hmm..."})
        end
	end)
end



function tvRP.oldskinback()
    local user_id = vRP.getUserId(source)
    local data = vRP.getUserDataTable(user_id)

    vRPclient.setCustomization(source, {data.customization})
end