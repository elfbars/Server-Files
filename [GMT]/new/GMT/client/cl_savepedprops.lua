local a = nil
local b = nil
local c = nil
local d = nil
Citizen.CreateThread(function()
    while true do
        local e = GetPedPropIndex(tGMT.getPlayerPed(), 0)
        if e ~= -1 then
            if e ~= a then
                a = e
            end
            local f = GetPedPropTextureIndex(tGMT.getPlayerPed(), 0)
            if f ~= b then
                b = f
            end
        end
        local g = GetPedPropIndex(tGMT.getPlayerPed(), 1)
        if g ~= c and g ~= -1 then
            c = g
        end
        local h = GetPedDrawableVariation(tGMT.getPlayerPed(), 1)
        if h ~= d and h ~= 0 then
            d = h
        end
        Wait(1000)
    end
end)
RegisterCommand("putonhat",function()
    SetPedPropIndex(tGMT.getPlayerPed(), 0, a, b)
end)
RegisterCommand("putonglasses",function()
    SetPedPropIndex(tGMT.getPlayerPed(), 1, c)
end)
RegisterCommand("putonmask",function()
    SetPedComponentVariation(tGMT.getPlayerPed(), 1, d, 0, 2)
end)