RegisterNUICallback("respawnButtonClicked", function(data, cb)
    local name = data.location.name
    local price = tonumber(data.location.price)
    TriggerEvent("NOVA:respawnButtonClicked", name, price)
    SendNUIMessage({
        app = "",
        type = "APP_TOGGLE",
    })
    SetNuiFocus(false, false)
    cb()
end)

AddEventHandler("NOVA:OpenSpawnUI", function(locations)
    SendNUIMessage({
        type = "SET_SPAWN_LOCATIONS",
        info = {
            locations = locations
        }
    })
    SendNUIMessage({
        app = "spawn",
        type = "APP_TOGGLE",
    })
    SetNuiFocus(true, true)
end)
