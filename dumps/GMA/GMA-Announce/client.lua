RegisterNetEvent("GMA:DisplayText")
AddEventHandler("GMA:DisplayText", function(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end)
