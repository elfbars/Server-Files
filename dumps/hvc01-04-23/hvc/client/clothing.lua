RMenu.Add('ClothingStore', 'main', RageUI.CreateMenu("", "~b~Clothing Menu", 1300,100, "banner", "ClothingStore"))
RMenu.Add('ClothingStore', 'clothingsubmenu',  RageUI.CreateSubMenu(RMenu:Get("ClothingStore", "main")))
RMenu.Add('ClothingStore', 'hair',  RageUI.CreateSubMenu(RMenu:Get("ClothingStore", "clothingsubmenu")))
RMenu.Add('ClothingStore', 'changegendersubmenu',  RageUI.CreateSubMenu(RMenu:Get("ClothingStore", "main")))
RMenu.Add('ClothingStore', 'changepedmenu',  RageUI.CreateSubMenu(RMenu:Get("ClothingStore", "main")))
local Face = {Max = {}, Index = 0, TextureIndex = 0};
local Mask = {Max = {}, Index = 0, TextureIndex = 0};
local Hair = {Max = {}, Index = 0, TextureIndex = 0};
local Torso = {Max = {}, Index = 0, TextureIndex = 0};
local Legs =  {Max = {}, Index = 0, TextureIndex = 0};
local Parachute = {Max = {}, Index = 0, TextureIndex = 0};
local Shoes = {Max = {}, Index = 0, TextureIndex = 0};
local Accessory = {Max = {}, Index = 0, TextureIndex = 0};
local Undershirt = {Max = {}, Index = 0, TextureIndex = 0};
local Kevlar = {Max = {}, Index = 0, TextureIndex = 0}; 
local Badge = {Max = {}, Index = 0, TextureIndex = 0};
local Torso2 = {Max = {}, Index = 0, TextureIndex = 0};
local Hats = {Max = {}, Index = 0, TextureIndex = 0};
local Glasses = {Max = {}, Index = 0, TextureIndex = 0};
local Earings = {Max = {}, Index = 0, TextureIndex = 0};
local Watches = {Max = {}, Index = 0, TextureIndex = 0};
local Bracelets = {Max = {}, Index = 0, TextureIndex = 0};
local SelectedOption = nil;
local MenuOpen = false;

local PlayerData = nil

