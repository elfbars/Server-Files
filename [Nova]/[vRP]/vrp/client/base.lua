cfg = module("cfg/client")

tvRP = {}
local players = {} -- keep track of connected players (server id)

-- bind client tunnel interface
Tunnel.bindInterface("vRP", tvRP)

-- get server interface
vRPserver = Tunnel.getInterface("vRP", "vRP")

-- add client proxy interface (same as tunnel interface)
Proxy.addInterface("vRP", tvRP)

-- functions

-- functions

Config = {}
Config.cooldown = 1500

-- Add/remove weapon hashes here to be added for holster checks.
Config.Weapons = {
  "WEAPON_KNIFE",
  "WEAPON_BAT",
  "WEAPON_HATCHET",
  "WEAPON_HAMMER",
  "WEAPON_M1911",
  "WEAPON_FNP",
  "WEAPON_PYTHON",
  "WEAPON_WINCHESTER12",
  "WEAPON_akkal",
  "WEAPON_PPSH",
  "WEAPON_SCARL",
  "WEAPON_CHUCKY",
  "WEAPON_AUG",
  "WEAPON_M16A4",
  "WEAPON_SCAR",
  "WEAPON_MOSIN",
  "WEAPON_SNIPERRIFLE",
  "WEAPON_ASSAULTRIFLE_MK2"
}

local Weapons = {}
function tvRP.removeAllWeapons(name)
  Weapons = {}
end

function tvRP.allowWeapon(name)
  if Weapons[name] then
  else
    Weapons[name] = true
  end
  print(json.encode(Weapons))
  print("weapon added", name)
end

function tvRP.removeWeapon(name)
  if Weapons[name] then
  else
    Weapons[name] = nil
  end
  print(json.encode(Weapons))
  print("WEAPON DATA REMOVED: " .. name)
end

function tvRP.checkWeapon(name)
  if  Weapons[name] == nil then
      RemoveWeaponFromPed(PlayerPedId(), GetHashKey(name))
      print("Shit on, removed your spawned weapons ;)")
      TriggerServerEvent("Nova:anticheatBan", "Spawning in Weapon's [Cheating]")
      
      return
  end
end

function tvRP.teleport(x, y, z)
	tvRP.unjail() -- force unjail before a teleportation
	SetEntityCoords(PlayerPedId(), x + 0.0001, y + 0.0001, z + 0.0001, 1, 0, 0, 1)
	vRPserver.updatePos({x, y, z})
end

-- return x,y,z
function tvRP.getPosition()
	local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	return x, y, z
end

--returns the distance between 2 coordinates (x,y,z) and (x2,y2,z2)
function tvRP.getDistanceBetweenCoords(x, y, z, x2, y2, z2)
	local distance = GetDistanceBetweenCoords(x, y, z, x2, y2, z2, true)
	print('Distance Between Coords', distance, Vdist(x, y, z, x2, y2, z2))
	return distance
end

-- return false if in exterior, true if inside a building
function tvRP.isInside()
	local x, y, z = tvRP.getPosition()
	return GetInteriorAtCoords(x, y, z) ~= 0
end

-- return vx,vy,vz
function tvRP.getSpeed()
	local vx, vy, vz = table.unpack(GetEntityVelocity(PlayerPedId()))
	return math.sqrt(vx * vx + vy * vy + vz * vz)
end

function tvRP.getCamDirection()
  local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
  local pitch = GetGameplayCamRelativePitch()

  local x = -math.sin(heading * math.pi / 180.0)
  local y = math.cos(heading * math.pi / 180.0)
  local z = math.sin(pitch * math.pi / 180.0)

  -- normalize
  local len = math.sqrt(x * x + y * y + z * z)
  if len ~= 0 then
    x = x / len
    y = y / len
    z = z / len
  end

  return x, y, z
end

function tvRP.addPlayer(player)
  players[player] = true
end

function tvRP.removePlayer(player)
  players[player] = nil
end

