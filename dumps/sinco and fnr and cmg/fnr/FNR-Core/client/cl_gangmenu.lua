--[[ RMenu.Add('gangmenu', 'main', RageUI.CreateMenu("", "FNR Gang Menu", 1300, 50, "banners", "gang"))
RMenu.Add("gangmenu", "funds", RageUI.CreateSubMenu(RMenu:Get("gangmenu", "main", 1300, 50)))
RMenu.Add("gangmenu", "invite", RageUI.CreateSubMenu(RMenu:Get("gangmenu", "main", 1300, 50)))
RMenu.Add("gangmenu", "members", RageUI.CreateSubMenu(RMenu:Get("gangmenu", "main", 1300, 50)))
--RMenu.Add("gangmenu", "logs", RageUI.CreateSubMenu(RMenu:Get("gangmenu", "main", 1300, 50)))
RMenu.Add("gangmenu", "leavegang", RageUI.CreateSubMenu(RMenu:Get("gangmenu", "main", 1300, 50)))
RMenu.Add("gangmenu", "disbandgang", RageUI.CreateSubMenu(RMenu:Get("gangmenu", "main", 1300, 50)))
RMenu.Add("gangmenu", "selectedmember", RageUI.CreateSubMenu(RMenu:Get("gangmenu", "members", 1300, 50)))
RMenu.Add("gangmenu", "updaterank", RageUI.CreateSubMenu(RMenu:Get("gangmenu", "selectedmember", 1300, 50)))
RMenu.Add("gangmenu", "confirminvite", RageUI.CreateSubMenu(RMenu:Get("gangmenu", "invite", 1300, 50)))


CreatedGangName = '[Name]'
CreatedGangLeader = '[Name]'
MembersPermInvIs = '[Perm ID]'

RegisterKeyMapping("gangmenu", "Open Gang Menu", "keyboard", "F5")

--AddEventHandler("RecieveGangInfo", function(ganginfo, gangmembers, myinfo, ganglogs, invites, ingang)
RegisterNetEvent("RecieveGangInfo")
AddEventHandler("RecieveGangInfo", function(ganginfo, gangmembers, myinfo, invites, ingang)
    IsInGang = ingang
    GangInfoTroll = ganginfo
    GangMemberTable = gangmembers
    MyInfoTroll = myinfo
    GangInvites = invites
    for k,v in pairs(GangInfoTroll) do
        GangName = v.gangname
        GangLeader = v.gangleader
        GangFunds = v.gangfunds 
    end
    for k,v in pairs(GangMemberTable) do
        MemberName = v.name
        MemberRank = v.rank
        MemberUserId = v.userid
        ActiveMembers = k
    end
    for k,v in pairs(MyInfoTroll) do
        MyName = v.name
        MyRank = v.rank
        MyGangName = v.gangname
        MyUserID = v.userid
    end
    DoesHaveInvites = json.encode(GangInvites)
    if DoesHaveInvites == '[]' then 
        GangInvites = 'No Invites'
    else
        GangInvites = GangInvites
    end
    if IsInGang == false then 
        RageUI.Visible(RMenu:Get('gangmenu', 'notingang'), not RageUI.Visible(RMenu:Get('gangmenu', 'notingang')))
    else
        RageUI.Visible(RMenu:Get('gangmenu', 'main'), not RageUI.Visible(RMenu:Get('gangmenu', 'main')))
    end
end)

local gangranks = {
    "Owner",
    "Enforcer",
    "Soldier",
    "Member",
    "Recruit",
}

RageUI.CreateWhile(1.0, RMenu:Get('gangmenu', 'main'), nil, function()
    RageUI.IsVisible(RMenu:Get('gangmenu', 'main'), true, false, true, function()
        RageUI.ButtonWithStyle("Gang Members", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            if Selected then
            end
        end, RMenu:Get('gangmenu', 'members'))

        RageUI.ButtonWithStyle("Gang Funds", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            if Selected then
            end
        end, RMenu:Get('gangmenu', 'funds'))

        if MyRank == "Owner" or MyRank == "Enforcer" then
            RageUI.ButtonWithStyle("Invite Members", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                if Selected then
                end
            end, RMenu:Get('gangmenu', 'invite'))
        end

        -- RageUI.ButtonWithStyle("Gang Logs", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
        --     if Selected then
        --     end
        -- end, RMenu:Get('gangmenu', 'logs'))

        RageUI.ButtonWithStyle("Leave Gang", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            if Selected then
            end
        end, RMenu:Get('gangmenu', 'leavegang'))

        if MyRank == "Owner" then
            RageUI.ButtonWithStyle("Disband the Gang", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                if Selected then
                end
            end, RMenu:Get('gangmenu', 'disbandgang'))
        end

        RageUI.Separator("~g~Gang Info", function() end)
        RageUI.Separator("Name: " ..GangName, function() end)
        RageUI.Separator("Funds: £" ..Comma(GangFunds), function() end)
        RageUI.Separator("Creator: " ..GangLeader, function() end)

    end)

    RageUI.IsVisible(RMenu:Get("gangmenu", "members"),true, false,true,function()
        RMenu:Get("gangmenu", "members"):SetSubtitle("Members Tab")
        for k,v in pairs(GangMemberTable) do 
            RageUI.ButtonWithStyle("Name: " ..v.name.. " | Rank: " ..v.rank, nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    SelectedMember = v
                end
            end, RMenu:Get('gangmenu', 'selectedmember'))
        end
    end)

    RageUI.IsVisible(RMenu:Get("gangmenu", "funds"),true, false,true,function()
        RMenu:Get("gangmenu", "funds"):SetSubtitle("Funds Tab")
        if MyRank == "Enforcer" or MyRank == "Owner" then
            RageUI.ButtonWithStyle("Withdraw", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local PedCoords = GetEntityCoords(PlayerPedId())
                    local legionbank = vector3(148.94, -1040.05, 29.38)
                    local cayobank = vector3(4477.373046875,-4465.1005859375,4.2407155036926)
                    if #(PedCoords - bank) < 10 or #(PedCoords - cayobank) < 10 then
                        TriggerServerEvent("WithdrawFunds")
                    end
                end
            end)
        end 
        RageUI.ButtonWithStyle("Deposit", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then
                local PedCoords = GetEntityCoords(PlayerPedId())
                local bank = vector3(148.94, -1040.05, 29.38)
                local cayobank = vector3(4477.373046875,-4465.1005859375,4.2407155036926)
                if #(PedCoords - bank) < 10 or #(PedCoords - cayobank) < 10 then
                    TriggerServerEvent("DepositFunds")
            
                end
            end
        end)
        RageUI.Separator("Gang Funds: £" ..Comma(GangFunds), function() end)
    end)

    RageUI.IsVisible(RMenu:Get("gangmenu", "invite"),true, false,true,function()
        RMenu:Get("gangmenu", "invite"):SetSubtitle("Invite Members!")
        RageUI.ButtonWithStyle("Perm ID - " .. MembersPermInvIs, nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then
                AddTextEntry('FMMC_MPM_NC', "Perm ID")
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    local memperm = GetOnscreenKeyboardResult()
                    if memperm then 
                        MembersPermInvIs = memperm
                    end
                end
            end
        end)
        RageUI.ButtonWithStyle("Confirm", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            if Selected then
                MembersPermToInv = MembersPermInvIs
            end
        end, RMenu:Get('gangmenu', 'confirminvite'))
    end)

    RageUI.IsVisible(RMenu:Get("gangmenu", "confirminvite"),true, false,true,function()
        wow = GangName
        wow2 = GangLeader
        RMenu:Get("gangmenu", "confirminvite"):SetSubtitle("Confirm Invite!")
        RageUI.Separator("Members Perm ID: " ..MembersPermToInv, function() end)

        RageUI.ButtonWithStyle("Are you sure you want to Confirm!", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent("MemberInvites", MembersPermToInv, wow, wow2)
            end
        end)
        RageUI.ButtonWithStyle("Cancel", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerEvent("closemenu")
                RageUI.Visible(RMenu:Get('gangmenu', 'invite'), not RageUI.Visible(RMenu:Get('gangmenu', 'main')))
            end
        end)
    end)

    -- RageUI.IsVisible(RMenu:Get("gangmenu", "logs"),true, false,true,function()
    --     RMenu:Get("gangmenu", "logs"):SetSubtitle("Logs Tab")
    --     RageUI.Separator("Coming Soon!", function() end)
    -- end)

    RageUI.IsVisible(RMenu:Get("gangmenu", "leavegang"),true, false,true,function()
        RMenu:Get("gangmenu", "leavegang"):SetSubtitle("Leave Gang!")
        RageUI.ButtonWithStyle("Are you sure you want to leave!", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then
                if ActiveMembers == 1 then 
                    Notify("Cannot leave gang as you are the last person")
                else
                    if MyRank == "Owner" then
                        Notify("Cant leave gang as you are the owner")
                    else
                        TriggerServerEvent("LeaveGang", MyName, MyRank, MyUserID)
                    end
                end
            end
        end)
        RageUI.ButtonWithStyle("Cancel Leaving", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then
                RageUI.Visible(RMenu:Get('gangmenu', 'main'), not RageUI.Visible(RMenu:Get('gangmenu', 'main')))
            end
        end)
    end)

    RageUI.IsVisible(RMenu:Get("gangmenu", "selectedmember"),true, false,true,function()
        RMenu:Get("gangmenu", "selectedmember"):SetSubtitle("Name: " ..SelectedMember.name.. " Rank: " ..SelectedMember.rank)
        if MyRank == "Owner" then 
            RageUI.ButtonWithStyle("Update Rank", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                end
            end, RMenu:Get('gangmenu', 'updaterank'))
        end
        if MyRank == "Enforcer" or MyRank == "Owner" then
            RageUI.ButtonWithStyle("Kick", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    if MyName == SelectedMember.name then
                        Notify("Cannot Kick yourself")
                    else 
                        TriggerServerEvent("KickPlayer", SelectedMember.name, SelectedMember.rank, SelectedMember.userid)
                    end
                end
            end)
        end
    end)

    RageUI.IsVisible(RMenu:Get("gangmenu", "updaterank"),true, false,true,function()
        RMenu:Get("gangmenu", "updaterank"):SetSubtitle("Name: " ..SelectedMember.name.. " Rank: " ..SelectedMember.rank)
        for k,v in pairs(gangranks) do
            RageUI.ButtonWithStyle(v, nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    if SelectedMember.rank == v then
                        Notify("They already have this rank!")
                    else
                        TriggerServerEvent("UpdateRank", SelectedMember.name, SelectedMember.rank, v, SelectedMember.userid)
                    end
                end
            end)
        end
    end)

    RageUI.IsVisible(RMenu:Get("gangmenu", "disbandgang"),true, false,true,function()
        RMenu:Get("gangmenu", "disbandgang"):SetSubtitle("Disband Gang!")
        RageUI.ButtonWithStyle("Are you sure you want to Disband!", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if ActiveMembers == 1 then 
                if Selected then
                    TriggerServerEvent("DisbandGang", GangName, GangLeader, GangFunds, MemberName, MemberUserId)
                end
            else 
                Notify("There are more people in the gang, you need to be the only one!")
            end
        end)
        RageUI.ButtonWithStyle("Cancel Disbanding", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then
                RageUI.Visible(RMenu:Get('gangmenu', 'main'), not RageUI.Visible(RMenu:Get('gangmenu', 'main')))
            end
        end)
    end)
end)

  
RegisterCommand("gangmenu", function()
    TriggerServerEvent("GetGangInfo")
end)


RMenu.Add('gangmenu', 'notingang', RageUI.CreateMenu("", "Create Gang", 1300, 50, "gang", "gang"))
RMenu.Add("gangmenu", "creategang", RageUI.CreateSubMenu(RMenu:Get("gangmenu", "notingang", 1300, 50)))
RMenu.Add("gangmenu", "joingang", RageUI.CreateSubMenu(RMenu:Get("gangmenu", "notingang", 1300, 50)))
RMenu.Add("gangmenu", "confirmgang", RageUI.CreateSubMenu(RMenu:Get("gangmenu", "creategang", 1300, 50)))
RMenu.Add("gangmenu", "joingangconfirm", RageUI.CreateSubMenu(RMenu:Get("gangmenu", "joingang", 1300, 50)))

RageUI.CreateWhile(1.0, RMenu:Get('gangmenu', 'creategang'), nil, function()
    RageUI.IsVisible(RMenu:Get('gangmenu', 'notingang'), true, false, true, function()

        RageUI.ButtonWithStyle("Create Gang", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
            if Selected then
            end
        end, RMenu:Get('gangmenu', 'creategang'))

        RageUI.ButtonWithStyle("Join Gang", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
            if Selected then
            end
        end, RMenu:Get('gangmenu', 'joingang'))

    end)


    RageUI.IsVisible(RMenu:Get("gangmenu", "joingang"),true, false,true,function()
        RMenu:Get("gangmenu", "joingang"):SetSubtitle("Join A Gang!")
        RageUI.Separator("Gang Invites:", function() end)
        if GangInvites == "No Invites" then 
            RageUI.Separator("None", function() end)
        else 
            for k,v in pairs(GangInvites) do
                RageUI.ButtonWithStyle('Gang Name: ' ..v.gangname, "", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        GangNameToJoin = v.gangname 
                        GangLeaderToJoin = v.gangleader
                        GangPersonInvitedBy = v.personinvitedby
                        UserIDinDatabase = v.userid
                    end
                end, RMenu:Get('gangmenu', 'joingangconfirm'))
            end
        end
    end)

    RageUI.IsVisible(RMenu:Get("gangmenu", "joingangconfirm"),true, false,true,function()
        RageUI.Separator("Gang Name: " ..GangNameToJoin, function() end)
        RageUI.Separator("Gang Leader: " ..GangLeaderToJoin, function() end)
        RageUI.Separator("Invited By: " ..GangPersonInvitedBy, function() end)

        swag = GangNameToJoin
        swag2 = GangLeaderToJoin
        swag3 = GangPersonInvitedBy
        id = UserIDinDatabase
        RageUI.ButtonWithStyle("Are you sure you want to join this gang!", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent("joininggang", swag, swag2, swag3, id)
            end
        end)
        RageUI.ButtonWithStyle("Cancel joining", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerEvent("closemenu")
                RageUI.Visible(RMenu:Get('gangmenu', 'joingang'), not RageUI.Visible(RMenu:Get('gangmenu', 'main')))
            end
        end)
    end)


    RageUI.IsVisible(RMenu:Get('gangmenu', 'creategang'), true, false, true, function()
        RageUI.ButtonWithStyle("Gang Name - " .. CreatedGangName, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            if Selected then
                AddTextEntry('FMMC_MPM_NA', "Enter Gang Name")
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter Gang Name", "", "", "", "", 30)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    local result = GetOnscreenKeyboardResult()
                    if result then
                        CreatedGangName = result
                        notify('~g~You have set the gang name as: ~w~[' .. CreatedGangName .. ']')
                    end
                end

            end
        end)

        RageUI.ButtonWithStyle("Your Name - " .. CreatedGangLeader, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            if Selected then
                AddTextEntry('FMMC_MPM_NA', "Enter Gang Leader (Your Name)")
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter Gang Leader (Your Name)", "", "", "", "", 30)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    local result = GetOnscreenKeyboardResult()
                    if result then
                        CreatedGangLeader = result
                    end
                end
            end
        end)
        if CreatedGangLeader ~= '[Name]' and CreatedGangName ~= '[Name]' then
            RageUI.ButtonWithStyle("Confirm", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                if Selected then

                    Leader = CreatedGangLeader
                    Name = CreatedGangName
                end
            end, RMenu:Get('gangmenu', 'confirmgang'))
        end
    end)

    RageUI.IsVisible(RMenu:Get("gangmenu", "confirmgang"),true, false,true,function()
        RMenu:Get("gangmenu", "confirmgang"):SetSubtitle("Confirm Gang!")
        RageUI.Separator("Gang Name: " ..Name, function() end)
        RageUI.Separator("Gang Leader: " ..Leader, function() end)

        RageUI.ButtonWithStyle("Are you sure you want to Confirm!", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent("creategang", Name, Leader)
            end
        end)
        RageUI.ButtonWithStyle("Cancel Disbanding", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerEvent("closemenu")
                RageUI.Visible(RMenu:Get('gangmenu', 'creategang'), not RageUI.Visible(RMenu:Get('gangmenu', 'main')))
            end
        end)
    end)
end)

RegisterNetEvent("closemenu")
AddEventHandler("closemenu", function()
    RageUI.CloseAll()
end)

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end



function Notify(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(0,1)
end

function Comma(amount)
    local formatted = amount
    while true do  
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k==0) then
        break
      end
    end
    return formatted
end ]]