Peds = {
	'g_m_y_lost_01',
	'g_m_y_lost_02',
	'g_m_y_lost_03',
	'a_f_m_bevhills_01',
	'a_f_m_fatbla_01',
	'a_f_m_fatwhite_01',
	'a_f_m_soucentmc_01',
	'a_f_m_soucent_01',
	'a_f_m_soucent_02',
	'a_f_m_tourist_01',
	'a_f_m_prolhost_01',
	'a_f_m_skidrow_01',
	'a_f_o_indian_01',
	'a_f_y_bevhills_01',
	'a_f_y_bevhills_02',
	'a_f_y_bevhills_03',
	'a_f_y_bevhills_04',
	'a_f_y_business_01',
	'a_f_y_business_02',
	'a_f_y_business_03',
	'a_f_y_business_04',
	'a_f_y_eastsa_01',
	'a_f_y_eastsa_02',
	'a_f_y_eastsa_03',
	'a_f_y_epsilon_01',
	'a_f_y_fitness_01',
	'a_f_y_fitness_02',
	'a_f_y_genhot_01',
	'a_f_y_golfer_01',
	'a_f_y_hiker_01',
	'a_f_y_hippie_01',
	'a_f_y_indian_01',
	'a_f_y_juggalo_01',
	'a_f_y_runner_01',
	'a_f_y_rurmeth_01',
	'a_f_y_scdressy_01',
	'a_f_y_skater_01',
	'a_f_y_soucent_01',
	'a_f_y_soucent_02',
	'a_f_y_soucent_03',
	'a_f_y_tennis_01',
	'a_f_y_tourist_01',
	'a_f_y_tourist_02',
	'a_f_y_vinewood_01',
	'a_f_y_vinewood_02',
	'a_f_y_vinewood_03',
	'a_f_y_vinewood_04',
	'a_f_y_yoga_01',
	'a_m_m_afriamer_01',
	'a_m_m_beach_01',
	'a_m_m_bevhills_01',
	'a_m_m_bevhills_02',
	'a_m_m_business_01',
	'a_m_m_eastsa_01',
	'a_m_m_eastsa_02',
	'a_m_m_farmer_01',
	'a_m_m_fatlatin_01',
	'a_m_m_genfat_01',
	'a_m_m_genfat_02',
	'a_m_m_golfer_01',
	'a_m_m_hasjew_01',
	'a_m_m_hillbilly_01',
	'a_m_m_hillbilly_02',
	'a_m_m_indian_01',
	'a_m_m_ktown_01',
	'a_m_m_malibu_01',
	'a_m_m_mexcntry_01',
	'a_m_m_mexlabor_01',
	'a_m_m_og_boss_01',
	'a_m_m_paparazzi_01',
	'a_m_m_polynesian_01',
	'a_m_m_prolhost_01',
	'a_m_m_rurmeth_01',
	'a_m_m_salton_01',
	'a_m_m_salton_02',
	'a_m_m_salton_03',
	'a_m_m_salton_03',
	'a_m_m_skater_01',
	'a_m_m_skidrow_01',
	'a_m_m_socenlat_01',
	'a_m_m_soucent_01',
	'a_m_m_soucent_02',
	'a_m_m_soucent_03',
	'a_m_m_soucent_04',
	'a_m_m_stlat_02',
	'a_m_m_tennis_01',
	'a_m_m_tourist_01',
	'a_m_m_trampbeac_01',
	'a_m_m_tramp_01',
	'a_m_m_tramp_01',
	'a_m_o_acult_02',
	'a_m_o_beach_01',
	'a_m_o_genstreet_01',
	'a_m_o_ktown_01',
	'a_m_o_salton_01',
	'a_m_o_soucent_01',
	'a_m_o_soucent_02',
	'a_m_o_soucent_03',
	'a_m_o_tramp_01',
	'a_m_y_beachvesp_01',
	'a_m_y_beachvesp_02',
	'a_m_y_beach_01',
	'a_m_y_beach_02',
	'a_m_y_beach_03',
	'a_m_y_bevhills_01',
	'a_m_y_bevhills_02',
	'a_m_y_breakdance_01',
	'a_m_y_busicas_01',
	'a_m_y_business_01',
	'a_m_y_business_02',
	'a_m_y_business_03',
	'a_m_y_cyclist_01',
	'a_m_y_dhill_01',
	'a_m_y_downtown_01',
	'a_m_y_eastsa_01',
	'a_m_y_eastsa_02',
	'a_m_y_epsilon_01',
	'a_m_y_epsilon_02',
	'a_m_y_gay_01',
	'a_m_y_gay_02',
	'a_m_y_genstreet_01',
	'a_m_y_genstreet_02',
	'a_m_y_golfer_01',
	'a_m_y_hasjew_01',
	'a_m_y_hiker_01',
	'a_m_y_hippy_01',
	'a_m_y_indian_01',
	'a_m_y_jetski_01',
	'a_m_y_juggalo_01',
	'a_m_y_ktown_01',
	'a_m_y_ktown_02',
	'a_m_y_latino_01',
	'a_m_y_methhead_01',
	'a_m_y_mexthug_01',
	'a_m_y_motox_01',
	'a_m_y_motox_02',
	'a_m_y_musclbeac_02',
	'a_m_y_polynesian_01',
	'a_m_y_roadcyc_01',
	'a_m_y_runner_01',
	'a_m_y_runner_02',
	'a_m_y_salton_01',
	'a_m_y_skater_01',
	'a_m_y_skater_02',
	'a_m_y_soucent_01',
	'a_m_y_soucent_02',
	'a_m_y_soucent_03',
	'a_m_y_soucent_04',
	'a_m_y_stbla_01',
	'a_m_y_stbla_02',
	'a_m_y_stlat_01',
	'a_m_y_stwhi_01',
	'a_m_y_stwhi_02',
	'a_m_y_sunbathe_01',
	'a_m_y_vindouche_01',
	'a_m_y_vinewood_01',
	'a_m_y_vinewood_02',
	'a_m_y_vinewood_03',
	'a_m_y_vinewood_04',
	'a_m_y_yoga_01',
	'csb_abigail',
	'csb_anita',
	'csb_anton',
	'csb_ballasog',
	'csb_car3guy1',
	'csb_car3guy2',
	'csb_chin_goon',
	'csb_cletus',
	'csb_customer',
	'csb_denise_friend',
	'csb_fos_rep',
	'csb_groom',
	'csb_grove_str_dlr',
	'csb_g',
	'csb_hao',
	'csb_hugh',
	'csb_imran',
	'csb_janitor',
	'csb_ortega',
	'csb_oscar',
	'csb_porndudes',
	'csb_prologuedriver',
	'csb_ramp_gang',
	'csb_ramp_hic',
	'csb_ramp_mex',
	'csb_reporter',
	'csb_roccopelosi',
	'csb_screen_writer',
	'csb_stripper_01',
	'csb_tonya',
	'g_f_y_ballas_01',
	'g_f_y_families_01',
	'g_f_y_families_01',
	'g_f_y_vagos_01',
	'g_m_m_armboss_01',
	'g_m_m_armgoon_01',
	'g_m_m_armlieut_01',
	'g_m_m_chiboss_01',
	'g_m_m_chicold_01',
	'g_m_m_chigoon_01',
	'g_m_m_chigoon_02',
	'g_m_m_korboss_01',
	'g_m_m_mexboss_01',
	'g_m_m_mexboss_02',
	'g_m_y_armgoon_02',
	'g_m_y_azteca_01',
	'g_m_y_ballaeast_01',
	'g_m_y_ballaorig_01',
	'g_m_y_ballasout_01',
	'g_m_y_famca_01',
	'g_m_y_famdnf_01',
	'g_m_y_famfor_01',
	'g_m_y_korean_01',
	'g_m_y_korean_02',
	'g_m_y_korlieut_01',
	'g_m_y_mexgang_01',
	'g_m_y_mexgoon_01',
	'g_m_y_mexgoon_02',
	'g_m_y_mexgoon_03',
	'g_m_y_pologoon_01',
	'g_m_y_pologoon_02',
	'g_m_y_salvaboss_01',
	'g_m_y_salvagoon_01',
	'g_m_y_salvagoon_02',
	'g_m_y_salvagoon_03',
	'g_m_y_strpunk_01',
	'g_m_y_strpunk_02',
	'ig_abigail',
	'ig_ashley',
	'ig_bankman',
	'ig_barry',
	'ig_bestmen',
	'ig_beverly',
	'ig_car3guy1',
	'ig_car3guy2',
	'ig_chengsr',
	'ig_claypain',
	'ig_clay',
	'ig_cletus',
	'ig_dale',
	'ig_dreyfuss',
	'ig_hao',
	'ig_hunter',
	'ig_jewelass',
	'ig_jimmyboston',
	'ig_joeminuteman',
	'ig_josef',
	'ig_josh',
	'ig_kerrymcintosh',
	'ig_lifeinvad_01',
	'ig_lifeinvad_02',
	'ig_magenta',
	'ig_manuel',
	'ig_marnie',
	'ig_maryann',
	'ig_natalia',
	'ig_nigel',
	'ig_old_man1a',
	'ig_old_man2',
	'ig_oneil',
	'ig_paper',
	'ig_priest',
	'ig_ramp_gang',
	'ig_roccopelosi',
	's_f_y_bartender_01',
	's_f_y_hooker_01',
	's_f_y_hooker_02',
	's_f_y_hooker_03',
	's_f_y_shop_low',
	's_f_y_shop_mid',
	's_m_m_autoshop_01',
	's_m_m_autoshop_02',
	's_m_m_bouncer_01',
	's_m_m_hairdress_01',
	's_m_m_highsec_01',
	's_m_m_highsec_02',
	's_m_m_lifeinvad_01',
	's_m_m_mariachi_01',
	's_m_m_movprem_01',
	's_m_m_trucker_01',
	's_m_o_busker_01',
	's_m_y_barman_01',
	's_m_y_dealer_01',
	's_m_y_devinsec_01',
	's_m_y_robber_01',
	's_m_y_strvend_01',
	's_m_y_shop_mask',
	's_m_y_valet_01',
	's_m_y_winclean_01',
	's_m_y_xmech_01',
	's_m_y_xmech_02',
	'u_f_m_miranda',
	'u_f_y_bikerchic',
	'u_f_y_comjane',
	'u_f_y_hotposh_01',
	'u_f_y_jewelass_01',
	'u_f_y_mistress',
	'u_f_y_poppymich',
	'u_m_m_aldinapoli',
	'u_m_m_filmdirector',
	'u_m_m_griff_01',
	'u_m_m_jesus_01',
	'u_m_m_partytarget',
	'u_m_m_promourn_01',
	'u_m_m_rivalpap',
	'u_m_m_spyactor',
	'u_m_m_willyfist',
	'u_m_o_finguru_01',
	'u_m_o_taphillbilly',
	'u_m_o_tramp_01',
	'u_m_y_antonb',
	'u_m_y_cyclist_01',
	'u_m_y_fibmugger_01',
	'u_m_y_guido_01',
	'u_m_y_gunvend_01',
	'u_m_y_hippie_01',
	'u_m_y_mani',
	'u_m_y_militarybum',
	'u_m_y_paparazzi',
	'u_m_y_party_01',
	'u_m_y_proldriver_01',
	'u_m_y_sbike',
	'u_m_y_tattoo_01'
}



