local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local htmlEntities = module("lib/htmlEntities")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "FNR")

math.randomseed(os.time()) 

-- draCB.RegisterServerCallback('FNR:hasPhone', function(source, cb, data)
--     local user_id = vRP.getUserId({source})
--     if vRP.getInventoryItemAmount({user_id,"aphone"}) > 0 then
--         cb(true)
--     else
--         cb(false)
--     end
-- end)

--- Pour les numero du style XXX-XXXX
-- function getPhoneRandomNumber()
--     local numBase0 = math.random(100,999)
--     local numBase1 = math.random(0,9999)
--     local num = string.format("%03d-%04d", numBase0, numBase1 )
-- 	return num
-- end

--- Exemple pour les numero du style 06XXXXXXXX
function getPhoneRandomNumber()
    return '0' .. math.random(700000000,699999999)
end




--====================================================================================
--  Utils
--====================================================================================
function getSourceFromIdentifier(identifier, cb)
    return vRP.getUserSource({identifier})
end
function getNumberPhone(identifier)
    local result = MySQL.Sync.fetchAll("SELECT vrp_user_identities.phone FROM vrp_user_identities WHERE vrp_user_identities.user_id = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone
    end
    return nil
end
function getIdentifierByPhoneNumber(phone_number) 
    local result = MySQL.Sync.fetchAll("SELECT vrp_user_identities.user_id FROM vrp_user_identities WHERE vrp_user_identities.phone = @phone_number", {
        ['@phone_number'] = phone_number
    })
    if result[1] ~= nil then
        return result[1].user_id
    end
    return nil
end


function getPlayerID(source)
    local player = vRP.getUserId({source})
    return player
end
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end


function getOrGeneratePhoneNumber(sourcePlayer, identifier, cb)
    local sourcePlayer = sourcePlayer
    local identifier = identifier
    local myPhoneNumber = getNumberPhone(identifier)
    if myPhoneNumber == '0' or myPhoneNumber == nil then
        repeat
            myPhoneNumber = getPhoneRandomNumber()
            local id = getIdentifierByPhoneNumber(myPhoneNumber)
        until id == nil
        MySQL.Async.insert("UPDATE vrp_user_identities SET phone = @myPhoneNumber WHERE user_id = @identifier", { 
            ['@myPhoneNumber'] = myPhoneNumber,
            ['@identifier'] = identifier
        }, function ()
            cb(myPhoneNumber)
        end)
    else
        cb(myPhoneNumber)
    end
end
--====================================================================================
--  Contacts
--====================================================================================
function getContacts(identifier)
    local result = MySQL.Sync.fetchAll("SELECT * FROM phone_users_contacts WHERE phone_users_contacts.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    return result
end
function addContact(source, identifier, number, display)
    local sourcePlayer = tonumber(source)
    MySQL.Async.insert("INSERT INTO phone_users_contacts (`identifier`, `number`,`display`) VALUES(@identifier, @number, @display)", {
        ['@identifier'] = identifier,
        ['@number'] = number,
        ['@display'] = display,
    },function()
        notifyContactChange(sourcePlayer, identifier)
    end)
end
function updateContact(source, identifier, id, number, display)
    local sourcePlayer = tonumber(source)
    MySQL.Async.insert("UPDATE phone_users_contacts SET number = @number, display = @display WHERE id = @id", { 
        ['@number'] = number,
        ['@display'] = display,
        ['@id'] = id,
    },function()
        notifyContactChange(sourcePlayer, identifier)
    end)
end
function deleteContact(source, identifier, id)
    local sourcePlayer = tonumber(source)
    MySQL.Sync.execute("DELETE FROM phone_users_contacts WHERE `identifier` = @identifier AND `id` = @id", {
        ['@identifier'] = identifier,
        ['@id'] = id,
    })
    notifyContactChange(sourcePlayer, identifier)
end
function deleteAllContact(identifier)
    MySQL.Sync.execute("DELETE FROM phone_users_contacts WHERE `identifier` = @identifier", {
        ['@identifier'] = identifier
    })
end
function notifyContactChange(source, identifier)
    local sourcePlayer = tonumber(source)
    local identifier = identifier
    if sourcePlayer ~= nil then 
        TriggerClientEvent("FNR:contactList", sourcePlayer, getContacts(identifier))
    end
end

RegisterServerEvent('FNR:addContact')
AddEventHandler('FNR:addContact', function(display, phoneNumber)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    addContact(sourcePlayer, identifier, phoneNumber, display)
end)

RegisterServerEvent('FNR:updateContact')
AddEventHandler('FNR:updateContact', function(id, display, phoneNumber)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    updateContact(sourcePlayer, identifier, id, phoneNumber, display)
end)

RegisterServerEvent('FNR:deleteContact')
AddEventHandler('FNR:deleteContact', function(id)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteContact(sourcePlayer, identifier, id)
end)

--====================================================================================
--  Messages
--====================================================================================
function getMessages(identifier)
    local result = MySQL.Sync.fetchAll("SELECT phone_messages.* FROM phone_messages LEFT JOIN vrp_user_identities ON vrp_user_identities.user_id = @identifier WHERE phone_messages.receiver = vrp_user_identities.phone", {
         ['@identifier'] = identifier
    })
    return result
    --return MySQLQueryTimeStamp("SELECT phone_messages.* FROM phone_messages LEFT JOIN users ON users.identifier = @identifier WHERE phone_messages.receiver = users.phone_number", {['@identifier'] = identifier})
end

RegisterServerEvent('FNR:_internalAddMessage')
AddEventHandler('FNR:_internalAddMessage', function(transmitter, receiver, message, owner, cb)
    cb(_internalAddMessage(transmitter, receiver, message, owner))
end)

function _internalAddMessage(transmitter, receiver, message, owner)
    local Query = "INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner);"
    local Query2 = 'SELECT * from phone_messages WHERE `id` = @id;'
	local Parameters = {
        ['@transmitter'] = transmitter,
        ['@receiver'] = receiver,
        ['@message'] = message,
        ['@isRead'] = owner,
        ['@owner'] = owner
    }
    local id = MySQL.Sync.insert(Query, Parameters)
    return MySQL.Sync.fetchAll(Query2, {
        ['@id'] = id
    })[1]
end

function addMessage(source, identifier, phone_number, message)
    local sourcePlayer = tonumber(source)
    local otherIdentifier = getIdentifierByPhoneNumber(phone_number)
    local myPhone = getNumberPhone(identifier)
    if otherIdentifier ~= nil and vRP.getUserSource({otherIdentifier}) ~= nil then 
        local tomess = _internalAddMessage(myPhone, phone_number, message, 0)
        TriggerClientEvent("FNR:receiveMessage", tonumber(vRP.getUserSource({otherIdentifier})), tomess)
    end
    local memess = _internalAddMessage(phone_number, myPhone, message, 1)
    TriggerClientEvent("FNR:receiveMessage", sourcePlayer, memess)
end

function setReadMessageNumber(identifier, num)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("UPDATE phone_messages SET phone_messages.isRead = 1 WHERE phone_messages.receiver = @receiver AND phone_messages.transmitter = @transmitter", { 
        ['@receiver'] = mePhoneNumber,
        ['@transmitter'] = num
    })
end

function deleteMessage(msgId)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `id` = @id", {
        ['@id'] = msgId
    })
