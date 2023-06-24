RMenu.Add('AAMenu', 'main', RageUI.CreateMenu("","~y~AA ~w~Menu",1300,100, "banners", "autoshop"))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('AAMenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Button("Fix Vehicle" , nil, { RightLabel = '→→→'}, true, function(Hovered, Active, Selected) 
                if Selected then 
                    TomFix()
                end
            end)
            RageUI.Button("Clean Vehicle", nil, { RightLabel = '→→→'}, true, function(Hovered, Active, Selected)
                if Selected then
                    TomClean()
                end
            end)
            RageUI.Button("Tow/Untow Vehicle", nil, { RightLabel = '→→→'}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent("tow")
                end
            end)
        end)
    end
end)

RegisterCommand('aamenu', function()
    TriggerServerEvent('NOVA:openAAMenu')
end)

function tvRP.openAAMenu()
    RageUI.Visible(RMenu:Get('AAMenu', 'main'), not RageUI.Visible(RMenu:Get('AAMenu', 'main')))
end

function TomFix(veh)
    local TomPed = GetPlayerPed(-1)
    if IsPedInAnyVehicle(TomPed) then
        local Tom = GetVehiclePedIsIn(TomPed)
        SetVehicleEngineHealth(Tom, 9999)
        SetVehiclePetrolTankHealth(Tom, 9999)
        SetVehicleFixed(Tom)
        Notify('~y~[AA] ~w~Vehicle has been fixed.')
    else
        Notify('~r~You are not in a vehicle!')
    end
end

function TomClean()
    local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleDirtLevel(vehicle, 0)
		Notify("~y~[AA] ~w~Vehicle has been cleaned.")
	else
		Notify("~r~You are not in a vehicle!")
	end
end

function Notify( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end

local allowedTowModels = { 
    ['flatbed'] = {x = 0.0, y = -0.85, z = 0.85} -- YOU MAY CHANGE THIS TO WHATEVER CAR MODEL YOU LIKE JUST MAKE SURE IT IS REALISTIC AND CAN ACTUALLY HOLD A CAR ON THE BACK OF IT.
}


local allowTowingBoats = false
local allowTowingPlanes = false
local allowTowingHelicopters = false
local allowTowingTrains = false
local allowTowingTrailers = true

local currentlyTowedVehicle = nil

function isTargetVehicleATrailer(modelHash)
    if GetVehicleClassFromName(modelHash) == 11 then
        return true
    else
        return false
    end
end

local xoff = 0.0
local yoff = 0.0
local zoff = 0.0

function isVehicleATowTruck(vehicle)
    local isValid = false
    for model,posOffset in pairs(allowedTowModels) do
        if IsVehicleModel(vehicle, model) then
            xoff = posOffset.x
            yoff = posOffset.y
            zoff = posOffset.z
            isValid = true
            break
        end
    end
    return isValid
end

RegisterNetEvent('tow')
AddEventHandler('tow', function()
	
	local playerped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerped, true)
	
	local isVehicleTow = isVehicleATowTruck(vehicle)

	if isVehicleTow then

		local coordA = GetEntityCoords(playerped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB)
        

		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)
				isVehicleTow = isVehicleATowTruck(vehicle)
				local roll = GetEntityRoll(GetVehiclePedIsIn(PlayerPedId(), true))
				if IsEntityUpsidedown(GetVehiclePedIsIn(PlayerPedId(), true)) and isVehicleTow or roll > 70.0 or roll < -70.0 then
					DetachEntity(currentlyTowedVehicle, false, false)
					currentlyTowedVehicle = nil
				end
                
			end
		end)

		if currentlyTowedVehicle == nil then
			if targetVehicle ~= 0 then
                local targetVehicleLocation = GetEntityCoords(targetVehicle, true)
                local towTruckVehicleLocation = GetEntityCoords(vehicle, true)
                local distanceBetweenVehicles = GetDistanceBetweenCoords(targetVehicleLocation, towTruckVehicleLocation, false)		
                if distanceBetweenVehicles > 15.0 then
                    Notify("~y~[AA] ~w~Move your tow truck closer to the vehicle.")
                else
                    local targetModelHash = GetEntityModel(targetVehicle)
                    if not ((not allowTowingBoats and IsThisModelABoat(targetModelHash)) or (not allowTowingHelicopters and IsThisModelAHeli(targetModelHash)) or (not allowTowingPlanes and IsThisModelAPlane(targetModelHash)) or (not allowTowingTrains and IsThisModelATrain(targetModelHash)) or (not allowTowingTrailers and isTargetVehicleATrailer(targetModelHash))) then 
                        if not IsPedInAnyVehicle(playerped, true) then
                            if vehicle ~= targetVehicle and IsVehicleStopped(vehicle) then
                                AttachEntityToEntity(targetVehicle, vehicle, GetEntityBoneIndexByName(vehicle, 'bodyshell'), 0.0 + xoff, -1.5 + yoff, 0.0 + zoff, 0, 0, 0, 1, 1, 0, 1, 0, 1)
                                currentlyTowedVehicle = targetVehicle
                                Notify("~y~[AA] ~w~Vehicle has been loaded onto the Tow Truck.")
                            else
                                Notify("~y~[AA] ~w~There is currently no vehicle on the Tow Truck.")
                            end
                        else
                            Notify("~y~[AA] ~w~You need to be outside of your vehicle to load or unload vehicles.")
                        end
                    else
                        Notify("~y~[AA] ~w~Your tow truck is not equipped to tow this vehicle.")
                    end
                end
            else
                Notify("~y~[AA] ~w~No towable vehicle detected.")
			end
		elseif IsVehicleStopped(vehicle) then
            DetachEntity(currentlyTowedVehicle, false, false)
            local vehiclesCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -12.0, 0.0)
			SetEntityCoords(currentlyTowedVehicle, vehiclesCoords["x"], vehiclesCoords["y"], vehiclesCoords["z"], 1, 0, 0, 1)
			SetVehicleOnGroundProperly(currentlyTowedVehicle)
			currentlyTowedVehicle = nil
			Notify("~y~[AA] ~w~Vehicle has been unloaded from the Tow Truck.")
		end
	else
        Notify("~y~[AA] ~w~Your vehicle is not registered as an official tow truck.")
    end
end)

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end