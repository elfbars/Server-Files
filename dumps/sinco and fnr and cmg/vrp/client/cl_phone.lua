Citizen.CreateThread(function()
    local ticks = 500
	while (true) do
        if IsControlJustPressed(1, 166) then
            ticks = 1
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
                TriggerServerEvent('SincoRP:TrunkOpened', source)
            else
                notify("~r~You cannot do this from inside of the vehicle")
            end
        end
        Wait(ticks)
        ticks = 500
	end
end)

-- RegisterNetEvent("SincoRP:handsUpNearest")
-- AddEventHandler("SincoRP:handsUpNearest", function(nplayer, nuser_id)
--     nearestHandsUp = IsEntityPlayingAnim(GetPlayerPed(nplayer), "missminuteman_1ig_2", "handsup_enter", 3)
--     if nearestHandsUp then
--         TriggerServerEvent('SincoRP:searchNearestPlayer', nplayer, nuser_id)
--     end
-- end)