end

function deleteAllMessageFromPhoneNumber(source, identifier, phone_number)
    local source = source
    local identifier = identifier
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number", {['@mePhoneNumber'] = mePhoneNumber,['@phone_number'] = phone_number})
end

function deleteAllMessage(identifier)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber", {
        ['@mePhoneNumber'] = mePhoneNumber
    })
end

RegisterServerEvent('FNR:sendMessage')
AddEventHandler('FNR:sendMessage', function(phoneNumber, message)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    addMessage(sourcePlayer, identifier, phoneNumber, message)
end)

RegisterServerEvent('FNR:deleteMessage')
AddEventHandler('FNR:deleteMessage', function(msgId)
    deleteMessage(msgId)
end)

RegisterServerEvent('FNR:deleteMessageNumber')
AddEventHandler('FNR:deleteMessageNumber', function(number)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessageFromPhoneNumber(sourcePlayer,identifier, number)
    -- TriggerClientEvent("FNR:allMessage", sourcePlayer, getMessages(identifier))
end)

RegisterServerEvent('FNR:deleteAllMessage')
AddEventHandler('FNR:deleteAllMessage', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessage(identifier)
end)

RegisterServerEvent('FNR:setReadMessageNumber')
AddEventHandler('FNR:setReadMessageNumber', function(num)
    local identifier = getPlayerID(source)
    setReadMessageNumber(identifier, num)
end)

