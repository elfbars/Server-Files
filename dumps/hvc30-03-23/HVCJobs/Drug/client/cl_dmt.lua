local InRangeGather = false
local InRangeProcess1 = false
local InRangeProcess2 = false

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(500)
    --[[GATHER]]--
    if HVCDrugsClientT.IsPlayerNearCoords(vector3(Drugs.DMT.Gather.x,Drugs.DMT.Gather.y,Drugs.DMT.Gather.z), 45.0) then
      if not InRangeGather then
        InRangeGather = true
        Citizen.CreateThread(function()
          while InRangeGather do
            Citizen.Wait(0)
            HVCDrugsClientT.DrawHelpText("~w~Press ~INPUT_VEH_HORN~ to gather ~g~DMT~w~.")
            if IsControlJustReleased(0, 51) and not Action then
              if not pedinveh then
                Action = true
                local ped = PlayerPedId()
                RequestAnimDict("weapons@first_person@aim_rng@generic@projectile@thermal_charge@")
                while (not HasAnimDictLoaded("weapons@first_person@aim_rng@generic@projectile@thermal_charge@")) do Citizen.Wait(0) end
                TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_GARDENER_PLANT', false, true)
                Citizen.Wait(8000)
                ClearPedTasks(ped)
                HVCDrugsServer.DMTGather()
                Action = false

              else
                HVC.notify({"~r~Get out of the car to do this!"})
              end
            end
          end
        end)
      end
    else
      InRangeGather = false
    end

    --[[ PROCESS ONE ]]--

    if HVCDrugsClientT.IsPlayerNearCoords(vector3(Drugs.DMT.Process1.x,Drugs.DMT.Process1.y,Drugs.DMT.Process1.z), 45.0) then

      if not InRangeProcess1 then
        InRangeProcess1 = true
        Citizen.CreateThread(function()
          while InRangeProcess1 do
            Citizen.Wait(0)
            HVCDrugsClientT.DrawHelpText("~w~Press ~INPUT_VEH_HORN~ to process ~g~DMT~w~.")
            if IsControlJustReleased(0, 51) and not Action then
              Action = true
              local ped = PlayerPedId()
              HVCDrugsServer.DMTCanProcess1({}, function(canProcess)
                if canProcess then
                  local pid = PlayerPedId()
                  Wait(500)
                  RequestAnimDict("missheistdockssetup1clipboard@idle_a")
                  while (not HasAnimDictLoaded("missheistdockssetup1clipboard@idle_a")) do Citizen.Wait(0) end
                  --TaskPlayAnim(pid, "missheistdockssetup1clipboard@idle_a", "idle_b", 1.0, 1.0, 10000, 9, -1, true, true, true)
                  TaskStartScenarioInPlace(pid, 'WORLD_HUMAN_BUM_WASH', false, true)
                  Citizen.Wait(9999)
                  ClearPedTasksImmediately(pid, true)
                  Citizen.Wait(1)
                  HVCDrugsServer.DMTDoneProcessing1()
                  Action = false
                end
                if not canProcess then
                  HVC.notify({"~r~You do not have the required license."})
                end
              end)
            end
          end
        end)
      end
    else
      InRangeProcess1 = false
    end

    --[[ PROCESS TWO ]]--

    if HVCDrugsClientT.IsPlayerNearCoords(vector3(Drugs.DMT.Process2.x,Drugs.DMT.Process2.y,Drugs.DMT.Process2.z), 45.0) then

      if not InRangeProcess2 then
        InRangeProcess2 = true
        Citizen.CreateThread(function()
          while InRangeProcess2 do
            Citizen.Wait(0)
            HVCDrugsClientT.DrawHelpText("~w~Press ~INPUT_VEH_HORN~ to process ~g~DMT~w~.")
            if IsControlJustReleased(0, 51) and not Action then
              Action = true
              local ped = PlayerPedId()
              HVCDrugsServer.DMTCanProcess2({}, function(canProcess)
                if canProcess then
                  local pid = PlayerPedId()
                  Wait(500)
                  RequestAnimDict("missheistdockssetup1clipboard@idle_a")
                  while (not HasAnimDictLoaded("missheistdockssetup1clipboard@idle_a")) do Citizen.Wait(0) end
                  --TaskPlayAnim(pid, "missheistdockssetup1clipboard@idle_a", "idle_b", 1.0, 1.0, 10000, 9, -1, true, true, true)
                  TaskStartScenarioInPlace(pid, 'WORLD_HUMAN_CLIPBOARD', false, true)
                  Citizen.Wait(9999)
                  ClearPedTasksImmediately(pid, true)
                  Citizen.Wait(1)
                  HVCDrugsServer.DMTDoneProcessing2()
                  Action = false
                end
                if not canProcess then
                  HVC.notify({"~r~You do not have the required license."})
                end
              end)
            end
          end
        end)
      end
    else
      InRangeProcess2 = false
    end
  end
end)


Citizen.CreateThread(function()
  while true do
    --DrawMarker(1, Drugs.DMT.Process.x,Drugs.DMT.Process.y,Drugs.DMT.Process.z - 0.999999, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 6.0, 6.0, 2.5, 112, 0, 0, 150, 0, 0, 2, 0, 0, 0, false)
    --DrawMarker(1, Drugs.DMT.Gather.x,Drugs.DMT.Gather.y,Drugs.DMT.Gather.z - 0.999999, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 6.0, 6.0, 2.5, 112, 0, 0, 150, 0, 0, 2, 0, 0, 0, false)
    Citizen.Wait(0)
  end
end)