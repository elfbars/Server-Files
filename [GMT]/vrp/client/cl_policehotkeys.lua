-- Drag Hot Key
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		  if IsControlPressed(1, 19) and IsControlJustPressed(1,90) then -- LEFTALT + D
			  TriggerServerEvent('GMT:Drag')
		  end
	  end
  end)
  
  -- Cuff Hot Key
  RegisterCommand('+policeCuff', function(source)

	  TriggerServerEvent('GMT:policeCuff')
	  TriggerServerEvent('GMT:policeCuffStaff', OMioDioMode)
	  SendNUIMessage({
        transactionType = soundname,
    })
  end, false)
  
  RegisterKeyMapping('+policeCuff', 'Cuff', 'keyboard', 'f11')
  
  
  -- put out of car
  Citizen.CreateThread(function()
	  while true do
		  Citizen.Wait(0)
			if IsControlPressed(1, 19) and IsControlJustPressed(1,49) then -- alt + f
				TriggerServerEvent('GMT:PutPlrInVeh')
			end
		end
	end)
  
	-- put out of car
  Citizen.CreateThread(function()
	  while true do
		  Citizen.Wait(0)
		  if IsControlPressed(1, 19) and IsControlJustPressed(1,47) then -- alt + g
				TriggerServerEvent('GMT:TakeOutOfVehicle')
			end
		end
	end)