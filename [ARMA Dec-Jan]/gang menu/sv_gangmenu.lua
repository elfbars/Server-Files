function addGangLog(name, id, date, action, actionValue)
    exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(id) == I then
                    local ganglogs = {}
                    if V.logs == 'NOTHING' then
                        ganglogs = {}
                    else
                        ganglogs = json.decode(V.logs)
                    end
                    local gangname = V.gangname
                    table.insert(ganglogs, 1, {name, id, date, action, actionValue})
                    ganglogs = json.encode(ganglogs)
                    exports['ghmattimysql']:execute("UPDATE arma_gangs SET logs = @logs WHERE gangname=@gangname", {logs = ganglogs, gangname = gangname}, function()
                        TriggerClientEvent('ARMA:ForceRefreshData', -1)
                    end)
                    break
                end
            end
        end
    end)
end

RegisterServerEvent("ARMA:GetGangData")
AddEventHandler("ARMA:GetGangData", function()
    local source=source
    local newarray = nil
    local peoplesids = {}
    local user_id=ARMA.getUserId(source)
    local gangmembers ={}
    local gangpermission
    local ganglogs = {}
    exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    newarray={}
                    newarray["money"] = V.funds
                    isingang = true
                    newarray["id"] = V.gangname
                    gangpermission = L.gangPermission
                    ganglogs = json.decode(V.logs)
                    for U,D in pairs(array) do
                        peoplesids[tostring(U)] = tostring(D.gangPermission)
                    end
                    exports['ghmattimysql']:execute('SELECT * FROM arma_users', function(gotUser)
                        for J,G in pairs(gotUser) do
                            if peoplesids[tostring(G.id)] ~= nil then
                                table.insert(gangmembers,{G.username,tonumber(G.id),peoplesids[tostring(G.id)]})
                            end
                        end
                        TriggerClientEvent('ARMA:GotGangData', source,newarray,gangmembers,gangpermission,ganglogs)
                    end)
                    break
                end
            end
        end
    end)
end)
RegisterServerEvent("ARMA:CreateGang")
AddEventHandler("ARMA:CreateGang", function(gangname)
    local source=source
    local user_id=ARMA.getUserId(source)
    local user_name = GetPlayerName(source)
    local funds = 0 
    local logs = "NOTHING"
    exports['ghmattimysql']:execute('SELECT gangname FROM arma_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGang)
        if not ARMA.hasGroup(user_id,"Gang") then
            ARMAclient.notify(source,{"~r~You do not have a gang license."})
            return
        end
        if json.encode(gotGang) ~= "[]" and gotGang ~= nil and json.encode(gotGang) ~= nil then
            ARMAclient.notify(source,{"~r~Gang name is already in use."})
            return
        end
        local gangmembers = {
            [tostring(user_id)] = {
                ["rank"] = 4,
                ["gangPermission"] = 4,
            },
        }
        gangmembers = json.encode(gangmembers)
        ARMAclient.notify(source,{"~g~"..gangname.." created."})
        exports['ghmattimysql']:execute("INSERT INTO arma_gangs (gangname,gangmembers,funds,logs) VALUES(@gangname,@gangmembers,@funds,@logs)", {gangname=gangname,gangmembers=gangmembers,funds=funds,logs=logs}, function() end)
        TriggerClientEvent('ARMA:gangNameNotTaken', source)
        TriggerClientEvent('ARMA:ForceRefreshData', -1)
    end)
end)
RegisterServerEvent("ARMA:addUserToGang")
AddEventHandler("ARMA:addUserToGang", function(ganginvite,playerid)
    local source=source
    local user_id=ARMA.getUserId(source)
    local playersource = ARMA.getUserSource(playerid)
    exports['ghmattimysql']:execute('SELECT * FROM arma_gangs WHERE gangname = @gangname', {gangname = ganginvite}, function(G)
        if json.encode(G) == "[]" and G == nil and json.encode(G) == nil then
            ARMAclient.notify(playersource,{"~r~Gang no longer exists."})
            return
        end
        for K,V in pairs(G) do
            local array = json.decode(V.gangmembers)
            array[tostring(playerid)] = {["rank"] = 1,["gangPermission"] = 1}
            exports['ghmattimysql']:execute("UPDATE arma_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers = json.encode(array), gangname = ganginvite}, function()
                TriggerClientEvent('ARMA:ForceRefreshData', -1)
            end)
        end
    end)
end)
RegisterServerEvent("ARMA:depositGangBalance")
AddEventHandler("ARMA:depositGangBalance", function(amount)
    local source = source
    local user_id = ARMA.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local funds = V.funds
                    local gangname = V.gangname
                    if tonumber(amount) < 0 then
                        ARMAclient.notify(source,{"~r~Invalid Amount"})
                        return
                    end
                    if tonumber(ARMA.getBankMoney(user_id)) < tonumber(amount) then
                        ARMAclient.notify(source,{"~r~Not enough money in bank."})
                    else
                        --ARMA.setMoney(user_id,tonumber(ARMA.getMoney(user_id))-tonumber(amount))
                        ARMA.setBankMoney(user_id, (ARMA.getBankMoney(user_id)-tonumber(amount)))
                        ARMAclient.notify(source,{"~g~Deposited £"..getMoneyStringFormatted(amount)})
                        local newamount = tonumber(amount)+tonumber(funds)
                        local tax = tonumber(amount)*0.02
                        TriggerEvent('ARMA:addToCommunityPot', math.floor(tax))
                        addGangLog(name, user_id, date, 'Deposited', '£'..getMoneyStringFormatted(amount))
                        -- put webhook here for deposit
                        exports['ghmattimysql']:execute("UPDATE arma_gangs SET funds = @funds WHERE gangname=@gangname", {funds = tostring(newamount)-tostring(tax), gangname = gangname}, function()
                            TriggerClientEvent('ARMA:ForceRefreshData', -1)
                        end)
                    end
                end
            end
        end
    end)
    TriggerClientEvent('ARMA:ForceRefreshData', source)
