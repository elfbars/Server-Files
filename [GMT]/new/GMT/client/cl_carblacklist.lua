local a = {
    ["corsa"] = {1},
}
local function b(c)
    DisableControlAction(0, 32, true)
    DisableControlAction(0, 33, true)
    DisableControlAction(0, 34, true)
    DisableControlAction(0, 35, true)
    DisableControlAction(0, 71, true)
    DisableControlAction(0, 72, true)
    DisableControlAction(0, 350, true)
    DisableControlAction(0, 351, true)
    SetVehicleRocketBoostPercentage(c, 0.0)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName("You have stalled the engine.")
    EndTextCommandThefeedPostTicker(false, false)
end
local function d()
    local c, e = tGMT.getPlayerVehicle()
    local f = tGMT.getUserId()
    if c ~= 0 and e and not tGMT.isDev() then
        local g = GetEntityModel(c)
        local h = a[g]
        if h then
            local i = false
            for j, k in pairs(h) do
                if k == f then
                    i = true
                    break
                end
            end
            if not i then
                b(c)
            end
        end
    end
end
tGMT.createThreadOnTick(d)
