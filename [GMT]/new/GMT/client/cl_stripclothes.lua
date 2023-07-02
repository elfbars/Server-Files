function loadAnimDict(a)
    while not HasAnimDictLoaded(a) do
        RequestAnimDict(a)
        Citizen.Wait(5)
    end
end
TriggerEvent("chat:addSuggestion", "/takeoffmask", "Take off your mask")
TriggerEvent("chat:addSuggestion", "/takeoffhat", "Take off your hat")
TriggerEvent("chat:addSuggestion", "/takeoffjacket", "Take off your jacket")
TriggerEvent("chat:addSuggestion", "/takeofftie", "Take off your tie")
TriggerEvent("chat:addSuggestion", "/takeoffbracelet", "Take off your bracelet")
TriggerEvent("chat:addSuggestion", "/takeoffglasses", "Take off your glasses")
TriggerEvent("chat:addSuggestion", "/takeofftrousers", "Take off your trousers")
TriggerEvent("chat:addSuggestion", "/takeoffshoes", "Take off your shoes")
RegisterCommand("takeoffmask",function()
    local b = tGMT.getPlayerPed()
    loadAnimDict("veh@bike@common@front@base")
    TaskPlayAnim(b, "veh@bike@common@front@base", "take_off_helmet_walk", 5.0, 5.0, -1, 48, 0, 0, 0, 0)
    RemoveAnimDict("veh@bike@common@front@base")
    Citizen.Wait(700)
    SetPedComponentVariation(b, 1, 0, 0, 1)
    if IsPedWearingHelmet(b) then
        RemovePedHelmet(b, true)
    end
end)
RegisterCommand("takeoffhat",function()
    local b = tGMT.getPlayerPed()
    loadAnimDict("veh@bike@common@front@base")
    TaskPlayAnim(b, "veh@bike@common@front@base", "take_off_helmet_walk", 5.0, 5.0, -1, 48, 0, 0, 0, 0)
    RemoveAnimDict("veh@bike@common@front@base")
    Citizen.Wait(700)
    ClearPedProp(b, 0)
    if IsPedWearingHelmet(b) then
        RemovePedHelmet(b, true)
    end
end)
RegisterCommand("takeoffjacket",function()
    local b = tGMT.getPlayerPed()
    loadAnimDict("clothingtie")
    TaskPlayAnim(b, "clothingtie", "try_tie_positive_a", 5.0, 5.0, -1, 48, 0, 0, 0, 0)
    RemoveAnimDict("clothingtie")
    Citizen.Wait(3000)
    SetPedComponentVariation(b, 3, 15, 0, 0)
    SetPedComponentVariation(b, 8, 0, 240, 0)
    if GetEntityModel(b) == "mp_f_freemode_01" then
        SetPedComponentVariation(b, 11, 18, 0, 0)
    else
        SetPedComponentVariation(b, 11, 0, 240, 0)
    end
end)
RegisterCommand("takeofftie",function()
    local b = tGMT.getPlayerPed()
    loadAnimDict("clothingtie")
    TaskPlayAnim(b, "clothingtie", "try_tie_neutral_b", 5.0, 5.0, -1, 48, 0, 0, 0, 0)
    RemoveAnimDict("clothingtie")
    Citizen.Wait(1200)
    SetPedComponentVariation(b, 7, 0, 240, 0)
end)
RegisterCommand("takeoffbracelet",function()
    local b = tGMT.getPlayerPed()
    ClearPedProp(b, 6)
    ClearPedProp(b, 7)
end)
RegisterCommand("takeoffglasses",function()
    local b = tGMT.getPlayerPed()
    loadAnimDict("clothingspecs")
    TaskPlayAnim(b, "clothingspecs", "try_glasses_positive_a", 5.0, 5.0, -1, 48, 0, 0, 0, 0)
    RemoveAnimDict("clothingspecs")
    Citizen.Wait(1800)
    ClearPedProp(b, 1)
    Citizen.Wait(800)
    ClearPedSecondaryTask(b)
end)
RegisterCommand("takeofftrousers",function()
    local b = tGMT.getPlayerPed()
    loadAnimDict("clothingshoes")
    TaskPlayAnim(b, "clothingshoes", "try_shoes_positive_d", 5.0, 5.0, -1, 48, 0, 0, 0, 0)
    RemoveAnimDict("clothingshoes")
    Citizen.Wait(1800)
    if GetEntityModel(b) == "mp_f_freemode_01" then
        SetPedComponentVariation(b, 4, 14, 0, 2)
    else
        SetPedComponentVariation(b, 4, 14, 0, 2)
    end
    Citizen.Wait(800)
    ClearPedSecondaryTask(b)
end)
RegisterCommand("takeoffshoes",function()
    local b = tGMT.getPlayerPed()
    loadAnimDict("clothingshoes")
    TaskPlayAnim(b, "clothingshoes", "try_shoes_positive_d", 5.0, 5.0, -1, 48, 0, 0, 0, 0)
    RemoveAnimDict("clothingshoes")
    Citizen.Wait(1800)
    if GetEntityModel(b) == "mp_f_freemode_01" then
        SetPedComponentVariation(b, 6, 118, 0, 2)
    else
        SetPedComponentVariation(b, 6, 118, 0, 2)
    end
    Citizen.Wait(800)
    ClearPedSecondaryTask(b)
end)