RegisterServerEvent('FNR:deleteALL')
AddEventHandler('FNR:deleteALL', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessage(identifier)
    deleteAllContact(identifier)
    appelsDeleteAllHistorique(identifier)
    TriggerClientEvent("FNR:contactList", sourcePlayer, {})
    TriggerClientEvent("FNR:allMessage", sourcePlayer, {})
    TriggerClientEvent("appelsDeleteAllHistorique", sourcePlayer, {})
end)

AddEventHandler('FNR:deleteALLvRPIdentity', function(src,user_id,num)
    deleteAllMessage(user_id)
    deleteAllContact(user_id)
    appelsDeleteAllHistorique(user_id)
    TriggerClientEvent("FNR:contactList", src, {})
    TriggerClientEvent("FNR:allMessage", src, {})
    TriggerClientEvent("appelsDeleteAllHistorique", src, {})
    TriggerClientEvent("FNR:myPhoneNumber", src, num) -- update phonenumber
end)

--====================================================================================
--  Gestion des appels
--====================================================================================
local AppelsEnCours = {}
local PhoneFixeInfo = {}
local lastIndexCall = 10

function getHistoriqueCall (num)
    local result = MySQL.Sync.fetchAll("SELECT * FROM phone_calls WHERE phone_calls.owner = @num ORDER BY time DESC LIMIT 120", {
        ['@num'] = num
    })
    return result
end

function sendHistoriqueCall (src, num) 
    local histo = getHistoriqueCall(num)
    TriggerClientEvent('FNR:historiqueCall', src, histo)
end

function saveAppels (appelInfo)
    if appelInfo.extraData == nil or appelInfo.extraData.useNumber == nil then
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.transmitter_num,
            ['@num'] = appelInfo.receiver_num,
            ['@incoming'] = 1,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
        end)
    end
    if appelInfo.is_valid == true then
        local num = appelInfo.transmitter_num
        if appelInfo.hidden == true then
            mun = "###-####"
        end
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.receiver_num,
            ['@num'] = num,
            ['@incoming'] = 0,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            if appelInfo.receiver_src ~= nil then
                notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
            end
        end)
    end
end

function notifyNewAppelsHisto (src, num) 
    sendHistoriqueCall(src, num)
end

RegisterServerEvent('FNR:getHistoriqueCall')
AddEventHandler('FNR:getHistoriqueCall', function()
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    local srcPhone = getNumberPhone(srcIdentifier)
    sendHistoriqueCall(sourcePlayer, num)
end)

