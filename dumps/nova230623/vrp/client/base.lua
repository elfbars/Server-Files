cfg = module("cfg/client")
cfgweapons = module("NOVAWeapons", "cfg/cfg_weaponNames")
local user_id = 0
tvRP = {}
allowedWeapons = {}
local players = {} -- keep track of connected players (server id)

-- bind client tunnel interface
Tunnel.bindInterface("vRP",tvRP)

-- get server interface
vRPserver = Tunnel.getInterface("vRP","vRP")

-- add client proxy interface (same as tunnel interface)
Proxy.addInterface("vRP",tvRP)



-- anti cheat shite for giveweapontoped cancelling stuff


--[[ function tvRP.allowWeapon(name)
  if allowedWeapons[name] then
  else
    allowedWeapons[name] = true
  end
end

function tvRP.removeWeapon(name)
  if allowedWeapons[name] then
    allowedWeapons[name] = nil
  end
end

function tvRP.ClearWeapons()
  allowedWeapons = {}
end


function tvRP.checkWeapon(name)
  if allowedWeapons[name] == nil then
    RemoveWeaponFromPed(PlayerPedId(), GetHashKey(name))
    print("Tried to spawn "..name)
    return
  end
end




Citizen.CreateThread(function()
  while true do 
    Wait(300)
    for k,v in pairs(cfgweapons.weaponNames) do 
      if GetHashKey(k) then
        if HasPedGotWeapon(PlayerPedId(),GetHashKey(k),false) then   
          tvRP.checkWeapon(k)
        end
      end
    end
  end
end) ]]



-- functions
function tvRP.teleport(x,y,z)
  tvRP.unjail() -- force unjail before a teleportation
  SetEntityCoords(GetPlayerPed(-1), x+0.0001, y+0.0001, z+0.0001, 1,0,0,1)
  vRPserver.updatePos({x,y,z})
end

-- return x,y,z
function tvRP.getPosition()
  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
  return x,y,z
end

--returns the distance between 2 coordinates (x,y,z) and (x2,y2,z2)
function tvRP.getDistanceBetweenCoords(x,y,z,x2,y2,z2)

-- local distance = GetDistanceBetweenCoords(x,y,z,x2,y2,z2, true)
local distance = #(vec(x, y, z) - vector3(x2, y2, z2)) 
  
  return distance
end

-- return false if in exterior, true if inside a building
function tvRP.isInside()
  local x,y,z = tvRP.getPosition()
  return not (GetInteriorAtCoords(x,y,z) == 0)
end

-- return vx,vy,vz
function tvRP.getSpeed()
  local vx,vy,vz = table.unpack(GetEntityVelocity(GetPlayerPed(-1)))
  return math.sqrt(vx*vx+vy*vy+vz*vz)
end

function tvRP.getCamDirection()
  local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
  local pitch = GetGameplayCamRelativePitch()

  local x = -math.sin(heading*math.pi/180.0)
  local y = math.cos(heading*math.pi/180.0)
  local z = math.sin(pitch*math.pi/180.0)

  -- normalize
  local len = math.sqrt(x*x+y*y+z*z)
  if len ~= 0 then
    x = x/len
    y = y/len
    z = z/len
  end

  return x,y,z
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
  local px,py,pz = tvRP.getPosition()

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

  for k,v in pairs(players) do
    local player = GetPlayerFromServerId(k)

    if v and player ~= pid and NetworkIsPlayerConnected(player) then
      local oped = GetPlayerPed(player)
      local x,y,z = table.unpack(GetEntityCoords(oped,true))
      local distance = GetDistanceBetweenCoords(x,y,z,px,py,pz,true)
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
  local min = radius+10.0
  for k,v in pairs(players) do
    if v < min then
      min = v
      p = k
    end
  end

  return p
end

function tvRP.notify(msg)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(msg)
  DrawNotification(true, false)
end