end)
RegisterServerEvent("ARMA:depositAllGangBalance")
AddEventHandler("ARMA:depositAllGangBalance", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    local amount = ARMA.getBankMoney(user_id)
    exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local funds = V.funds
                    local gangname = V.gangname
                    if tonumber(amount) < 0 then
                        ARMAclient.notify(source,{"~r~Invalid Amount"})
                        return
                    end
                    ARMA.setBankMoney(user_id, (ARMA.getBankMoney(user_id)-amount))
                    ARMAclient.notify(source,{"~g~Deposited £"..getMoneyStringFormatted(amount)})
                    local newamount = tonumber(amount)+tonumber(funds)
                    local tax = tonumber(amount)*0.02
                    TriggerEvent('ARMA:addToCommunityPot', math.floor(tax))
                    addGangLog(name, user_id, date, 'Deposited', '£'..getMoneyStringFormatted(amount))
                    -- put webhook here for deposit all
                    exports['ghmattimysql']:execute("UPDATE arma_gangs SET funds = @funds WHERE gangname=@gangname", {funds = tostring(newamount)-tostring(tax), gangname = gangname}, function()
                        TriggerClientEvent('ARMA:ForceRefreshData', -1)
                    end)
                end
            end
        end
    end)
    TriggerClientEvent('ARMA:ForceRefreshData', source)
end)

local gangWithdraw = {}
RegisterServerEvent("ARMA:withdrawGangBalance")
AddEventHandler("ARMA:withdrawGangBalance", function(amount)
    local source = source
    local user_id = ARMA.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    if not gangWithdraw[source] then
        gangWithdraw[source] = true
        exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
            for K,V in pairs(gotGangs) do
                local array = json.decode(V.gangmembers)
                for I,L in pairs(array) do
                    if tostring(user_id) == I then
                        local funds = V.funds
                        local gangname = V.gangname
                        if tonumber(amount) < 0 then
                            ARMAclient.notify(source,{"~r~Invalid Amount"})
                            return
                        end
                        if tonumber(funds) < tonumber(amount) then
                            ARMAclient.notify(source,{"~r~Invalid Amount."})
                        else
                            ARMA.setBankMoney(user_id, (ARMA.getBankMoney(user_id)+tonumber(amount)))
                            ARMAclient.notify(source,{"~g~Withdrew £"..getMoneyStringFormatted(amount)})
                            local newamount = tonumber(funds)-tonumber(amount)
                            addGangLog(name, user_id, date, 'Withdrew', '£'..getMoneyStringFormatted(amount))
                            -- put webhook here for withdraw
                            exports['ghmattimysql']:execute("UPDATE arma_gangs SET funds = @funds WHERE gangname=@gangname", {funds = tostring(newamount), gangname = gangname}, function()
                                TriggerClientEvent('ARMA:ForceRefreshData', -1)
                            end)
                        end
                    end
                end
            end
            gangWithdraw[source] = nil
        end)
    end
    TriggerClientEvent('ARMA:ForceRefreshData', source)
