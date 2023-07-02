function GetEntInFrontOfPlayer(a, b)
    local c = nil
    local d = GetEntityCoords(b, 1)
    local e = GetOffsetFromEntityInWorldCoords(b, 0.0, a, 0.0)
    local f = StartShapeTestBox(d.x, d.y, d.z, e.x, e.y, e.z, 0, 0, b, 0)
    local g, h, i, j, c = GetShapeTestResult(f)
    return c
end
function GetCoordsFromCam(k)
    local l = GetGameplayCamRot(2)
    local m = GetGameplayCamCoord()
    local n = l.z * 0.0174532924
    local o = l.x * 0.0174532924
    local p = math.abs(math.cos(o))
    newCoordX = m.x + -math.sin(n) * (p + k)
    newCoordY = m.y + math.cos(n) * (p + k)
    newCoordZ = m.z + math.sin(o) * 8.0
    return newCoordX, newCoordY, newCoordZ
end
function Target(a, b)
    local q = nil
    local r = GetGameplayCamCoord()
    local s, t, u = GetCoordsFromCam(a)
    local f = StartExpensiveSynchronousShapeTestLosProbe(r.x, r.y, r.z, s, t, u, -1, b, 0)
    local g, h, i, j, q = GetShapeTestResult(f)
    return q, s, t, u
end
function Crosshair(v)
    SendNUIMessage({crosshair = v})
end
