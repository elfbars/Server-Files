
local cfg = {}

cfg.inventory_weight_per_strength = 50 -- weight for an user inventory per strength level (no unit, but thinking in "kg" is a good norm)

-- default chest weight for vehicle trunks
cfg.default_vehicle_chest_weight = 30

-- define vehicle chest weight by model in lower case
cfg.vehicle_chest_weights = {
  
  ["monster"] = 250,
  ["stinger"] = 250,
  ["superduty"] = 200, -- Locks
  ["19ramoffroad"] = 200, -- Imports
  ["velociraptor"] = 200,
  ["transvan"] = 300,
  ["candyvan"] = 300,
  ["gladiator"] = 150,
  ["wildtrak"] = 150,
  ["m977hl"] = 200, -- VIP
  ["raptor150"] = 150,
  ["jagoffroad"] = 100,
  ["keyvanyrsq3"] = 100,
  ["uzibentayga"] = 100,
  ["mayg900"] = 100,
  ["polisheli"] = 200,
  ["littlebird"] = 200,
  ["asdavan"] = 300,
  ["fordconnect"] = 300,
  ["dpdvan"] = 300,
  ["bt"] = 300,
  ["bt1"] = 300,
  ["royalmailvan"] = 300,
  ["uziurus"] = 100,
  ["ventsraid"] = 100,
  ["knightxv"] = 100,
  ["2ncshog"] = 100,
  ["conceptr"] = 300,
  ["urusevo"] = 100,
  ["nightmare"] = 100,
  ["r150r"] = 200,
  ["PriorGLE"] = 100,
  ["offramsrt"] = 200,
  ["macan4x4"] = 100,
  ["urusv"] = 100,
  ["RSQ8offroad"] = 100,
  ["frr"] = 200,
  ["demonhawkkheli"] = 200,
  ["jeepscc"] = 100,
  ["19raptor"] = 200,
  ["manan4x4raid"] = 100,
  ["oh6a"] = 150,  -- Simeons Heli
  ["uzibentaygaheli"] = 200,
  ["urusvennum"] = 200,
  ["focusraid"] = 100,
  ["DHL"] = 300,
  ["dpdconnect"] = 300,
  ["a35raid"] = 100,
  ["refluxsprint"] = 300,
  ["17jamb"] = 300,
  ["apecar50"] = 300,
  ["ateam"] = 300,
  ["berlingo"] = 300,
  ["boxvan"] = 300,
  ["crafter17"] = 300,
  ["e15082"] = 300,
  ["econoline"] = 300,
  ["expertpeug"] = 300,
  ["kangoo"] = 300,
  ["swissc"] = 300,
  ["mercvan"] = 300,
  ["minivan22"] = 300,
  ["NSPEEDO"] = 300,
  ["p600coca"] = 300,
  ["pedalbeer"] = 300,
  ["peugotvan2"] = 300,
  ["sprinter211"] = 300,
  ["sprinter2020"] = 300,
  ["steed3"] = 300,
  ["tgfvan"] = 300,
  ["thomastruck"] = 300,
  ["trannysport"] = 300,
  ["ukvan"] = 300,
  ["vito"] = 300,
  ["woodyvan"] = 300,
  ["youga22"] = 300,
  ["yougat"] = 300,
  ["hsrs6"] = 750, -- Management
  ["xbuggy"] = 100,
  ["m5abflug"] = 200,
  ["abfurus"] = 200,
  ["hog"] = 300,
  ["jamo"] = 200,
  ["zoewstt"] = 100,
  ["rs7c8wb"] = 100,
  ["keyrus"] = 100,
  ["mrbeanmini"] = 200,
  ["attsrsrpxxabt"] = 30,
  ["r8spyder20"] = 200,
  ["evo9r"] = 300,
  
  
  
}

return cfg
