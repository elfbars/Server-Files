-- local rewardjew = math.random(1,3)
-- local minCops = 3
-- local players = GetPlayers()

-- RegisterServerEvent("jewelryrobberry:serverstart")
-- AddEventHandler("jewelryrobberry:serverstart", function()
--     local user_id = AQUA.getUserId({source})
--     local player = AQUA.getUserSource({user_id})
--     local cops = AQUA.getUsersByPermission({"police.armoury"})
--     if AQUA.hasPermission({user_id,"police.armoury"}) then
--         AQUAclient.notify(player,{"~d~Cops can't rob the jewellery store."})
--     else
--         if #cops >= minCops then
--             TriggerClientEvent("jewelryrobberry:start", source)
--         else
--             AQUAclient.notify(player,{'~d~Minimum of '..minCops..' cops online.'})
--         end
--     end
-- end)

-- RegisterServerEvent('jewelryrobberry:sucess')
-- AddEventHandler('jewelryrobberry:sucess', function()
--     local user_id = AQUA.getUserId({source})
--     if user_id ~= nil then
--         AQUA.giveInventoryItem({user_id,"jewellery",rewardjew,true})
--     end
-- end)

-- RegisterServerEvent('jewelryrobberry:sucessRW1')
-- AddEventHandler('jewelryrobberry:sucessRW1', function()
--     local user_id = AQUA.getUserId({source})
--     if user_id ~= nil then
--         AQUA.giveInventoryItem({user_id,"jewellery",1,true})
--     end
-- end)

-- RegisterServerEvent('jewelryrobberry:allarmpolice')
-- AddEventHandler('jewelryrobberry:allarmpolice', function()
--     for i,v in pairs(players) do
--         local user_id = AQUA.getUserId({v})
--         local source = AQUA.getUserSource({user_id})
--         if user_id ~= nil then
--           if AQUA.hasPermission({user_id, "police.armoury"}) then
--             TriggerClientEvent("AQUA:setJewelleryBlip", source)
--           end
--         end
--     end
-- end)