function tvRP.getNearestPlayers(radius)
  local r = {}

  local ped = GetPlayerPed(i)
  local pid = PlayerId()
  local px, py, pz = tvRP.getPosition()

  --[[
  for i=0,GetNumberOfPlayers()-1 do
    if i ~= pid then
      local oped = GetPlayerPed(i)

      local x,y,z = table.unpack(GetEntityCoords(oped,true))
      local distance = GetDistanceBetweenCoords(x,y,z,px,py,pz,true)
      if distance <= radius then
        r[GetPlayerServerId(i)] = distance
      end
    end
  end
  --]]
  for k, v in pairs(players) do
    local player = GetPlayerFromServerId(k)

    if v and player ~= pid and NetworkIsPlayerConnected(player) then
      local oped = GetPlayerPed(player)
      local x, y, z = table.unpack(GetEntityCoords(oped, true))
      local distance = GetDistanceBetweenCoords(x, y, z, px, py, pz, true)
      if distance <= radius then
        r[GetPlayerServerId(player)] = distance
      end
    end
  end

  return r
end

function tvRP.getNearestPlayer(radius)
	local p = nil

	local players = tvRP.getNearestPlayers(radius)
	local min = radius + 10.0
	for k, v in pairs(players) do
		if v < min then
			min = v
			p = k
		end
	end

	return p
end

function tvRP.notify(msg)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandThefeedPostTicker(true, false)
end

exports('notify', function(msg)
    tvRP.notify(msg)
end)

function tvRP.notifyPicture(icon, icon_type, sender, title, text)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandThefeedPostMessagetext(icon, icon, true, icon_type, sender, title, text)
	EndTextCommandThefeedPostTicker(false, true)
end

function tvRP.SendPaycheckNotification(icon, colour_index, icon_type, sender, title, text)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(('%s %s\n%s'):format(sender, title, text))
    ThefeedSetNextPostBackgroundColor(colour_index)
    EndTextCommandThefeedPostTicker(false, true)
end

function tvRP.SendHoursInformation(colour_index, title, description)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(('%s\n%s'):format(title, description))
    ThefeedSetNextPostBackgroundColor(colour_index)
    EndTextCommandThefeedPostTicker(false, true)
end

-- SCREEN

-- play a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
-- duration: in seconds, if -1, will play until stopScreenEffect is called
function tvRP.playScreenEffect(name, duration)
  if duration < 0 then -- loop
    StartScreenEffect(name, 0, true)
  else
    StartScreenEffect(name, 0, true)

    Citizen.CreateThread(
      function()
        -- force stop the screen effect after duration+1 seconds
        Citizen.Wait(math.floor((duration + 1) * 1000))
        StopScreenEffect(name)
      end
    )
  end
end

-- stop a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
function tvRP.stopScreenEffect(name)
  StopScreenEffect(name)
end

-- ANIM

-- animations dict and names: http://docs.ragepluginhook.net/html/62951c37-a440-478c-b389-c471230ddfc5.htm

local anims = {}
local anim_ids = Tools.newIDGenerator()

