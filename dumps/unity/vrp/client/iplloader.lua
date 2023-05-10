local fix = true

if fix then
  Citizen.CreateThread(function()
    LoadMpDlcMaps()
    EnableMpDlcMaps(true)
    RemoveIpl("rc12b_default")
    RequestIpl("chop_props")
    RequestIpl("FIBlobby")
    RemoveIpl("FIBlobbyfake")
    RequestIpl("FBI_colPLUG")
    RequestIpl("FBI_repair")
    RequestIpl("v_tunnel_hole")
    RequestIpl("TrevorsMP")
    RequestIpl("TrevorsTrailer")
    RequestIpl("TrevorsTrailerTidy")
    RemoveIpl("farm_burnt")
    RemoveIpl("farm_burnt_lod")
    RemoveIpl("farm_burnt_props")
    RemoveIpl("farmint_cap")
    RemoveIpl("farmint_cap_lod")
    RequestIpl("farm")
    RequestIpl("farmint")
    RequestIpl("farm_lod")
    RequestIpl("farm_props")
    RequestIpl("facelobby")
    RemoveIpl("CS1_02_cf_offmission")
    RequestIpl("CS1_02_cf_onmission1")
    RequestIpl("CS1_02_cf_onmission2")
    RequestIpl("CS1_02_cf_onmission3")
    RequestIpl("CS1_02_cf_onmission4")
    RequestIpl("v_rockclub")
    RemoveIpl("hei_bi_hw1_13_door")
    RequestIpl("bkr_bi_hw1_13_int")
    RequestIpl("ufo")
    RemoveIpl("v_carshowroom")
    RemoveIpl("shutter_open")
    RemoveIpl("shutter_closed")
    RemoveIpl("shr_int")
    RemoveIpl("csr_inMission")
    RequestIpl("v_carshowroom")
    RequestIpl("shr_int")
    RequestIpl("shutter_closed")
    RequestIpl("smboat")
    RequestIpl("cargoship")
    RequestIpl("railing_start")
    RemoveIpl("sp1_10_fake_interior")
    RemoveIpl("sp1_10_fake_interior_lod")
    RequestIpl("sp1_10_real_interior")
    RequestIpl("sp1_10_real_interior_lod")
    RemoveIpl("id2_14_during_door")
    RemoveIpl("id2_14_during1")
    RemoveIpl("id2_14_during2")
    RemoveIpl("id2_14_on_fire")
    RemoveIpl("id2_14_post_no_int")
    RemoveIpl("id2_14_pre_no_int")
    RemoveIpl("id2_14_during_door")
    RequestIpl("id2_14_during1")
    RequestIpl("coronertrash")
    RequestIpl("Coroner_Int_on")
    RemoveIpl("Coroner_Int_off")
    RemoveIpl("bh1_16_refurb")
    RemoveIpl("jewel2fake")
    RemoveIpl("bh1_16_doors_shut")
    RequestIpl("refit_unload")
    RequestIpl("post_hiest_unload")
    RequestIpl("Carwash_with_spinners")
    RequestIpl("ferris_finale_Anim")
    RemoveIpl("ch1_02_closed")
    RequestIpl("ch1_02_open")
    RequestIpl("AP1_04_TriAf01")
    RequestIpl("CS2_06_TriAf02")
    RequestIpl("CS4_04_TriAf03")
    RemoveIpl("scafstartimap")
    RequestIpl("scafendimap")
    RemoveIpl("DT1_05_HC_REMOVE")
    RequestIpl("DT1_05_HC_REQ")
    RequestIpl("DT1_05_REQUEST")
    RequestIpl("FINBANK")
    RemoveIpl("DT1_03_Shutter")
    RemoveIpl("DT1_03_Gr_Closed")
    RequestIpl("ex_sm_13_office_01a")
    RequestIpl("ex_sm_13_office_01b")
    RequestIpl("ex_sm_13_office_02a")
    RequestIpl("ex_sm_13_office_02b")
  end)
end




local islandVec = vector3(4840.571, -5174.425, 2.0)
Citizen.CreateThread(function()
  while true do
	  local pCoords = GetEntityCoords(GetPlayerPed(-1))		
		local distance1 = #(pCoords - islandVec)
		if distance1 < 2000.0 then
			Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", true)  -- load the map and removes the city
			Citizen.InvokeNative("0x5E1460624D194A38", true) -- load the minimap/pause map and removes the city minimap/pause map
		else
			--Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", false)
			--Citizen.InvokeNative("0x5E1460624D194A38", false)
		end
		Citizen.Wait(5000)
  end
end)