function tvRP.notifyPicture(icon, type, sender, title, text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage(icon, icon, true, type, sender, title, text)
    DrawNotification(false, true)
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

    Citizen.CreateThread(function() -- force stop the screen effect after duration+1 seconds
      Citizen.Wait(math.floor((duration+1)*1000))
      StopScreenEffect(name)
    end)
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
-- looping: if true, will NOVAly loop the first element of the sequence until stopAnim is called
function tvRP.playAnim(upper, seq, looping)
  if seq.task ~= nil then -- is a task (cf https://github.com/ImagicTheCat/vRP/pull/118)
    tvRP.stopAnim(true)

    local ped = GetPlayerPed(-1)
    if seq.task == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then -- special case, sit in a chair
      local x,y,z = tvRP.getPosition()
      TaskStartScenarioAtPosition(ped, seq.task, x, y, z-1, GetEntityHeading(ped), 0, 0, false)
    else
      TaskStartScenarioInPlace(ped, seq.task, 0, not seq.play_exit)
    end
  else -- a regular animation sequence
    tvRP.stopAnim(upper)

    local flags = 0
    if upper then flags = flags+48 end
    if looping then flags = flags+1 end

    Citizen.CreateThread(function()
      -- prepare unique id to stop sequence when needed
      local id = anim_ids:gen()
      anims[id] = true

      for k,v in pairs(seq) do
        local dict = v[1]
        local name = v[2]
        local loops = v[3] or 1

        for i=1,loops do
          if anims[id] then -- check animation working
            local first = (k == 1 and i == 1)
            local last = (k == #seq and i == loops)

            -- request anim dict
            RequestAnimDict(dict)
            local i = 0
            while not HasAnimDictLoaded(dict) and i < 1000 do -- max time, 10 seconds
              Citizen.Wait(10)
              RequestAnimDict(dict)
              i = i+1
            end

            -- play anim
            if HasAnimDictLoaded(dict) and anims[id] then
              local inspeed = 8.0001
              local outspeed = -8.0001
              if not first then inspeed = 2.0001 end
              if not last then outspeed = 2.0001 end

              TaskPlayAnim(GetPlayerPed(-1),dict,name,inspeed,outspeed,-1,flags,0,0,0,0)
            end

            Citizen.Wait(0)
            while GetEntityAnimCurrentTime(GetPlayerPed(-1),dict,name) <= 0.95 and IsEntityPlayingAnim(GetPlayerPed(-1),dict,name,3) and anims[id] do
              Citizen.Wait(0)
            end
          end
        end
      end

      -- free id
      anim_ids:free(id)
      anims[id] = nil
    end)
  end
end

-- stop animation (new version)
-- upper: true, stop the upper animation, false, stop full animations
function tvRP.stopAnim(upper)
  anims = {} -- stop all sequences
  if upper then
    ClearPedSecondaryTask(GetPlayerPed(-1))
  else
    ClearPedTasks(GetPlayerPed(-1))
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
    Citizen.Wait(10)
    if ragdoll then
      SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
    end
  end
end)
-- SOUND
-- some lists: 
-- pastebin.com/A8Ny8AHZ
-- https://wiki.gtanet.work/index.php?title=FrontEndSoundlist

-- play sound at a specific position
function tvRP.playSpatializedSound(dict,name,x,y,z,range)
  PlaySoundFromCoord(-1,name,x+0.0001,y+0.0001,z+0.0001,dict,0,range+0.0001,0)
end

-- play sound
function tvRP.playSound(dict,name)
  PlaySound(-1,name,dict,0,0,1)
end

--[[
-- not working
function tvRP.setMovement(dict)
  if dict then
    SetPedMovementClipset(GetPlayerPed(-1),dict,true)
  else
    ResetPedMovementClipset(GetPlayerPed(-1),true)
  end
end
--]]

-- events

AddEventHandler("playerSpawned",function()
  TriggerServerEvent("vRPcli:playerSpawned")
  TriggerServerEvent("vRP:gettingUserID")
  TriggerServerEvent("NOVA:PoliceCheck")
  TriggerServerEvent("NOVA:RebelCheck")
  TriggerServerEvent("NOVA:VIPCheck")
  TriggerServerEvent("NOVA:getHouses")
end)

AddEventHandler("playerSpawned",function()
  TriggerEvent("NOVA:UnFreezeRespawn")
end)

AddEventHandler("onPlayerDied",function(player,reason)
  TriggerServerEvent("vRPcli:playerDied")
end)

AddEventHandler("onPlayerKilled",function(player,killer,reason)
  TriggerServerEvent("vRPcli:playerDied")
end)

TriggerServerEvent('VRP:CheckID')

RegisterNetEvent('VRP:CheckIdRegister')
AddEventHandler('VRP:CheckIdRegister', function()
    TriggerEvent('playerSpawned', GetEntityCoords(PlayerPedId()))
end)

RegisterNetEvent("vRP:setUserID")
AddEventHandler("vRP:setUserID", function(serverid)
  user_id = serverid
end)

local developers = {
  [1] = true,
  [2] = true,
}
local grind = {
}
function tvRP.isGrinder(user_id) 
  return grind[user_id] or false
end

function tvRP.isDeveloper(user_id) 
  return developers[user_id] or false
end

function tvRP.getUserId(val)
  if val==nil then
    return user_id
  end
end

local aj = {}
local ak = {
    ["alphabet"] = "abcdefghijklmnopqrstuvwxyz",
    ["numerical"] = "0123456789",
    ["alphanumeric"] = "abcdefghijklmnopqrstuvwxyz0123456789"
}
local function al(am, type)
    local an, ao, ap = 0, "", 0
    local aq = {ak[type]}
    repeat
        an = an + 1
        ap = math.random(aq[an]:len())
        if math.random(2) == 1 then
            ao = ao .. aq[an]:sub(ap, ap)
        else
            ao = aq[an]:sub(ap, ap) .. ao
        end
        an = an % #aq
    until ao:len() >= am
    return ao
end
function tvRP.generateUUID(ar, am, type)
    if aj[ar] == nil then
        aj[ar] = {}
    end
    if type == nil then
        type = "alphanumeric"
    end
    local as = al(am, type)
    if aj[ar][as] then
        while aj[ar][as] ~= nil do
            as = al(am, type)
            Wait(0)
        end
    end
    aj[ar][as] = true
    return as
end

function drawNativeText(V)
  if not globalHideUi then
      BeginTextCommandPrint("STRING")
      AddTextComponentSubstringPlayerName(V)
      EndTextCommandPrint(100, 1)
  end
end
function DrawText3D(a, b, c, d, e, f, g)
  local h, i, j = GetScreenCoordFromWorldCoord(a, b, c)
  if h then
      SetTextScale(0.4, 0.4)
      SetTextFont(0)
      SetTextProportional(1)
      SetTextColour(255, 255, 255, 255)
      SetTextDropshadow(0, 0, 0, 0, 55)
      SetTextEdge(2, 0, 0, 0, 150)
      SetTextDropShadow()
      SetTextOutline()
      BeginTextCommandDisplayText("STRING")
      SetTextCentre(1)
      AddTextComponentSubstringPlayerName(d)
      EndTextCommandDisplayText(i, j)
  end
end

function tvRP.loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(0)
	end
end

local a = 0
local b = 0
local c = 0
local d = vector3(0, 0, 0)
local e = false
local f = PlayerPedId
function savePlayerInfo()
    a = f()
    b = GetVehiclePedIsIn(a, false)
    c = PlayerId()
    d = GetEntityCoords(a)
    local g = GetPedInVehicleSeat(b, -1)
    e = g == a
end
_G["PlayerPedId"] = function()
    return a
end
function tvRP.getPlayerPed()
    return a
end
function tvRP.getPlayerVehicle()
    return b, e
end
function tvRP.getPlayerId()
    return c
end
function tvRP.getPlayerCoords()
    return d
end

createThreadOnTick(savePlayerInfo)

function tvRP.getClosestVehicle(bm)
  local br = tvRP.getPlayerCoords()
  local bs = 100
  local bt = 100
  for T, bu in pairs(GetGamePool("CVehicle")) do
      local bv = GetEntityCoords(bu)
      local bw = #(br - bv)
      if bw < bt then
          bt = bw
          bs = bu
      end
  end
  if bt <= bm then
      return bs
  else
      return nil
  end
end

Citizen.CreateThread(function()
	while true do
			if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_UNARMED") then
				DisableControlAction(0,263,true)
				DisableControlAction(0,264,true)
				DisableControlAction(0,257,true)
				DisableControlAction(0,140,true) 
				DisableControlAction(0,141,true) 
				DisableControlAction(0,142,true)
				DisableControlAction(0,143,true) 
				DisableControlAction(0,24,true)
				DisableControlAction(0,25,true) 
			end
		SetPedCanBeDraggedOut(PlayerPedId(),false)
		Wait(0)
	end
end)

function DisableInvWhileInKeyboardInput()

    if blockinput==true then

    drawInventoryUI = false

    inGUINOVA = false

    setCursor(0)

    DisableAllControlActions(0)

  end

end

createThreadOnTick(DisableInvWhileInKeyboardInput)