end)
RegisterServerEvent("ARMA:withdrawAllGangBalance")
AddEventHandler("ARMA:withdrawAllGangBalance", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    if not gangWithdraw[source] then
        gangWithdraw[source] = true
        exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
            for K,V in pairs(gotGangs) do
                local array = json.decode(V.gangmembers)
                for I,L in pairs(array) do
                    if tostring(user_id) == I then
                        local funds = V.funds
                        local gangname = V.gangname
                        local amount = V.funds
                        if tonumber(funds) < 1 then
                            ARMAclient.notify(source,{"~r~Invalid Amount."})
                        else
                            ARMA.setBankMoney(user_id, (ARMA.getBankMoney(user_id)+amount))
                            ARMAclient.notify(source,{"~g~Withdrew £"..getMoneyStringFormatted(amount)})
                            addGangLog(name, user_id, date, 'Withdrew', '£'..getMoneyStringFormatted(amount))
                            -- put webhook here for withdraw all
                            exports['ghmattimysql']:execute("UPDATE arma_gangs SET funds = @funds WHERE gangname=@gangname", {funds = tostring(newamount), gangname = gangname}, function()
                                TriggerClientEvent('ARMA:ForceRefreshData', -1)
                            end)
                        end
                    end
                end
            end
            gangWithdraw[source] = nil
        end)
    end
    TriggerClientEvent('ARMA:ForceRefreshData', source)
end)
RegisterServerEvent("ARMA:PromoteUser")
AddEventHandler("ARMA:PromoteUser", function(gangid,memberid)
    local source = source
    local user_id=ARMA.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    if L.rank >= 4 then
                        local rank = array[tostring(memberid)].rank
                        local gangpermission = array[tostring(memberid)].gangPermission
                        if rank < 4 and gangpermission < 4 and tostring(user_id) ~= I then
                            ARMAclient.notify(source,{"~r~Only can Leader can promote."})
                            return
                        end
                        if array[tostring(memberid)].rank == 3 and gangpermission == 3 and tostring(user_id) == I then
                            ARMAclient.notify(source,{"~r~There can only be 1 leader in each gang."})
                            return
                        end
                        if tonumber(memberid) == tonumber(user_id) and rank == 4 and gangpermission == 4 then
                            ARMAclient.notify(source,{"~r~You are the highest rank."})
                            return
                        end 
                        array[tostring(memberid)].gangPermission = tonumber(gangpermission)+1
                        array[tostring(memberid)].rank = tonumber(rank)+1
                        array = json.encode(array)
                        addGangLog(name, user_id, date, 'Promoted', 'ID: '..memberid)
                        exports['ghmattimysql']:execute("UPDATE arma_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers=array, gangname = gangid}, function()
                            TriggerClientEvent('ARMA:ForceRefreshData', -1)
                        end)
                    end
                end
            end
        end
    end)
end)
RegisterServerEvent("ARMA:DemoteUser")
AddEventHandler("ARMA:DemoteUser", function(gangid,memberid)
    local source = source
    local user_id=ARMA.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    if L.rank >= 4 then
                        local rank = array[tostring(memberid)].rank
                        local gangpermission = array[tostring(memberid)].gangPermission
                        if rank == 4 or gangpermission == 4 then
                            ARMAclient.notify(source,{"~r~Cannot demote the leader"})
                            return
                        end
                        if rank == 1 and gangpermission == 1 then
                            ARMAclient.notify(source,{"~r~Member is already the lowest rank."})
                            return
                        end
                        array[tostring(memberid)].rank = tonumber(rank)-1
                        array[tostring(memberid)].gangPermission = tonumber(gangpermission)-1
                        array = json.encode(array)
                        addGangLog(name, user_id, date, 'Demoted', 'ID: '..memberid)
                        exports['ghmattimysql']:execute("UPDATE arma_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers=array, gangname = gangid}, function()
                            TriggerClientEvent('ARMA:ForceRefreshData', -1)
                        end)
                    end
                end
            end
        end
    end)