function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end


RageUI.CreateWhile(1.0,RMenu:Get("ClothingStore", "main"),nil,function()
    RageUI.IsVisible(RMenu:Get("ClothingStore", "main"),true, false,true,function()
        RageUI.ButtonWithStyle("Change Clothing", "", {}, true, function(Hovered, Active, Selected) end, RMenu:Get("ClothingStore", "clothingsubmenu"))
        RageUI.ButtonWithStyle("Change Gender", "", {}, true, function(Hovered, Active, Selected) end, RMenu:Get("ClothingStore", "changegendersubmenu"))
        RageUI.ButtonWithStyle("Change Ped", nil, {}, false, function(Hovered, Active, Selected) end, RMenu:Get("ClothingStore", "changepedmenu"))
    end)

    RageUI.IsVisible(RMenu:Get("ClothingStore", "changegendersubmenu"),true, false,true,function()
        RageUI.ButtonWithStyle("Female", "", {}, true, function(Hovered, Active, Selected) 
            if Selected then 
                local Ped = PlayerPedId()
                local Health = GetEntityHealth(PlayerPedId())
                local Armour = GetPedArmour(Ped)
                if GetEntityHealth(PlayerPedId()) > 102 then
                    local model = GetHashKey('mp_f_freemode_01')
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        RequestModel(model)
                        Citizen.Wait(0)
                    end
                    SetPlayerModel(PlayerId(), model)
                    local NewPed = PlayerPedId()
                    SetEntityHealth(NewPed,Health)
                    SetPedArmour(NewPed, Armour)
                    SetPedComponentVariation(NewPed, 0, 0, 0, 2) 
                    TriggerServerEvent("HVC:applyBarberData")
                else
                    notify("~r~You cannot change gender while dead.")
                end
            end
        end,RMenu:Get("ClothingStore", "changegendersubmenu"))
        RageUI.ButtonWithStyle("Male", "", {}, true, function(Hovered, Active, Selected) 
            if Selected then
                local Ped = PlayerPedId()
                local Health = GetEntityHealth(Ped)
                local Armour = GetPedArmour(Ped)
                if GetEntityHealth(Ped) > 102 then
                    local model = GetHashKey('mp_m_freemode_01')
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        RequestModel(model)
                        Citizen.Wait(0)
                    end
                    ExecuteCommand('storeweapons') 
                    Wait(500)
                    SetPlayerModel(PlayerId(), model)
                    local NewPed = PlayerPedId()
                    SetEntityHealth(NewPed,Health)
                    SetPedArmour(NewPed, Armour)
                    SetPedComponentVariation(NewPed, 0, 0, 0, 2) 
                    TriggerServerEvent("HVC:applyBarberData")
                else
                    notify("~r~You cannot change gender while dead.")
                end
            end
        end)
    end)

    RageUI.IsVisible(RMenu:Get("ClothingStore", "changepedmenu"),true, false,true,function()
        for k,v in pairs(Peds) do
		    RageUI.ButtonWithStyle(v, "", { RightLabel = "" }, true, function(Hovered, Active, Selected)
                if Selected then
                    local hash = GetHashKey(v)
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do      
                        RequestModel(hash)
                        Citizen.Wait(0)
                    end	
                    ExecuteCommand('storeweapons') 
                    Wait(500)
                    SetPlayerModel(PlayerId(), hash)
                    SetEntityHealth(PlayerPedId(), 200) 
                end
			end)
        end      
    end)

    RageUI.IsVisible(RMenu:Get("ClothingStore", "clothingsubmenu"),true, false,true,function()
        DrawMissionText('Press [SPACE] to input an ID')
        if IsControlJustPressed(0, 203) then 
            AddTextEntry('FMMC_MPM_NA', "Enter Clothing ID")
            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
            while (UpdateOnscreenKeyboard() == 0) do
                DisableAllControlActions(0);
                Wait(0);
            end
            if (GetOnscreenKeyboardResult()) then
                local result = GetOnscreenKeyboardResult()
                local ped = PlayerPedId()
                if tonumber(SelectedOption) then 
                SetPedComponentVariation(ped, SelectedOption, tonumber(result), 0, 0)
                elseif SelectedOption == "hats" then
                    SetPedPropIndex(PlayerPedId(), 0, tonumber(result), Hats.TextureIndex, 0)
                elseif SelectedOption == "glasses" then 
                    SetPedPropIndex(PlayerPedId(), 1, tonumber(result), Glasses.TextureIndex, 0)
                elseif SelectedOption == "earings" then
                    SetPedPropIndex(PlayerPedId(), 2, tonumber(result), Earings.TextureIndex, 0) 
                elseif SelectedOption == "watches" then 
                    SetPedPropIndex(PlayerPedId(), 6, tonumber(result), Watches.TextureIndex, 0)
                elseif SelectedOption == "bracelets" then 
                    SetPedPropIndex(PlayerPedId(), 7, tonumber(result), Bracelets.TextureIndex, 0)
                end
                Mask.Index = GetPedDrawableVariation(ped, 1)
                Mask.TextureIndex = GetPedTextureVariation(ped, 1)
                Torso.Index = GetPedDrawableVariation(ped, 3)
                Torso.TextureIndex = GetPedTextureVariation(ped, 3)
                Legs.Index = GetPedDrawableVariation(ped, 4)
                Legs.TextureIndex = GetPedTextureVariation(ped, 4)
                Parachute.Index = GetPedDrawableVariation(ped, 5)
                Parachute.TextureIndex = GetPedTextureVariation(ped, 5)
                Shoes.Index = GetPedDrawableVariation(ped, 6)
                Shoes.TextureIndex = GetPedTextureVariation(ped, 6)
                Accessory.Index = GetPedDrawableVariation(ped, 7)
                Accessory.TextureIndex = GetPedTextureVariation(ped, 7)
                Undershirt.Index = GetPedDrawableVariation(ped, 8)
                Undershirt.TextureIndex = GetPedTextureVariation(ped, 8)
                Kevlar.Index = GetPedDrawableVariation(ped, 9)
                Kevlar.TextureIndex = GetPedTextureVariation(ped, 9)
                Badge.Index = GetPedDrawableVariation(ped, 10)
                Badge.TextureIndex = GetPedTextureVariation(ped, 10)
                Torso2.Index = GetPedDrawableVariation(ped, 11)
                Torso2.TextureIndex = GetPedTextureVariation(ped, 11)
                Hats.Index = GetNumberOfPedPropDrawableVariations(ped, 0)
                Glasses.Index = GetPedPropIndex(ped, 1)
                Earings.Index = GetPedPropIndex(ped, 2)
                Watches.Index = GetPedPropIndex(ped, 6)
                Bracelets.Index = GetPedPropIndex(ped, 7)
            end
        end

        RageUI.List("Mask", Mask.Max, Mask.Index, 'Texture Index: ' .. Mask.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId(), 1, Mask.Index), { }, true, function(Hovered, Active, Selected, Index)
            Mask.Index = Index
            if Active then
                SelectedOption = 1;
                SetPedComponentVariation(PlayerPedId(), 1, Mask.Index, Mask.TextureIndex, 0)
            end
            if Selected then 
                if Mask.TextureIndex > (GetNumberOfPedTextureVariations(PlayerPedId(), 1, Mask.Index)-1) then 
                    Mask.TextureIndex = 0;
                else 
                    Mask.TextureIndex = Mask.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Arms", Torso.Max, Torso.Index, 'Texture Index: ' .. Torso.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId(), 3, Torso.Index), { }, true, function(Hovered, Active, Selected, Index)
            Torso.Index = Index
            if Active then
                SelectedOption = 3;
                SetPedComponentVariation(PlayerPedId(), 3, Torso.Index, Torso.TextureIndex, 0)
            end
            if Selected then 
                if Torso.TextureIndex > (GetNumberOfPedTextureVariations(PlayerPedId(), 3, Torso.Index)-1) then 
                    Torso.TextureIndex = 0;
                else 
                    Torso.TextureIndex = Torso.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Legs", Legs.Max, Legs.Index, 'Texture Index: ' .. Legs.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId(), 4, Legs.Index), { }, true, function(Hovered, Active, Selected, Index)
            Legs.Index = Index
            if Active then
                SelectedOption = 4;
                SetPedComponentVariation(PlayerPedId(), 4, Legs.Index, Legs.TextureIndex, 0)
            end
            if Selected then 
                if Legs.TextureIndex > (GetNumberOfPedTextureVariations(PlayerPedId(), 4, Legs.Index)-1) then 
                    Legs.TextureIndex = 0;
                else 
                    Legs.TextureIndex = Legs.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Bags", Parachute.Max, Parachute.Index, 'Texture Index: ' .. Parachute.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId(), 5, Parachute.Index), { }, true, function(Hovered, Active, Selected, Index)
            Parachute.Index = Index
            if Active then
                SelectedOption = 5;
                SetPedComponentVariation(PlayerPedId(), 5, Parachute.Index, Parachute.TextureIndex, 0)
            end
            if Selected then 
                if Parachute.TextureIndex > (GetNumberOfPedTextureVariations(PlayerPedId(), 5, Parachute.Index)-1) then 
                    Parachute.TextureIndex = 0;
                else 
                    Parachute.TextureIndex = Parachute.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Shoes", Shoes.Max, Shoes.Index, 'Texture Index: ' .. Shoes.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId(), 6, Shoes.Index), { }, true, function(Hovered, Active, Selected, Index)
            Shoes.Index = Index
            if Active then
                SelectedOption = 6;
                SetPedComponentVariation(PlayerPedId(), 6, Shoes.Index, Shoes.TextureIndex, 0)
            end
            if Selected then 
                if Shoes.TextureIndex > (GetNumberOfPedTextureVariations(PlayerPedId(), 6, Shoes.Index)-1) then 
                    Shoes.TextureIndex = 0;
                else 
                    Shoes.TextureIndex = Shoes.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Accessories", Accessory.Max, Accessory.Index, 'Texture Index: ' .. Accessory.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId(), 7, Accessory.Index), { }, true, function(Hovered, Active, Selected, Index)
            Accessory.Index = Index
            if Active then
                SelectedOption = 7;
                SetPedComponentVariation(PlayerPedId(), 7, Accessory.Index, Accessory.TextureIndex, 0)
            end
            if Selected then 
                if Accessory.TextureIndex > (GetNumberOfPedTextureVariations(PlayerPedId(), 7, Accessory.Index)-1) then 
                    Accessory.TextureIndex = 0;
                else 
                    Accessory.TextureIndex = Accessory.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Under Shirt", Undershirt.Max, Undershirt.Index, 'Texture Index: ' .. Undershirt.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId(), 8, Undershirt.Index), { }, true, function(Hovered, Active, Selected, Index)
            Undershirt.Index = Index
            if Active then
                SelectedOption = 8;
                SetPedComponentVariation(PlayerPedId(), 8, Undershirt.Index, Undershirt.TextureIndex, 0)
            end
            if Selected then 
                if Undershirt.TextureIndex > (GetNumberOfPedTextureVariations(PlayerPedId(), 8, Undershirt.Index)-1) then 
                    Undershirt.TextureIndex = 0;
                else 
                    Undershirt.TextureIndex = Undershirt.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Vest", Kevlar.Max, Kevlar.Index, 'Texture Index: ' .. Kevlar.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId(), 9, Kevlar.Index), { }, true, function(Hovered, Active, Selected, Index)
            Kevlar.Index = Index
            if Active then
                SelectedOption = 9;
                SetPedComponentVariation(PlayerPedId(), 9, Kevlar.Index, Kevlar.TextureIndex, 0)
            end
            if Selected then 
                if Kevlar.TextureIndex > (GetNumberOfPedTextureVariations(PlayerPedId(), 9, Kevlar.Index)-1) then 
                    Kevlar.TextureIndex = 0;
                else 
                    Kevlar.TextureIndex = Kevlar.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Badges", Badge.Max, Badge.Index, 'Texture Index: ' .. Badge.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId(), 10, Badge.Index), { }, true, function(Hovered, Active, Selected, Index)
            Badge.Index = Index
            if Active then
                SelectedOption = 10;
                SetPedComponentVariation(PlayerPedId(), 10, Badge.Index, Badge.TextureIndex, 0)
            end
            if Selected then 
                if Badge.TextureIndex >= (GetNumberOfPedTextureVariations(PlayerPedId(), 10, Badge.Index)-1) then 
                    Badge.TextureIndex = 0;
                else 
                    Badge.TextureIndex = Badge.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Jackets", Torso2.Max, Torso2.Index, 'Texture Index: ' .. Torso2.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId(), 11,  tonumber(Torso2.Index)), { }, true, function(Hovered, Active, Selected, Index)
            Torso2.Index = Index
            if Active then
                SelectedOption = 11;
                SetPedComponentVariation(PlayerPedId(), 11, Torso2.Index, Torso2.TextureIndex, 0)
            end
            if Selected then 
                if Torso2.TextureIndex >= (GetNumberOfPedTextureVariations(PlayerPedId(), 11, Torso2.Index)-1) then 
                    Torso2.TextureIndex = 0;
                else 
                    Torso2.TextureIndex = Torso2.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Hats", Hats.Max, Hats.Index, 'Texture Index: ' .. Hats.TextureIndex .. "/" .. GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, Hats.Index), { }, true, function(Hovered, Active, Selected, Index)
            Hats.Index = Index
            if Active then
                SelectedOption = "hats";
                SetPedPropIndex(PlayerPedId(), 0, Hats.Index, Hats.TextureIndex, 0)
            end
            if Selected then 
                if Hats.TextureIndex >= (GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, Hats.Index)-1) then 
                    Hats.TextureIndex = 0;
                else 
                    Hats.TextureIndex = Hats.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Glasses", Glasses.Max, Glasses.Index, 'Texture Index: ' .. Glasses.TextureIndex .. "/" .. GetNumberOfPedPropTextureVariations(PlayerPedId(), 1, Glasses.Index), { }, true, function(Hovered, Active, Selected, Index)
            Glasses.Index = Index
            if Active then
                SelectedOption = "glasses";
                SetPedPropIndex(PlayerPedId(), 1, Glasses.Index, Glasses.TextureIndex, 0)
            end
            if Selected then 
                if Glasses.TextureIndex >= (GetNumberOfPedPropTextureVariations(PlayerPedId(), 1, Glasses.Index)-1) then 
                    Glasses.TextureIndex = 0;
                else 
                    Glasses.TextureIndex = Glasses.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Ears", Earings.Max, Earings.Index, 'Texture Index: ' .. Earings.TextureIndex .. "/" .. GetNumberOfPedPropTextureVariations(PlayerPedId(), 2, Earings.Index), { }, true, function(Hovered, Active, Selected, Index)
            Earings.Index = Index
            if Active then
                SelectedOption = "earings";
                SetPedPropIndex(PlayerPedId(), 2, Earings.Index, Earings.TextureIndex, 0)
            end
            if Selected then 
                if Earings.TextureIndex >= (GetNumberOfPedPropTextureVariations(PlayerPedId(), 2, Earings.Index)-1) then 
                    Earings.TextureIndex = 0;
                else 
                    Earings.TextureIndex = Earings.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Watches", Watches.Max, Watches.Index, 'Texture Index: ' .. Watches.TextureIndex .. "/" .. GetNumberOfPedPropTextureVariations(PlayerPedId(), 6, Watches.Index), { }, true, function(Hovered, Active, Selected, Index)
            Watches.Index = Index
            if Active then
                SelectedOption = "watches";
                SetPedPropIndex(PlayerPedId(), 6, Watches.Index, Watches.TextureIndex, 0)
            end
            if Selected then 
                if Watches.TextureIndex >= (GetNumberOfPedPropTextureVariations(PlayerPedId(), 6, Watches.Index)-1) then 
                    Watches.TextureIndex = 0;
                else 
                    Watches.TextureIndex = Watches.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Bracelets", Bracelets.Max, Bracelets.Index, 'Texture Index: ' .. Bracelets.TextureIndex .. "/" .. GetNumberOfPedPropTextureVariations(PlayerPedId(), 7, Bracelets.Index), { }, true, function(Hovered, Active, Selected, Index)
            Bracelets.Index = Index
            if Active then
                SelectedOption = "bracelets";
                SetPedPropIndex(PlayerPedId(), 7, Bracelets.Index, Bracelets.TextureIndex, 0)
            end
            if Selected then 
                if Bracelets.TextureIndex >= (GetNumberOfPedPropTextureVariations(PlayerPedId(), 7, Bracelets.Index)-1) then 
                    Bracelets.TextureIndex = 0;
                else 
                    Bracelets.TextureIndex = Bracelets.TextureIndex + 1
                end
            end
        end)
    end)

