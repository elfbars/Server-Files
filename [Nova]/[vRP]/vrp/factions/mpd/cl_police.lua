-- this module define some police tools and functions

local handcuffed = false
local mpd = false
local mpd_permission = false
local mpd_suspended = false

-- set player as MPD (true or false)
function tvRP.setCop(flag)
	mpd = flag
	SetPedAsCop(PlayerPedId(), flag)
  TriggerEvent('Nova:Factions:Client:Clocked')
end

function tvRP.IsMPD()
  return mpd
end

function tvRP.Set_MPD_Permission(flag)
	mpd_permission = flag
end

function tvRP.Has_MPD_Permission(flag)
	return mpd_permission
end

function tvRP.Set_MPD_Suspended(flag)
  mpd_suspended = flag
end

function tvRP.Is_MPD_Suspended()
  return mpd_suspended
end

-- HANDCUFF

function tvRP.toggleHandcuff()
  handcuffed = not handcuffed

  local ped = PlayerPedId()
  SetEnableHandcuffs(ped, handcuffed)
  if handcuffed then
    tvRP.playAnim(true, {{"mp_arresting", "idle", 1}}, true)
  else
    tvRP.stopAnim(true)
    SetPedStealthMovement(ped, false, "")
  end
end

function tvRP.setHandcuffed(flag)
  if handcuffed ~= flag then
    tvRP.toggleHandcuff()
  end
end

function tvRP.isHandcuffed()
  return handcuffed
end

-- (experimental, based on experimental getNearestVehicle)
function tvRP.putInNearestVehicleAsPassenger(radius)
  local veh = tvRP.getNearestVehicle(radius)

  if IsEntityAVehicle(veh) then
    for i = 1, math.max(GetVehicleMaxNumberOfPassengers(veh), 3) do
      if IsVehicleSeatFree(veh, i) then
        SetPedIntoVehicle(PlayerPedId(), veh, i)
        return true
      end
    end
  end

  return false
end

function tvRP.putInNetVehicleAsPassenger(net_veh)
  local veh = NetworkGetEntityFromNetworkId(net_veh)
  if IsEntityAVehicle(veh) then
    for i = 1, GetVehicleMaxNumberOfPassengers(veh) do
      if IsVehicleSeatFree(veh, i) then
        SetPedIntoVehicle(PlayerPedId(), veh, i)
        return true
      end
    end
  end
end

function tvRP.putInVehiclePositionAsPassenger(x, y, z)
  local veh = tvRP.getVehicleAtPosition(x, y, z)
  if IsEntityAVehicle(veh) then
    for i = 1, GetVehicleMaxNumberOfPassengers(veh) do
      if IsVehicleSeatFree(veh, i) then
        SetPedIntoVehicle(PlayerPedId(), veh, i)
        return true
      end
    end
  end
end

-- keep handcuffed animation
Citizen.CreateThread(
  function()
    while true do
      Citizen.Wait(15000)
      if handcuffed then
        tvRP.playAnim(true, {{"mp_arresting", "idle", 1}}, true)
      end
    end
  end
)

-- force stealth movement while handcuffed (prevent use of fist and slow the player)
Citizen.CreateThread(
  function()
    while true do
      Citizen.Wait(0)
      if handcuffed then
        SetPedStealthMovement(PlayerPedId(), true, "")
        DisableControlAction(0, 21, true) -- disable sprint
        DisableControlAction(0, 24, true) -- disable attack
        DisableControlAction(0, 25, true) -- disable aim
        DisableControlAction(0, 47, true) -- disable weapon
        DisableControlAction(0, 58, true) -- disable weapon
        DisableControlAction(0, 263, true) -- disable melee
        DisableControlAction(0, 264, true) -- disable melee
        DisableControlAction(0, 257, true) -- disable melee
        DisableControlAction(0, 140, true) -- disable melee
        DisableControlAction(0, 141, true) -- disable melee
        DisableControlAction(0, 142, true) -- disable melee
        DisableControlAction(0, 143, true) -- disable melee
        DisableControlAction(0, 75, true) -- disable exit vehicle
        DisableControlAction(27, 75, true) -- disable exit vehicle
      end
    end
  end
)