-- play animation (new version)
-- upper: true, only upper body, false, full animation
-- seq: list of animations as {dict,anim_name,loops} (loops is the number of loops, default 1) or a task def (properties: task, play_exit)
-- looping: if true, will infinitely loop the first element of the sequence until stopAnim is called
function tvRP.playAnim(upper, seq, looping)
  if seq.task ~= nil then -- is a task (cf https://github.com/ImagicTheCat/vRP/pull/118)
    tvRP.stopAnim(true)

    local ped = PlayerPedId()
    if seq.task == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then -- special case, sit in a chair
      local x, y, z = tvRP.getPosition()
      TaskStartScenarioAtPosition(ped, seq.task, x, y, z - 1, GetEntityHeading(ped), 0, 0, false)
    else
      TaskStartScenarioInPlace(ped, seq.task, 0, not seq.play_exit)
    end
  else -- a regular animation sequence
    tvRP.stopAnim(upper)

    local flags = 0
    if upper then
      flags = flags + 48
    end
    if looping then
      flags = flags + 1
    end

    Citizen.CreateThread(
      function()
        -- prepare unique id to stop sequence when needed
        local id = anim_ids:gen()
        anims[id] = true

        for k, v in pairs(seq) do
          local dict = v[1]
          local name = v[2]
          local loops = v[3] or 1

          for i = 1, loops do
            if anims[id] then -- check animation working
              local first = (k == 1 and i == 1)
              local last = (k == #seq and i == loops)

              -- request anim dict
              RequestAnimDict(dict)
              local i = 0
              while not HasAnimDictLoaded(dict) and i < 1000 do -- max time, 10 seconds
                Citizen.Wait(10)
                RequestAnimDict(dict)
                i = i + 1
              end

              -- play anim
              if HasAnimDictLoaded(dict) and anims[id] then
                local inspeed = 8.0001
                local outspeed = -8.0001
                if not first then
                  inspeed = 2.0001
                end
                if not last then
                  outspeed = 2.0001
                end

                TaskPlayAnim(PlayerPedId(), dict, name, inspeed, outspeed, -1, flags, 0, 0, 0, 0)
              end

              Citizen.Wait(0)
              while GetEntityAnimCurrentTime(PlayerPedId(), dict, name) <= 0.95 and
                IsEntityPlayingAnim(PlayerPedId(), dict, name, 3) and
                anims[id] do
                Citizen.Wait(0)
              end
            end
          end
        end

        -- free id
        anim_ids:free(id)
        anims[id] = nil
      end
    )
  end
end

-- stop animation (new version)
-- upper: true, stop the upper animation, false, stop full animations
function tvRP.stopAnim(upper)
  anims = {} -- stop all sequences
  if upper then
    ClearPedSecondaryTask(PlayerPedId())
  else
    ClearPedTasks(PlayerPedId())
  end
end

-- RAGDOLL
local ragdoll = false

-- set player ragdoll flag (true or false)
function tvRP.setRagdoll(flag)
  ragdoll = flag
end

-- ragdoll thread
Citizen.CreateThread(function()
	while true do
		if ragdoll then
			SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
		end
		Citizen.Wait(10)
	end
end
)

-- SOUND
-- some lists:
-- pastebin.com/A8Ny8AHZ
-- https://wiki.gtanet.work/index.php?title=FrontEndSoundlist

-- play sound at a specific position
function tvRP.playSpatializedSound(dict, name, x, y, z, range)
  PlaySoundFromCoord(-1, name, x + 0.0001, y + 0.0001, z + 0.0001, dict, 0, range + 0.0001, 0)
end

-- play sound
function tvRP.playSound(dict, name)
  PlaySound(-1, name, dict, 0, 0, 1)
end

--[[
-- not working
function tvRP.setMovement(dict)
  if dict then
    SetPedMovementClipset(PlayerPedId(),dict,true)
  else
    ResetPedMovementClipset(PlayerPedId(),true)
  end
end
--]]
-- events

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("vRPcli:playerSpawned")
end)

AddEventHandler("onPlayerDied", function(player, reason)
    TriggerServerEvent("vRPcli:playerDied")
end)

AddEventHandler("onPlayerKilled", function(player, killer, reason)
	TriggerServerEvent("vRPcli:playerDied")
end)

-- voice proximity computation
Citizen.CreateThread(function()
    while true do
		local ped = PlayerPedId()
		local proximity = cfg.voice_proximity

		local veh = GetVehiclePedIsIn(ped, false)
		if veh ~= 0 then
			local hash = GetEntityModel(veh)
			-- make open vehicles (bike, etc) use the default proximity
			if IsThisModelACar(hash) or IsThisModelAHeli(hash) or IsThisModelAPlane(hash) then
				proximity = cfg.voice_proximity_vehicle
			end

		elseif tvRP.isInside() then
			proximity = cfg.voice_proximity_inside
		end

		NetworkSetTalkerProximity(proximity + 0.0001)
		Citizen.Wait(500)
	end
end)

TriggerServerEvent("VRP:CheckID")

RegisterNetEvent("VRP:CheckIdRegister")
AddEventHandler("VRP:CheckIdRegister", function()
	TriggerEvent("playerSpawned", GetEntityCoords(PlayerPedId()))
end)

local Founder = false
function tvRP.isFounder()
  return Founder
end

function tvRP.setFounder(bool_value)
  Founder = bool_value
  TriggerEvent('Nova:Client:FounderSet', bool_value)
end