end)

local cfg = module("cfg/skinshops")
local skinshops = cfg.skinshops 
local skinshopblips = cfg.skinshopblips


Citizen.CreateThread(function()
    for i,v in pairs(skinshopblips) do 
        local x,y,z = v[2], v[3], v[4]
        local Blip = AddBlipForCoord(x, y, z)
        SetBlipSprite(Blip, 73)
        SetBlipDisplay(Blip, 4)
        SetBlipScale(Blip, 0.7)
        SetBlipColour(Blip, 2)
        SetBlipAsShortRange(Blip, true)
        AddTextEntry("MAPBLIP", 'Clothing Store')
        BeginTextCommandSetBlipName("MAPBLIP")
        EndTextCommandSetBlipName(Blip)
        SetBlipCategory(Blip, 1)
    end
end)


Citizen.CreateThread(function()
    while true do 
        Wait(0)
        for i,v in pairs(skinshops) do 
            local x,y,z = v[2], v[3], v[4]
            if not HasStreamedTextureDictLoaded("clothing") then
				RequestStreamedTextureDict("clothing", true)
				while not HasStreamedTextureDictLoaded("clothing") do
					Wait(1)
				end
			else
			    DrawMarker(9, x, y, z, 0.0, 0.0, 0.0, 90.0, 0.0, 0.0, 1.0, 1.0, 1.0, 51, 153, 255, 1.0,false, false, 2, true, "clothing", "clothing", false)
            end 
        end 
    end
end)