-- JAIL

local jail = nil

-- jail the player in a no-top no-bottom cylinder
function tvRP.jail(x, y, z, radius)
  tvRP.teleport(x, y, z) -- teleport to center
  jail = {x + 0.0001, y + 0.0001, z + 0.0001, radius + 0.0001}
end

-- unjail the player
function tvRP.unjail()
  jail = nil
end

function tvRP.isJailed()
  return jail ~= nil
end

Citizen.CreateThread(
  function()
    while true do
      Citizen.Wait(5)
      if jail then
        local x, y, z = tvRP.getPosition()

        local dx = x - jail[1]
        local dy = y - jail[2]
        local dist = math.sqrt(dx * dx + dy * dy)

        if dist >= jail[4] then
          local ped = PlayerPedId()
          SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001) -- stop player

          -- normalize + push to the edge + add origin
          dx = dx / dist * jail[4] + jail[1]
          dy = dy / dist * jail[4] + jail[2]

          -- teleport player at the edge
          SetEntityCoordsNoOffset(ped, dx, dy, z, true, true, true)
        end
      end
    end
  end
)

-- WANTED

-- wanted level sync
local wanted_level = 0

function tvRP.applyWantedLevel(new_wanted)
  Citizen.CreateThread(
    function()
      local old_wanted = GetPlayerWantedLevel(PlayerId())
      local wanted = math.max(old_wanted, new_wanted)
      ClearPlayerWantedLevel(PlayerId())
      SetPlayerWantedLevelNow(PlayerId(), false)
      Citizen.Wait(10)
      SetPlayerWantedLevel(PlayerId(), wanted, false)
      SetPlayerWantedLevelNow(PlayerId(), false)
    end
  )
end

-- update wanted level
Citizen.CreateThread(
  function()
    while true do
      Citizen.Wait(2000)

      -- if cop, reset wanted level
      if mpd then
        ClearPlayerWantedLevel(PlayerId())
        SetPlayerWantedLevelNow(PlayerId(), false)
      end

      -- update level
      local nwanted_level = GetPlayerWantedLevel(PlayerId())
      if nwanted_level ~= wanted_level then
        wanted_level = nwanted_level
        vRPserver.updateWantedLevel({wanted_level})
      end
    end
  end
)

-- detect vehicle stealing
Citizen.CreateThread(
  function()
    while true do
      Citizen.Wait(1)
      local ped = PlayerPedId()
      if IsPedTryingToEnterALockedVehicle(ped) or IsPedJacking(ped) then
        Citizen.Wait(2000) -- wait x seconds before setting wanted
        local ok, vtype, name = tvRP.getNearestOwnedVehicle(5)
        if not ok then -- prevent stealing detection on owned vehicle
          for i = 0, 4 do -- keep wanted for 1 minutes 30 seconds
            tvRP.applyWantedLevel(2)
            Citizen.Wait(15000)
          end
        end
        Citizen.Wait(15000) -- wait 15 seconds before checking again
      end
    end
  end
)

Citizen.CreateThread(
  function()
    while true do
      Citizen.Wait(1)
      if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("weapon_unarmed") then
        DisableControlAction(0, 263, true)
        DisableControlAction(0, 264, true)
        DisableControlAction(0, 257, true)
        DisableControlAction(0, 140, true)
        DisableControlAction(0, 141, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 143, true)
        DisableControlAction(0, 24, true)
        DisableControlAction(0, 25, true)
      end
    end
  end
)

local shared_config = module('vrp', 'factions/mpd/cfg_mpd')
RegisterNetEvent('MPD:Client:RemovePoliceWeapons')
AddEventHandler('MPD:Client:RemovePoliceWeapons', function()
    local client_ped = PlayerPedId()
    SetPedArmour(client_ped, 0)
    
    for i, weapon_table in pairs(shared_config.small_arms_weapons) do
        RemoveWeaponFromPed(client_ped, GetHashKey(weapon_table.hash))
    end

    for i, weapon_table in pairs(shared_config.large_arms_weapons) do
        RemoveWeaponFromPed(client_ped, GetHashKey(weapon_table.hash))
    end
end)