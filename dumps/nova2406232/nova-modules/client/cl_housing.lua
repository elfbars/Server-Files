tNOVA = Proxy.getInterface("NOVA")

local Housing = module("nova-modules", "cfg/cfg_homes")

local inHome = false
local isInMenu = false
local isInLeaveMenu = false
local isInWardrobeMenu = false
local currentHome = nil
local currentOutfit = nil
local currentHousePrice = 0
local owned = false
wardrobe = {}
ownedHouses = {}

RMenu.Add("NOVAhousing", "main", RageUI.CreateMenu("", "", 1350, 50,"banners","housing"))
RMenu.Add("NOVAhousing", "leave", RageUI.CreateMenu("", "", 1350, 50,"banners","housing"))
RMenu.Add("NOVAhousing", "wardrobe", RageUI.CreateMenu("", "~b~Wardrobe", 1350, 50,"banners","cstore"))
RMenu.Add("NOVAhousing", "wardrobesub", RageUI.CreateSubMenu(RMenu:Get("NOVAhousing", "wardrobe"), "", "~b~Wardrobe", 1350, 50,"banners","cstore"))

RageUI.CreateWhile(1.0, RMenu:Get("NOVAhousing", "main"), nil, function()

    --Enter Menu
    maxKG = Housing.chestsize[currentHome] or 500
    RageUI.IsVisible(RMenu:Get("NOVAhousing", "main"), true, false, true, function()
        RageUI.Separator('Price: ~g~£'..getMoneyStringFormatted(currentHousePrice))
        RageUI.Separator('Storage: ~g~'..maxKG..'kg')
        RageUI.Button("Enter Home/Doorbell", nil, {RightLabel = ">>>"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent("NOVAhousing:Enter", currentHome)
            end
        end)
        if owned ~= true then
            RageUI.Button("~g~Buy Home", nil, {RightLabel = ">>>"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("NOVAhousing:Buy", currentHome)
                end
            end)
        end

        RageUI.Button("~r~Sell Home", nil, {RightLabel = ">>>"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent("NOVAhousing:Sell", currentHome)
            end
        end)

    end, function()
    end)

    --Leave Menu

    RageUI.IsVisible(RMenu:Get("NOVAhousing", "leave"), true, false, true, function()

        RageUI.Button("Leave Home", nil, {RightLabel = ">>>"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent("NOVAhousing:Leave", currentHome)
            end
        end)

    end, function()
    end)

    --Wardrobe Main Menu

    RageUI.IsVisible(RMenu:Get("NOVAhousing", "wardrobe"), true, false, true, function()

        for k, v in pairs(wardrobe) do
            RageUI.Button(k, nil, {RightLabel = ">>>"}, true, function(Hovered, Active, Selected)
                if Selected then
                    currentOutfit = k
                    savedArmour = GetPedArmour(PlayerPedId())
                end
            end, RMenu:Get("NOVAhousing", "wardrobesub"))
        end

        RageUI.Button("~g~Save Outfit", nil, {RightLabel = ">>>"}, true, function(Hovered, Active, Selected)
            if Selected then
                AddTextEntry("FMMC_MPM_NC", "Outfit Name")
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    local result = GetOnscreenKeyboardResult()
                    if result then
                        TriggerServerEvent("NOVAhousing:SaveOutfit", result)
                    end
                end
            end
        end)

    end, function()
    end)

    --Wardrobe Sub Menu

    RageUI.IsVisible(RMenu:Get("NOVAhousing", "wardrobesub"), true, false, true, function()

        RageUI.Button("~g~Equip Outfit", nil, {RightLabel = ">>>"}, true, function(Hovered, Active, Selected)
            if Selected then
                for k, v in pairs(wardrobe) do
                    if k == currentOutfit then
                        tNOVA.setCustomization({v})
                        
                        SetTimeout(50, function()
                            SetPedArmour(PlayerPedId(), savedArmour)
                            TriggerServerEvent('NOVA:changeHairStyle')
                        end)
                    end
                end
            end
        end, RMenu:Get("NOVAhousing", "wardrobe"))

        RageUI.Button("~r~Remove Outfit", nil, {RightLabel = ">>>"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent("NOVAhousing:RemoveOutfit", currentOutfit)
            end
        end, RMenu:Get("NOVAhousing", "wardrobe"))

    end, function()
    end)
end)

--Thread






Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if not HasStreamedTextureDictLoaded("clothing") then
            RequestStreamedTextureDict("clothing", true)
            while not HasStreamedTextureDictLoaded("clothing") do
                Wait(1)
            end
        end

        for k, v in pairs(cfghomes.homes) do
            --Enter Home

            -- for a,b in pairs(ownedHouses) do


            if isInArea(v.entry_point, 100) then
                DrawMarker(20, v.entry_point, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 25, 100, false, true, 2, false)
            end

            if isInArea(v.entry_point, 0.8) and isInMenu == false then 
                currentHome = k
                currentHousePrice = v.buy_price
                RMenu:Get("NOVAhousing", "main"):SetSubtitle("~b~" .. currentHome)
                RageUI.Visible(RMenu:Get("NOVAhousing", "main"), true)
                isInMenu = true
            end

            if isInArea(v.entry_point, 0.8) == false and isInMenu and currentHome == k then
                RageUI.Visible(RMenu:Get("NOVAhousing", "main"), false)
                isInMenu = false
            end

            if currentHome == k then

                --Chest

                if inHome then
                    DrawMarker(9, v.chest_point, 0.0, 0.0, 0.0, 90.0, 0.0, 0.0, 0.8, 0.8, 0.8, 224, 224, 244, 1.0, false, false, 2, true, "dp_clothing", "bag", false)
                end

                if isInArea(v.chest_point, 0.8) and inHome then
                    alert("~y~Press ~INPUT_VEH_HORN~ To Open House Chest!")
                    if IsControlJustPressed(0, 51) then
                        TriggerServerEvent("NOVAhousing:OpenChest", currentHome)
                    end
                end

                --Wardrobe

                if inHome then
                    DrawMarker(9, v.wardrobe_point, 0.0, 0.0, 0.0, 90.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 0, 255, 60, false, true, 2, false, "clothing", "clothing", false)
                end

                if isInArea(v.wardrobe_point, 0.8) and isInWardrobeMenu == false and inHome then
                    TriggerServerEvent("NOVAhousing:LoadWardrobe")
                    currentHome = k
                    RageUI.Visible(RMenu:Get("NOVAhousing", "wardrobe"), true)
                    isInWardrobeMenu = true
                end

                if isInArea(v.wardrobe_point, 0.8) == false and isInWardrobeMenu and currentHome == k and inHome then
                    RageUI.Visible(RMenu:Get("NOVAhousing", "wardrobe"), false)
                    isInWardrobeMenu = false
                end

                --Leave Home

                if inHome then
                    DrawMarker(20, v.leave_point, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 25, 100, false, true, 2, false)
                end

                if isInArea(v.leave_point, 0.8) and isInLeaveMenu == false and inHome then
                    currentHome = k
                    RMenu:Get("NOVAhousing", "leave"):SetSubtitle("~b~" .. currentHome)
                    RageUI.Visible(RMenu:Get("NOVAhousing", "leave"), true)
                    isInLeaveMenu = true
                end

                if isInArea(v.leave_point, 0.8) == false and isInLeaveMenu and currentHome == k and inHome then
                    RageUI.Visible(RMenu:Get("NOVAhousing", "leave"), false)
                    isInLeaveMenu = false
                   
                end
            end
        end
    end
end)


Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
     if inHome then
         NetworkConcealPlayer(GetPlayerPed(-1), true, false)
    else 
         NetworkConcealPlayer(GetPlayerPed(-1), false, false)
      end
   end
end)


RegisterNetEvent("NOVAhousing:UpdateInHome")
AddEventHandler("NOVAhousing:UpdateInHome", function(inTheHome)
    inHome = inTheHome
end)

RegisterNetEvent("NOVAhousing:UpdateWardrobe")
AddEventHandler("NOVAhousing:UpdateWardrobe", function(newWardrobe)
    wardrobe = newWardrobe
end)

-- RegisterNetEvent("printownedhouses")
-- AddEventHandler("printownedhouses", function(test)
--     ownedHouses = test
--     for k,v in pairs(ownedHouses) do
--     print(k)
--     end
-- end)


function alert(msg) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end

function isInArea(v, dis) 
    if #(GetEntityCoords(PlayerPedId()) - v) <= dis then  
        return true
    else 
        return false
    end
end