local inMarker = false;
Citizen.CreateThread(function()
    while true do 
        Wait(250)
        inMarker = false;
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for i,v in pairs(skinshops) do 
            local x,y,z = v[2], v[3], v[4]
            if #(coords - vec3(x,y,z)) <= 1.0 then
                inMarker = true 
                break
            end    
        end
        if not MenuOpen and inMarker then 
            MenuOpen = true
            RageUI.Visible(RMenu:Get('ClothingStore', 'main'), true) 
            Mask.Index = GetPedDrawableVariation(ped, 1)
            Mask.TextureIndex = GetPedTextureVariation(ped, 1)
            Torso.Index = GetPedDrawableVariation(ped, 3)
            Torso.TextureIndex = GetPedTextureVariation(ped, 3)
            Legs.Index = GetPedDrawableVariation(ped, 4)
            Legs.TextureIndex = GetPedTextureVariation(ped, 4)
            Parachute.Index = GetPedDrawableVariation(ped, 5)
            Parachute.TextureIndex = GetPedTextureVariation(ped, 5)
            Shoes.Index = GetPedDrawableVariation(ped, 6)
            Shoes.TextureIndex = GetPedTextureVariation(ped, 6)
            Accessory.Index = GetPedDrawableVariation(ped, 7)
            Accessory.TextureIndex = GetPedTextureVariation(ped, 7)
            Undershirt.Index = GetPedDrawableVariation(ped, 8)
            Undershirt.TextureIndex = GetPedTextureVariation(ped, 8)
            Kevlar.Index = GetPedDrawableVariation(ped, 9)
            Kevlar.TextureIndex = GetPedTextureVariation(ped, 9)
            Badge.Index = GetPedDrawableVariation(ped, 10)
            Badge.TextureIndex = GetPedTextureVariation(ped, 10)
            Torso2.Index = GetPedDrawableVariation(ped, 11)
            Torso2.TextureIndex = GetPedTextureVariation(ped, 11)
            Hats.Index = GetPedPropIndex(ped, 0)
            Glasses.Index = GetPedPropIndex(ped, 1)
            Earings.Index = GetPedPropIndex(ped, 2)
            Watches.Index = GetPedPropIndex(ped, 6)
            Bracelets.Index = GetPedPropIndex(ped, 7)
            Hats.TextureIndex = GetPedPropTextureIndex(ped, 0)
            Glasses.TextureIndex = GetPedPropTextureIndex(ped, 1)
            Earings.TextureIndex = GetPedPropTextureIndex(ped, 2)
            Watches.TextureIndex = GetPedPropTextureIndex(ped, 6)
            Bracelets.TextureIndex = GetPedPropTextureIndex(ped, 7)
            Mask.Max = {}
            Hair.Max = {}
            Torso.Max = {}
            Hair.Max = {}
            Torso.Max = {}
            Legs.Max = {}
            Parachute.Max = {}
            Shoes.Max = {}
            Accessory.Max = {}
            Undershirt.Max = {}
            Kevlar.Max = {}
            Badge.Max = {}
            Torso2.Max = {}
            Glasses.Max = {}
            Earings.Max = {}
            Watches.Max = {}
            Bracelets.Max =  {}
            for i=0, GetNumberOfPedDrawableVariations(ped, 1) + 1 do 
                Mask.Max[i] = i;
            end 
            for i=0, GetNumberOfPedDrawableVariations(ped, 2) + 1 do 
                Hair.Max[i] = i;
            end
            for i=0, GetNumberOfPedDrawableVariations(ped, 3) + 1 do 
                Torso.Max[i] = i;
            end 
            for i=0, GetNumberOfPedDrawableVariations(ped, 4) + 1 do 
                Legs.Max[i] = i;
            end  
            for i=0, GetNumberOfPedDrawableVariations(ped, 5) + 1 do 
                Parachute.Max[i] = i;
            end 
            for i=0, GetNumberOfPedDrawableVariations(ped, 6) + 1 do 
                Shoes.Max[i] = i;
            end 
            for i=0, GetNumberOfPedDrawableVariations(ped, 7) + 1 do 
                Accessory.Max[i] = i;
            end 
            for i=0, GetNumberOfPedDrawableVariations(ped, 8) + 1 do 
                Undershirt.Max[i] = i;
            end 
            for i=0, GetNumberOfPedDrawableVariations(ped, 9) + 1 do 
                Kevlar.Max[i] = i;
            end 
            for i=0, GetNumberOfPedDrawableVariations(ped, 10) + 1 do 
                Badge.Max[i] = i;
            end 
            for i=0, GetNumberOfPedDrawableVariations(ped, 11) + 1 do 
                Torso2.Max[i] = i;
            end 
            Hats.Max[-1] = -1
            Glasses.Max[-1] = -1
            Earings.Max[-1] = -1
            Watches.Max[-1] = -1
            Bracelets.Max[-1] = -1
            -- Hot fix for weird native behaviour
            if Hats.TextureIndex == -1 then 
                Hats.TextureIndex = 0
            end
            if Glasses.TextureIndex == -1 then 
                Glasses.TextureIndex = 0
            end
            if Earings.TextureIndex == -1 then 
                Earings.TextureIndex = 0
            end
            if Watches.TextureIndex == -1 then 
                Watches.TextureIndex = 0
            end
            if Bracelets.TextureIndex == -1 then 
                Bracelets.TextureIndex = 0
            end
            for i=0, GetNumberOfPedPropDrawableVariations(ped, 0) + 1 do 
                Hats.Max[i] = i;
            end 
            for i=0, GetNumberOfPedPropDrawableVariations(ped, 1) + 1 do 
                Glasses.Max[i] = i;
            end 
            for i=0, GetNumberOfPedPropDrawableVariations(ped, 2) + 1 do 
                Earings.Max[i] = i;
            end 
            for i=0, GetNumberOfPedPropDrawableVariations(ped, 6) + 1 do 
                Watches.Max[i] = i;
            end 
            for i=0, GetNumberOfPedPropDrawableVariations(ped, 7) + 1 do 
                Bracelets.Max[i] = i;
            end 
        end
        if not inMarker and MenuOpen then
            RageUI.CloseAll()
            RageUI.Visible(RMenu:Get('ClothingStore', 'clothingsubmenu'), false)
            RageUI.Visible(RMenu:Get('ClothingStore', 'changegendersubmenu'), false)  
            RageUI.Visible(RMenu:Get('ClothingStore', 'main'), false)
            MenuOpen = false
        end
    end
end)