local FixePhone = {}
RegisterServerEvent('FNR:internal_startCall')
AddEventHandler('FNR:internal_startCall', function(source, phone_number, rtcOffer, extraData)
    if FixePhone[phone_number] ~= nil then
        onCallFixePhone(source, phone_number, rtcOffer, extraData)
        return
    end
    
    local rtcOffer = rtcOffer
    if phone_number == nil or phone_number == '' then 
        print('BAD CALL NUMBER IS NIL')
        return
    end

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end

    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = getNumberPhone(srcIdentifier)
    end
    local destPlayer = getIdentifierByPhoneNumber(phone_number)
    local is_valid = destPlayer ~= nil and destPlayer ~= srcIdentifier
    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = destPlayer ~= nil,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData
    }
    

    if is_valid == true then
        -- getSourceFromIdentifier(destPlayer, function (srcTo)
        if vRP.getUserSource({destPlayer}) ~= nil then
            srcTo = tonumber(vRP.getUserSource({destPlayer}))

            if srcTo ~= nil then
                AppelsEnCours[indexCall].receiver_src = srcTo
                -- TriggerEvent('FNR:addCall', AppelsEnCours[indexCall])
                TriggerClientEvent('FNR:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
                TriggerClientEvent('FNR:waitingCall', srcTo, AppelsEnCours[indexCall], false)
            else
                -- TriggerEvent('FNR:addCall', AppelsEnCours[indexCall])
                TriggerClientEvent('FNR:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
            end
        end
    else
        TriggerEvent('FNR:addCall', AppelsEnCours[indexCall])
        TriggerClientEvent('FNR:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
    end

end)

RegisterServerEvent('FNR:startCall')
AddEventHandler('FNR:startCall', function(phone_number, rtcOffer, extraData)
    TriggerEvent('FNR:internal_startCall',source, phone_number, rtcOffer, extraData)
end)

RegisterServerEvent('FNR:candidates')
AddEventHandler('FNR:candidates', function (callId, candidates)
    if AppelsEnCours[callId] ~= nil then
        local source = source
        local to = AppelsEnCours[callId].transmitter_src
        if source == to then 
            to = AppelsEnCours[callId].receiver_src
        end
        TriggerClientEvent('FNR:candidates', to, candidates)
    end
end)


RegisterServerEvent('FNR:acceptCall')
AddEventHandler('FNR:acceptCall', function(infoCall, rtcAnswer)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onAcceptFixePhone(source, infoCall, rtcAnswer)
            return
        end
        AppelsEnCours[id].receiver_src = infoCall.receiver_src or AppelsEnCours[id].receiver_src
        if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
            AppelsEnCours[id].is_accepts = true
            AppelsEnCours[id].rtcAnswer = rtcAnswer
            TriggerClientEvent('FNR:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
	    SetTimeout(1000, function() -- change to +1000, if necessary.
       		TriggerClientEvent('FNR:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
	    end)
            saveAppels(AppelsEnCours[id])
        end
    end
end)




RegisterServerEvent('FNR:rejectCall')
AddEventHandler('FNR:rejectCall', function (infoCall)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onRejectFixePhone(source, infoCall)
            return
        end
        if AppelsEnCours[id].transmitter_src ~= nil then
            TriggerClientEvent('FNR:rejectCall', AppelsEnCours[id].transmitter_src)
        end
        if AppelsEnCours[id].receiver_src ~= nil then
            TriggerClientEvent('FNR:rejectCall', AppelsEnCours[id].receiver_src)
        end

        if AppelsEnCours[id].is_accepts == false then 
            saveAppels(AppelsEnCours[id])
        end
        TriggerEvent('FNR:removeCall', AppelsEnCours)
        AppelsEnCours[id] = nil
    end
end)

RegisterServerEvent('FNR:appelsDeleteHistorique')
AddEventHandler('FNR:appelsDeleteHistorique', function (numero)
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    local srcPhone = getNumberPhone(srcIdentifier)
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner AND `num` = @num", {
        ['@owner'] = srcPhone,
        ['@num'] = numero
    })
end)

function appelsDeleteAllHistorique(srcIdentifier)
    local srcPhone = getNumberPhone(srcIdentifier)
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner", {
        ['@owner'] = srcPhone
    })
end

RegisterServerEvent('FNR:appelsDeleteAllHistorique')
AddEventHandler('FNR:appelsDeleteAllHistorique', function ()
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    appelsDeleteAllHistorique(srcIdentifier)
end)










































--====================================================================================
--  OnLoad
--====================================================================================
AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    print("identifier")
    print(identifier)
    getOrGeneratePhoneNumber(sourcePlayer, identifier, function (myPhoneNumber)
        TriggerClientEvent("FNR:myPhoneNumber", sourcePlayer, myPhoneNumber)
        TriggerClientEvent("FNR:contactList", sourcePlayer, getContacts(identifier))
        TriggerClientEvent("FNR:allMessage", sourcePlayer, getMessages(identifier))
    end)
    local bankM = vRP.getBankMoney({user_id})
    TriggerClientEvent('FNR:setAccountMoney',source,bankM)
end)

