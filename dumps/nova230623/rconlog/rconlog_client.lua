RegisterNetEvent('rlUpdateNames')

AddEventHandler('rlUpdateNames', function()
    local names = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
        end
    end

    TriggerServerEvent('rlUpdateNamesResult', names)
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)

		if NetworkIsSessionStarted() then
			TriggerServerEvent('rlPlayerActivated')

			return
		end
	end
end)