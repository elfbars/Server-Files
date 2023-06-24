local cfg = {}

-- make separate banners you tramp

cfg.selectorTypes = {
    ["default"] = {
        _config = {name="Job Selector", blipid = 351, blipcolor = 47, permissions = {}, TextureDictionary = "banners",texture = "clockon"},
        jobs = {
            {"AA Mechanic", 0},
        }
    },
    ["police"] = {
        _config = {name="Met Police", blipid = 351, blipcolor = 38, permissions = {"cop.whitelisted"}, TextureDictionary = "banners", texture = "clockon"},
        jobs = {
            {"Trident Officer", 30000, "police.trident.whitelisted"},
            {"Trident Command", 40000, "police.tridentcommand.whitelisted"},
            {"Special Constable", 55000, "police.specialconstable.whitelisted"},
            {"NPAS", 45000, "police.npas.whitelisted"},
            {"Custody Sergeant", 20000, "police.custodysergeant.whitelisted"},
            {"PCSO", 20000, "police.pcso.whitelisted"},
            {"PC", 25000, "police.constable.whitelisted"},
            {"Senior Constable", 30000, "police.seniorconstable.whitelisted"},
            {"Sergeant", 35000, "police.sergeant.whitelisted"},
            {"Inspector", 40000, "police.inspector.whitelisted"},
            {"Chief Inspector", 45000, "police.chiefinspector.whitelisted"},
            {"Superintendent", 50000, "police.superintendent.whitelisted"},
            {"Chief Superintendent", 55000, "police.chiefsuperintendent.whitelisted"},
            {"Commander", 60000, "police.commander.whitelisted"},
            {"Dep. Asst. Commissioner", 65000, "police.deputyassistantcommissioner.whitelisted"},
            {"Assistant Commissioner", 70000, "police.assistantcommissioner.whitelisted"},
            {"Deputy Commissioner", 75000, "police.deputycommissioner.whitelisted"},
            {"Commissioner", 80000, "police.commissioner.whitelisted"}
        }
    },
    ["nhs"] = {
        _config = {name="NHS Job", blipid = 351, blipcolor = 3, permissions = {"nhs.whitelisted"}, TextureDictionary = "banners", texture = "clockon"},
        jobs = {
            {"Royal Mail Driver", 0},
            {"Bus Driver", 0},
            {"Deliveroo", 0},
            {"Scuba Diver",  0},
            {"G4S Driver", 0},
            {"Taco Seller", 0},
        }
    },
    ["lfb"] = {
        _config = {name="LFB Job", blipid = 351, blipcolor = 1, permissions = {"lfb.whitelisted"}, TextureDictionary = "banners", texture = "clockon"},
        jobs = {
            {"Royal Mail Driver", 0},
            {"Bus Driver", 0},
            {"Deliveroo", 0},
            {"Scuba Diver",  0},
            {"G4S Driver", 0},
            {"Taco Seller", 0},
            {"Burger Shot Cook", 0},
        }
    },
    ["hmp"] = {
        _config = {name="Prison Guard", blipid = 351, blipcolor = 1, permissions = {"prisonguard.whitelisted"}, TextureDictionary = "banners", texture = "clockon"},
        jobs = {
            {"Royal Mail Driver", 0},
            {"Bus Driver", 0},
            {"Deliveroo", 0},
            {"Scuba Diver",  0},
            {"G4S Driver", 0},
            {"Taco Seller", 0},
            {"Burger Shot Cook", 0},
        }
    },
}

cfg.selectors = {
    --police
    {type="police", position=vector3(447.8727722168,-975.65673828125,30.68946647644)}, -- mission row
    {type="police", position=vector3(1850.9689941406, 3690.8791503906,34.267063140869)}, -- sandy pd
    {type="police", position=vector3(-449.63262939453, 6010.1459960938,31.716451644897)}, -- paleto pd
    {type="police", position=vector3(-1099.4694824219,-840.96234130859,19.001483917236)}, -- vespucci pd

    --nhs
    {type="nhs", position=vector3(304.63632202148, -600.60247802734, 43.284015655518)}, -- st thomas
    {type="nhs", position=vector3(1836.0842285156, 3683.5278320313, 34.270088195801)},-- sandy medical centre
    {type="nhs", position=vector3(-252.83834838867,  6336.576171875, 32.427227020264)},-- paleto hospital
    {type="nhs", position=vector3(-437.55773925781,-308.36221313477,34.910556793213)},-- mount zonah hospital

    --lfb
    {type="lfb", position=vector3(1176.7259521484,-1477.5871582031,35.073612213135)},-- main station (city)

    --hmp
    {type="hmp", position=vector3(1835.4084472656,2590.39453125,45.952346801758)},-- prison

    --default
    {type="default", position=vector3(-566.03192138672,-193.77198791504,38.219692230225)},-- city hall

}

cfg.metPoliceRanks = {
            {"Trident Officer", 30000, "police.trident.whitelisted"},
            {"Trident Command", 40000, "police.tridentcommand.whitelisted"},
            {"Special Constable", 55000, "police.specialconstable.whitelisted"},
            {"NPAS", 45000, "police.npas.whitelisted"},
            {"Custody Sergeant", 20000, "police.custodysergeant.whitelisted"},
            {"PCSO", 20000, "police.pcso.whitelisted"},
            {"PC", 25000, "police.constable.whitelisted"},
            {"Senior Constable", 30000, "police.seniorconstable.whitelisted"},
            {"Sergeant", 35000, "police.sergeant.whitelisted"},
            {"Inspector", 40000, "police.inspector.whitelisted"},
            {"Chief Inspector", 45000, "police.chiefinspector.whitelisted"},
            {"Superintendent", 50000, "police.superintendent.whitelisted"},
            {"Chief Superintendent", 55000, "police.chiefsuperintendent.whitelisted"},
            {"Commander", 60000, "police.commander.whitelisted"},
            {"Dep. Asst. Commissioner", 65000, "police.deputyassistantcommissioner.whitelisted"},
            {"Assistant Commissioner", 70000, "police.assistantcommissioner.whitelisted"},
            {"Deputy Commissioner", 75000, "police.deputycommissioner.whitelisted"},
            {"Commissioner", 80000, "police.commissioner.whitelisted"}
}

return cfg