-- Just For reload
RegisterServerEvent('FNR:allUpdate')
AddEventHandler('FNR:allUpdate', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    local num = getNumberPhone(identifier)
    TriggerClientEvent("FNR:myPhoneNumber", sourcePlayer, num)
    TriggerClientEvent("FNR:contactList", sourcePlayer, getContacts(identifier))
    TriggerClientEvent("FNR:allMessage", sourcePlayer, getMessages(identifier))
    --TriggerClientEvent('FNR:getBourse', sourcePlayer, getBourse())
    sendHistoriqueCall(sourcePlayer, num)
end)


AddEventHandler('onMySQLReady', function ()
    -- MySQL.Async.fetchAll("DELETE FROM phone_messages WHERE (DATEDIFF(CURRENT_DATE,time) > 10)")
end)

--====================================================================================
--  App bourse
--====================================================================================
-- Citizen.CreateThread(function()
--     local second = 1000
--     local minute = 60 * second
--     local hour = 60 * minute
--     while true do
--         Citizen.Wait(math.ceil(StockUpdateTime * hour))
--         TriggerEvent("FNR:Generateamounts")
--     end
-- end)

-- function getBourse()
    
--     name = {}
--     amount = {}
--     middle = {}
--     difference = {}

--     local result = MySQL.Sync.fetchAll("SELECT * FROM phone_stocks",{})

--     -- local qnt = #result
--     -- for i=1, qnt, 1 do
--     --     name[i] = result[i].Label
--     --     amount[i] = result[i].Current
--     --     middle[i] = result[i].Med

--     --     difference[i] = amount[i] - middle[i]
--     -- end

--     local stocks = {}

--     for k,v in pairs(result) do
--         local difference = v.Current - v.Med
--         table.insert(stocks, {libelle = v.Label, amount = v.Current, difference = difference})
--     end
--     -- for i=1, qnt, 1 do
--     --     local line = {libelle = name[i], amount = amount[i], difference = difference[i]}
--     --     table.insert(stocks, line)
--     -- end
--     return stocks
-- end

-- RegisterServerEvent('FNR:Generateamounts')
-- AddEventHandler('FNR:Generateamounts', function()

--     MySQL.Async.fetchAll('SELECT * FROM phone_stocks', {}, function(result)

--         for i=1, #result, 1 do

--             local id = result[i].ID

--             local nome = result[i].Name
--             local attuale = result[i].Current
--             local min = result[i].Min
--             local max = result[i].Max
--             local med = result[i].Med
    
--             local med = ((min + max) / 2)

--             local rnd = math.random(min, max)
    
--             MySQL.Async.execute('UPDATE phone_stocks SET Current=@RND , Med=@MED WHERE ID=@ID',{
--                 ['@RND'] = rnd,
--                 ['@MED'] = med,
--                 ['@ID'] = id
--             })
--         end

--     end)

--     local stocks = getBourse()
--     TriggerClientEvent('FNR:getBourse', -1, stocks)

-- end)

-- draCB.RegisterServerCallback('FNR:getStocks', function(source, name, cb)
--     local Name = name
--     MySQL.Async.fetchAll('SELECT * FROM phone_stocks WHERE Name=@Name', {['@Name'] = Name}, function(result)
--         local stock = result[1].Current
--         cb(stock)
--     end)
-- end)

--====================================================================================
--  App ... WIP
--====================================================================================


-- SendNUIMessage('onFNRRTC_receive_offer')
-- SendNUIMessage('onFNRRTC_receive_answer')

-- RegisterNUICallback('FNRRTC_send_offer', function (data)


-- end)


-- RegisterNUICallback('FNRRTC_send_answer', function (data)


-- end)



