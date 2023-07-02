local a = module("cfg/cfg_fishing")
local b = false
local c = false
local d = 0
local e = 0
local f = 0
local g = false
local h = {x = 0.5, y = 0.88, width = 0.3, height = 0.04}
local i = {x = 0, y = h.y, width = 0, height = h.height}
local j = {x = h.x - h.width / 2, y = h.y, width = h.width * 0.01, height = h.height}
local k = {x = h.x, y = h.y - h.height / 2, width = h.width, height = 0.002}
local l = {x = h.x, y = h.y + h.height / 2, width = h.width, height = 0.002}
local m = {x = h.x - h.width / 2, y = h.y, width = k.height / 2, height = h.height + k.height}
local n = {x = h.x + h.width / 2, y = h.y, width = k.height / 2, height = h.height + k.height}
local o = a.Locations
local p = false
globalFishingOnDuty = false
AddEventHandler(
    "GMT:onClientSpawn",
    function(q, r)
        if r then
            local s = {
                {
                    title = "Illegal Fishing",
                    colour = 1,
                    id = 1,
                    position = vector3(3235.88, 70.77, 2.18),
                    blipsize = 70.0
                },
                {
                    title = "Illegal Fishing",
                    colour = 1,
                    id = 1,
                    position = vector3(-233.54, 7429.31, 1.68),
                    blipsize = 70.0
                },
                {
                    title = "Legal Fishing",
                    colour = 5,
                    id = 1,
                    position = vector3(1333.7081298828, 4013.1103515625, 29.587718963623),
                    blipsize = 70.0
                },
                {
                    title = "Legal Fishing",
                    colour = 5,
                    id = 1,
                    position = vector3(-1921.8419189453, -1466.4282226563, 1.6252751350403),
                    blipsize = 70.0
                }
            }
            for t, u in pairs(s) do
                local v = AddBlipForRadius(u.position.x, u.position.y, u.position.z, u.blipsize)
                SetBlipColour(v, u.colour)
                SetBlipAlpha(v, 180)
            end
        end
    end
)
RegisterNetEvent(
    "GMT:globalFishingOnDuty",
    function(w)
        globalFishingOnDuty = w
    end
)
local x = false
AddEventHandler(
    "GMT:onClientSpawn",
    function(q, r)
        if r then
            enter_fishing = function()
                if globalFishingOnDuty then
                    if not g then
                        drawNativeNotification("Press ~INPUT_CONTEXT~ to start Fishing")
                    else
                        print("casted rod, not showing say e to start fishing")
                    end
                else
                    drawNativeNotification("You are not signed up as a Fisherman, head to the job centre to sign up.")
                end
            end
            exit_fishing = function()
            end
            ontick_fishing = function(y)
                if globalFishingOnDuty then
                    if
                        IsControlJustPressed(0, 51) and not g and not IsPedSwimming(PlayerPedId()) and
                            not IsPedFalling(PlayerPedId())
                     then
                        TriggerServerEvent("GMT:fishingJobChecks", y.type)
                    end
                    if IsControlJustPressed(0, 47) then
                        local z = GetVehiclePedIsIn(PlayerPedId(), true)
                        tGMT.notify("~y~Boat anchor set to " .. tostring(not x))
                        SetBoatAnchor(z, not x)
                        x = not x
                    end
                    drawNativeText("~g~Press [G] to anchor your boat.")
                end
            end
            for t, A in pairs(o) do
                if o[t].type == "legal" then
                    tGMT.createArea(
                        "fish_" .. t,
                        A.coords,
                        70,
                        10,
                        enter_fishing,
                        exit_fishing,
                        ontick_fishing,
                        {type = o[t].type}
                    )
                else
                    tGMT.createArea(
                        "fish_" .. t,
                        A.coords,
                        70,
                        10,
                        enter_fishing,
                        exit_fishing,
                        ontick_fishing,
                        {type = o[t].type}
                    )
                end
            end
        end
    end
)
RegisterNetEvent(
    "GMT:fishingJobBarParams",
    function(B, C, D)
        e = C
        f = D
        while g do
            if c then
                if d < 100 then
                    while d < 100 and c do
                        Citizen.Wait(B)
                        j.x = j.x + h.width / 100
                        d = d + 1
                    end
                end
                if d == 100 then
                    while d ~= 0 and c do
                        Citizen.Wait(B)
                        j.x = j.x - h.width / 100
                        d = d - 1
                    end
                end
            end
            Citizen.Wait(0)
        end
    end
)
function func_fishingStatus(y)
    if g and not c then
        subtitleText("Waiting for Bite...")
        if not IsPedUsingScenario(y.playerPed, "world_human_stand_fishing") then
            TaskStartScenarioInPlace(y.playerPed, "world_human_stand_fishing", 0, false)
        end
    elseif g and c then
        if IsControlJustPressed(0, 102) then
            ClearPedTasks(y.playerPed)
            if d >= e and d <= f then
                TriggerServerEvent("GMT:fishingCaughtFish", d)
            else
                TriggerServerEvent("GMT:fishingCaughtFish", d)
                subtitleText("Your Line Snapped...")
                SetPedToRagdoll(y.playerPed, 0, math.random(300, 600), 0, 0, 0, 0)
                CreateNmMessage(true, 1151)
                GivePedNmMessage(y.playerPed)
            end
            d = 0
            c = false
            g = false
            p = false
        end
    end
    if c and not p then
        setNewBarDimensions()
        p = true
    end
end
tGMT.createThreadOnTick(func_fishingStatus)
RegisterNetEvent(
    "GMT:fishingJobSetCasted",
    function()
        g = true
        Citizen.Wait(math.random(20000, 40000))
        c = true
    end
)
function setNewBarDimensions()
    j.x = h.x - h.width / 2
    i.x = h.x - h.width / 2 + math.floor((e + f) / 2) / 100 * h.width
    i.width = (f - e) / 100 * h.width
end
function func_createBar()
    if c and p then
        subtitleText("Press ~g~SPACE~w~ when the line meets up with the green box...")
        DrawRect(h.x, h.y, h.width, h.height, 0, 0, 0, 120)
        DrawRect(i.x, i.y, i.width, i.height, 0, 150, 0, 255)
        DrawRect(j.x, j.y, j.width, j.height, 255, 255, 255, 255)
        DrawRect(k.x, k.y, k.width, k.height, 0, 0, 0, 200)
        DrawRect(l.x, l.y, l.width, l.height, 0, 0, 0, 200)
        DrawRect(m.x, m.y, m.width, m.height, 0, 0, 0, 200)
        DrawRect(n.x, n.y, n.width, n.height, 0, 0, 0, 200)
    end
end
tGMT.createThreadOnTick(func_createBar)
function subtitleText(E)
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(E)
    EndTextCommandPrint(1000, 1)
end
