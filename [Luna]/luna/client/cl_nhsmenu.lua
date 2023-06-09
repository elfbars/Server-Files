RMenu.Add('LUNANHSMenu', 'main', RageUI.CreateMenu("LUNA NHS", "~g~NHS Menu",1250,100))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('LUNANHSMenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = true, instructionalButton = true}, function()
            if IsPedInAnyVehicle(PlayerPedId(), false) == false then

                RageUI.Button("Perform Cardiopulmonary Resuscitation (CPR)" , "~b~Perform CPR on the nearest player in a coma", { RightLabel = '→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('LUNA:reviveRadial2')
                    end
                end)

                RageUI.Button("Heal Nearest Player", "~b~Heal the nearest player", { RightLabel = '→'}, true, function(Hovered, Active, Selected) 
                  if Selected then 
                      TriggerServerEvent('LUNA:HealPlayer')
                  end
              end)
                

            end
        end)
    end
end)

RegisterCommand('nhs', function()
  if IsPedInAnyVehicle(PlayerPedId(-1), false) == false then
    TriggerServerEvent('LUNA:OpenNHSMenu')
  end
end)

RegisterNetEvent("LUNA:NHSMenuOpened")
AddEventHandler("LUNA:NHSMenuOpened",function()
  RageUI.Visible(RMenu:Get('LUNANHSMenu', 'main'), not RageUI.Visible(RMenu:Get('LUNANHSMenu', 'main')))
end)

RegisterKeyMapping('nhs', 'Opens the NHS menu', 'keyboard', 'U')