function onCallFixePhone (source, phone_number, rtcOffer, extraData)
    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = getNumberPhone(srcIdentifier)
    end

    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = false,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData,
        coords = FixePhone[phone_number].coords
    }
    
    PhoneFixeInfo[indexCall] = AppelsEnCours[indexCall]

    TriggerClientEvent('FNR:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('FNR:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
end



function onAcceptFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id
    
    AppelsEnCours[id].receiver_src = source
    if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
        AppelsEnCours[id].is_accepts = true
        AppelsEnCours[id].forceSaveAfter = true
        AppelsEnCours[id].rtcAnswer = rtcAnswer
        PhoneFixeInfo[id] = nil
        TriggerClientEvent('FNR:notifyFixePhoneChange', -1, PhoneFixeInfo)
        TriggerClientEvent('FNR:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
	SetTimeout(1000, function() -- change to +1000, if necessary.
       		TriggerClientEvent('FNR:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
	end)
        saveAppels(AppelsEnCours[id])
    end
end

function onRejectFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id
    PhoneFixeInfo[id] = nil
    TriggerClientEvent('FNR:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('FNR:rejectCall', AppelsEnCours[id].transmitter_src)
    if AppelsEnCours[id].is_accepts == false then
        saveAppels(AppelsEnCours[id])
    end
    AppelsEnCours[id] = nil
    
end

RegisterServerEvent('FNR:moneyTransfer')
AddEventHandler('FNR:moneyTransfer', function(num, amount)
    local source = source
    userid = vRP.getUserId({source})
    reciever = vRP.getUserSource({tonumber(num)})
    num = vRP.getUserId({reciever})
    if tonumber(amount) > vRP.getBankMoney({userid}) then return end
    if tostring(amount) == tostring(tonumber(amount)) then
        if num == nil then
            vRPclient.notify(source, {"~r~This ID does not exist/ is offline!"})
            TriggerClientEvent("FNR:PlaySound", source, 2)
        else
        
            if userid == tonumber(num) then 
                vRPclient.notify(source, {"~r~Unable to send money to yourself!"})
                TriggerClientEvent("FNR:PlaySound", source, 2)
            else
            
                if vRP.tryBankPayment({userid, tonumber(amount)}) then 
                    webhook = "https://discord.com/api/webhooks/1027267198324060301/xF4neFN_ErZS85HjfhkVitADAHd-Nevha9mjodkeozOUB5yeEsrwI7y1kDlaDI-Jzreb"
       
                    PerformHttpRequest(webhook, function(err, text, headers) 
                    end, "POST", json.encode({username = "FNR", embeds = {
                        {
                            ["color"] = "15158332",
                            ["title"] = "Money Sent",
                            ["description"] = "**Sender Name: **" .. GetPlayerName(source) .. "** \nUser ID: **" .. userid.. "** \nSent: **£" .. amount .. '**\nReciever ID: **' .. num,
                            ["footer"] = {
                                ["text"] = "Time - "..os.date("%x %X %p"),
                            }
                    }
                }}), { ["Content-Type"] = "application/json" })

                    vRPclient.notify(source, {"~g~Successfully transfered: ~w~£" .. amount .. " ~g~to ~r~[ID: ~w~" .. num .. " ~r~]"})
                    TriggerClientEvent("FNR:PlaySound", source, 1)
                    vRP.giveBankMoney({tonumber(num), tonumber(amount)})
                
                    vRPclient.notify(reciever, {"~g~You have recieved: ~w~£" .. amount .. "~g~ from ~w~".. vRP.getPlayerName({source}) .. " ~r~ ~n~ ~n~[ID: ~w~" .. userid .. " ~r~]"})
                    TriggerClientEvent("FNR:PlaySound", reciever, 1)
                
                    else 
                    vRPclient.notify(source, {"~r~You do not have enough money complete transaction 🤦‍♂️"})
                    TriggerClientEvent("FNR:PlaySound", source, 2)
                end
            end
        end
    else
        vRPclient.notify(source,{'~r~The value you entered is not a number!'})
    end
end)