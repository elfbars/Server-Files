
local cfg = {}

-- define customization parts
local parts = {
  ["Face"] = 0,
  ["Hair"] = 2,
  ["Hand"] = 3,
  ["Legs"] = 4,
  ["Shirt"] = 8,
  ["Shoes"] = 6,
  ["Jacket"] = 11,
  ["Hats"] = "p0",
  ["Glasses"] = "p1",
  ["Ears"] = "p2",
  ["Watches"] = "p6",
  ["Extras 1"] = 9,
  ["Extras2"] = 10
}

-- changes prices (any change to the character parts add amount to the total price)
cfg.drawable_change_price = 20
cfg.texture_change_price = 5


-- skinshops list {parts,x,y,z}
cfg.skinshops = {
  {parts,72.2545394897461,-1399.10229492188,29.3761386871338},
  {parts,449.81854248047,-993.30865478516,30.689584732056},
  {parts,-703.77685546875,-152.258544921875,37.4151458740234},
  {parts,-167.863754272461,-298.969482421875,39.7332878112793},
  {parts,428.694885253906,-800.1064453125,29.4911422729492},
  {parts,-829.413269042969,-1073.71032714844,11.3281078338623},
  {parts,-1193.42956542969,-772.262329101563,17.3244285583496},
  {parts,-431.84252929688,6006.01953125,31.323492050171},
  {parts,-1447.7978515625,-242.461242675781,49.8207931518555},
  {parts,11.6323690414429,6514.224609375,31.8778476715088},
  {parts,1696.29187011719,4829.3125,42.0631141662598},
  {parts,123.64656829834,-219.440338134766,54.5578384399414},
  {parts,618.093444824219,2759.62939453125,42.0881042480469},
  {parts,1190.55017089844,2713.44189453125,38.2226257324219},
  {parts,-3172.49682617188,1048.13330078125,20.8632030487061},
  {parts,-1108.44177246094,2708.92358398438,19.1078643798828},
  {parts, 1103.2231445312,196.49504089355,-49.440082550049},
  {parts, -1887.2069091797,2070.4028320312,145.57371520996},
  {parts, 1838.7633056641,3689.7431640625,34.270038604736},
  {parts, 4489.1684570313,-4452.7626953125,4.3664631843567},
  {parts, -2164.0048828125,5221.5673828125,18.770429611206},
  {parts, 131.84776306152,-1032.9157714844,29.432485580444},
  {parts, 1442.3695068359,6333.388671875,23.897306442261},
  {parts, 1576.5750732422,6462.9331054688,25.031162261963},
}

cfg.peds = {
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

return cfg