end)
RegisterServerEvent("ARMA:kickMemberFromGang")
AddEventHandler("ARMA:kickMemberFromGang", function(gangid,member)
    local source = source
    local user_id = ARMA.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    local membersource = ARMA.getUserSource(member)
    if membersource == nil then
        membersource = 0
    end
    local membergang = ""
    exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local memberrank = array[tostring(member)].rank
                    local rank = array[tostring(user_id)].rank
                    if tonumber(member) == tonumber(user_id) then
                        ARMAclient.notify(source,{"~r~You cannot kick yourself."})
                        return
                    end
                    if tonumber(memberrank) >= rank then
                        ARMAclient.notify(source,{"~r~You do not have permission to kick this member from the gang."})
                        return
                    end
                    array[tostring(member)] = nil
                    array = json.encode(array)
                    ARMAclient.notify(source,{"~r~Successfully kicked member from gang."})
                    addGangLog(name, user_id, date, 'Kicked', 'ID: '..member)
                    exports['ghmattimysql']:execute("UPDATE arma_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers=array, gangname = gangid}, function()
                        TriggerClientEvent('ARMA:ForceRefreshData', source)
                        if tonumber(membersource) > 0 then
                            ARMAclient.notify(membersource,{"~r~You have been kicked from the gang."})
                            TriggerClientEvent('ARMA:disbandedGang', membersource)
                        end
                    end)
                end
            end
        end
    end)
end)
RegisterServerEvent("ARMA:memberLeaveGang")
AddEventHandler("ARMA:memberLeaveGang", function(gangid)
    local source = source
    local user_id = ARMA.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    local membersource = ARMA.getUserSource(user_id)
    if membersource == nil then
        membersource = 0
    end
    local membergang = ""
    exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local memberrank = array[tostring(user_id)].rank
                    local rank = array[tostring(user_id)].rank
                    if rank == 4 then
                        ARMAclient.notify(source,{"~r~You cannot leave the gang because you are the leader!"})
                        return
                    else
                        array[tostring(user_id)] = nil
                        array = json.encode(array)
                        addGangLog(name, user_id, date, 'Left', 'ID: '..user_id)
                        exports['ghmattimysql']:execute("UPDATE arma_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers=array, gangname = gangid}, function()
                            TriggerClientEvent('ARMA:ForceRefreshData', source)
                            if tonumber(membersource) > 0 then
                                ARMAclient.notify(source,{"~g~Successfully left gang."})
                                TriggerClientEvent('ARMA:disbandedGang', membersource)
                            end
                        end)
                    end
                end
            end
        end
    end)
end)
RegisterServerEvent("ARMA:InviteUserToGang")
AddEventHandler("ARMA:InviteUserToGang", function(gangid,playerid)
    local source = source
    playerid = tonumber(playerid)
    local user_id=ARMA.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    local message = "~g~Gang invite recieved from "..name
    local playersource = ARMA.getUserSource(playerid)
    if playersource == nil then
        ARMAclient.notify(source,{"~r~Player is not online."})
        return
    end
    local playername = GetPlayerName(playersource)
    addGangLog(name, user_id, date, 'Invited', 'ID: '..playerid)
    TriggerClientEvent('ARMA:InviteRecieved', playersource,message,gangid)
end)
RegisterServerEvent("ARMA:DeleteGang")
AddEventHandler("ARMA:DeleteGang", function(gangid)
    local source=source
    local user_id=ARMA.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM arma_gangs WHERE gangname = @gangname',{gangname = gangid}, function(G)
        for K,V in pairs(G) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    exports['ghmattimysql']:execute("DELETE FROM arma_gangs WHERE gangname = @gangname", {gangname = gangid}, function() end)
                    ARMAclient.notify(source,{"~g~Disbanded "..gangid})
                    TriggerClientEvent('ARMA:disbandedGang', source)
                    TriggerClientEvent('ARMA:ForceRefreshData', -1)
                end
            end
        end
    end)
end)