function DrawMissionText(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_MPM_NA', TextEntry) 
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true 
    
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() 
		Citizen.Wait(500) 
		blockinput = false 
		return result 
	else
		Citizen.Wait(500)
		blockinput = false 
		return nil 
	end
end


function confirmationCheck(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_MPM_NA', TextEntry) 
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true 
    
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() 
		Citizen.Wait(500) 
		blockinput = false
		if result == "Yes" or result == "YES" or result == "yes" then
			return true
		elseif result == "No" or result == "NO" or result == "no" then
			return false
		end 
	else
		Citizen.Wait(500)
		blockinput = false 
		return false
	end
end

function ShowNotification(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end



function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
   -- SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end 

function Notify(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(0,1)
end

function table.find(table,p)
    for q,r in pairs(table)do 
        if r==p then 
            return true 
        end 
    end
    return false 
end




RegisterNetEvent("HVC:setOverlay")
AddEventHandler("HVC:setOverlay",function(l)
    if l then
        PlayerData = l
        dad = l["dad"] or 0
        mum = l["mum"] or 0
        skin = l["skin"] or 0
        dadmumpercent = l["dadmumpercent"] or 0
        eyecolor = l["eyecolor"] or 0
        acne = l["acne"] or 0
        skinproblem = l["skinproblem"] or 0
        freckle = l["freckle"] or 0
        wrinkle = l["wrinkle"] or 0
        wrinkleopacity = l["wrinkleopacity"] or 0
        hair = l["hair"] or 0
        haircolor = l["haircolor"] or 0
        eyebrow = l["eyebrow"] or 0
        eyebrowopacity = l["eyebrowopacity"] or 0
        beard = l["beard"] or 0
        beardopacity = l["beardopacity"] or 0
        beardcolor = l["beardcolor"] or 0
        eyeshadow = l["eyeshadow"] or 0
        lipstick = l["lipstick"] or 0
        eyeshadowcolour = l["eyeshadowcolour"] or 0
        lipstickcolour = l["lipstickcolour"] or 0
        SetPedHeadBlendData(
            PlayerPedId(),
            dad,
            mum,
            0,
            skin,
            skin,
            skin,
            dadmumpercent,
            dadmumpercent,
            0.0,
            false
        )
        SetPedEyeColor(PlayerPedId(), eyecolor)
        if acne == 0 then
            SetPedHeadOverlay(PlayerPedId(), 0, acne, 0.0)
        else
            SetPedHeadOverlay(PlayerPedId(), 0, acne, 1.0)
        end
        SetPedHeadOverlay(PlayerPedId(), 6, skinproblem, 1.0)
        if freckle == 0 then
            SetPedHeadOverlay(PlayerPedId(), 9, freckle, 0.0)
        else
            SetPedHeadOverlay(PlayerPedId(), 9, freckle, 1.0)
        end
        SetPedHeadOverlay(PlayerPedId(), 3, wrinkle, wrinkleopacity * 0.1)
        SetPedComponentVariation(PlayerPedId(), 2, hair, 0, 2)
        SetPedHairColor(PlayerPedId(), haircolor, haircolor)
        SetPedHeadOverlay(PlayerPedId(), 2, eyebrow, eyebrowopacity * 0.1)
        SetPedHeadOverlay(PlayerPedId(), 1, beard, beardopacity * 0.1)
        SetPedHeadOverlayColor(PlayerPedId(), 1, 1, beardcolor, beardcolor)
        SetPedHeadOverlayColor(PlayerPedId(), 2, 1, beardcolor, beardcolor)
        eyeShadowOpacity = 1.0
        if eyeshadow == 0 then
            eyeShadowOpacity = 0.0
        end
        lipstickOpacity = 1.0
        if lipstick == 0 then
            lipstickOpacity = 0.0
        end
        SetPedHeadOverlay(PlayerPedId(), 4, eyeshadow, eyeShadowOpacity)
        SetPedHeadOverlay(PlayerPedId(), 8, lipstick, lipstickOpacity)
        SetPedHeadOverlayColor(PlayerPedId(), 4, 1, eyeshadowcolour, eyeshadowcolour)
        SetPedHeadOverlayColor(PlayerPedId(), 8, 1, lipstickcolour, lipstickcolour)

        Hair.TextureIndex = l["haircolor"]
    end
end)