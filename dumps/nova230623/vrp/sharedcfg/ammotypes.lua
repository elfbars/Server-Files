vRPAmmoTypes = {
    [".308 Sniper Rounds"] = {"WEAPON_L96", "WEAPON_DEAGLE","WEAPON_STAC","WEAPON_WARHEAD","WEAPON_REAVEROPERATOR","WEAPON_M40A3","WEAPON_M77","WEAPON_S75","WEAPON_G28","WEAPON_SVDK","WEAPON_AWPMIKU","WEAPON_SVD", "WEAPON_BARRET50", "WEAPON_MSR", "WEAPON_SV98", "WEAPON_M107", "WEAPON_M82A2", "WEAPON_M82A3", "WEAPON_GUNGNIR", "WEAPON_BORA", "WEAPON_HADDESNIPER", "WEAPON_M98B", "WEAPON_M200", "WEAPON_ORSIST5000", "WEAPON_MSR2", "WEAPON_STAC", "WEAPON_L118A1", "WEAPON_GLITCHPOPOPERATOR", "WEAPON_RE6SNIPER"},
    ["NATO 5.56 Bullets"] = {"WEAPON_PK470", "WEAPON_GLOWAUG","WEAPON_SAIGRY","WEAPON_IMPULSEAK47","WEAPON_MK18V2","WEAPON_M16A2","WEAPON_MK18CQBR","WEAPON_XM177","WEAPON_M249PLAYMAKER","WEAPON_REAVERVANDALWHITE","WEAPON_HAWKM4","WEAPON_SOLBLUE","WEAPON_PHAN","WEAPON_RGXVANDAL", "WEAPON_WARHEADAR","WEAPON_ELDERVANDAL","WEAPON_IBAK", "WEAPON_AR160","WEAPON_ODINX", "WEAPON_HBRA3", "WEAPON_AN94", "WEAPON_HKMG4","WEAPON_MXM", "WEAPON_FFARAUTOTOON","WEAPON_RPD","WEAPON_M14","WEAPON_TX15","WEAPON_FX05","WEAPON_COLTM16A2","WEAPON_GLITCHPOPPHANTOM","WEAPON_LVOA","WEAPON_M249","WEAPON_M4A4DRAGONKING", "WEAPON_BAL27", "WEAPON_PURPLENIKEGRAU", "WEAPON_AKCQB", "WEAPON_HEADSTONEAUG", "WEAPON_FFAR", "WEAPON_PARAFALSOULREAPER", "WEAPON_ORIGINVANDALYELLOW","WEAPON_SR25", "WEAPON_ODIN", "WEAPON_BLASTXPHANTOM", "WEAPON_SPAR16", "WEAPON_LR300", "WEAPON_HOWL", "WEAPON_SCAR", "WEAPON_ARESSHRIKE", "WEAPON_FNMAG", "WEAPON_M60V2", "WEAPON_MK249", "WEAPON_M4A1","WEAPON_MX","WEAPON_NERFBLASTER","WEAPON_M4A4FIRE","WEAPON_M4A4HYBRID","WEAPON_VAL","WEAPON_RIFLEV2","WEAPON_REAVERVANDAL","WEAPON_SPHANTOM", "WEAPON_M4A1SNIGHTMARE", "WEAPON_MK1EMR","WEAPON_CARB2" ,"WEAPON_PQ15","WEAPON_M4A1SSAGIRI" ,"WEAPON_M4A1SDECIMATOR", "WEAPON_M4A1SSAGIRIR", "WEAPON_CNDYRIFLE", "WEAPON_AUG", "WEAPON_GRAU", "WEAPON_VANDAL", "WEAPON_NV4", "WEAPON_HONEYBADGER", "WEAPON_HK418", "WEAPON_IRONWOLF", "WEAPON_LIQUIDCARBINE", "WEAPON_M60", "WEAPON_HKV2", "WEAPON_HK416", "WEAPON_FNFAL", "WEAPON_DRAGONAK", "WEAPON_MK18", "WEAPON_M16A4", "WEAPON_M13", "WEAPON_RAINBOWLR300", "WEAPON_AUGV2", "WEAPON_XM4TIGER", "WEAPON_M4A4RETRO", "WEAPON_M4A4RIOT", "WEAPON_SP1", "WEAPON_REDTIGER", "WEAPON_ORIGINVANDAL", "WEAPON_PRIMEVANDAL", "WEAPON_MK18V2", "WEAPON_M4A1SPURPLE", "WEAPON_M4A1SNEONOIR", "WEAPON_M4A4NOIR", "WEAPON_M4", "WEAPON_M4FBX", "WEAPON_M203", "WEAPON_ICEDRAKE", "WEAPON_RPK16", "WEAPON_AK47KITTYREVENGE", "WEAPON_MINIMIM249", "WEAPON_SR25", "WEAPON_RE6", "WEAPON_RE6RN", "WEAPON_M4A4NEVA", "WEAPON_AK74UV3"},
    ["9mm Bullets"] = {"WEAPON_MP7A2", "WEAPON_SIG","WEAPON_MWUZI","WEAPON_SIGSAUERP226R","WEAPON_FIVESEVEN","WEAPON_HKMP5K","WEAPON_TACGLOCK19","WEAPON_VTSGLOW","WEAPON_VITYAZ","WEAPON_HAHA", "WEAPON_AK74UGOKU","WEAPON_ANIMEMAC10","WEAPON_UMP", "WEAPON_UZI", "WEAPON_SCORPBLUE", "WEAPON_PPSH", "WEAPON_MP5A2", "WEAPON_DIAMONDMP5", "WEAPON_MTARGLOWC", "WEAPON_MP5GLOW", "WEAPON_MP5A3", "WEAPON_MPXC", "WEAPON_P90", "WEAPON_P90V2", "WEAPON_PRIMESPECTRE", "WEAPON_SCORPEVOE", "WEAPON_SINGULARITYSPECTRE", "WEAPON_T5GLOW", "WEAPON_VSS", "WEAPON_VESPER", "WEAPON_VESPERHYBRID", "WEAPON_USPSTORQUE","WEAPON_GDEAGLE", "WEAPON_FNX45","WEAPON_FINN" ,"WEAPON_M1911", "WEAPON_MAKAROV", "WEAPON_PRINTSTREAMDEAGLE", "WEAPON_SAKURADEAGLE", "WEAPON_GUNGIRLDEAGLE", "WEAPON_KILLCONFIRMEDDEAGLE", "WEAPON_ASIIMOVPISTOL", "WEAPON_VOMFEUER", "WEAPON_TINT"},
    ["7.62mm Bullets"] = {"WEAPON_KASHNAR", "WEAPON_ACRCQB","WEAPON_AK74", "WEAPON_AK200", "WEAPON_MOSIN", "WEAPON_NERFMOSIN"},
    ["12 Gauge Shells"] = {"WEAPON_WINCHESTER12", "WEAPON_MODEL680","WEAPON_HAYMAKER", "WEAPON_USAS12", "WEAPON_DEADPOOLSHOTGUN", "WEAPON_HAYMAKERV2", "WEAPON_PUMPSHOTGUNMK2", "WEAPON_SPAS12"},
    ["Police Issued 5.56mm"] = {"WEAPON_SPAR17","WEAPON_G36K"},
    ["Police Issued 9mm"] = {"WEAPON_MP5","WEAPON_GLOCK17","WEAPON_G36K"},
    ["Police Issued .308 Sniper Rounds"] = {"WEAPON_REMINGTON700","WEAPON_BARRET"},
    ["Police Issued 12 Gauge"] = {"WEAPON_REMINGTON870"},
}

--[[
    Ammo Types are to be setup here! Listed examples above ^ 
    Ex. ["Ammo Name"] = {"WEAPON1_SPAWNCODE", "WEAPON2_SPAWNCODE"} 
    Do not forget your commas or you will kill the whole config.

    Guns are to be defined in client/player_state.lua, so that weapon storing can work effectively. 
    The gun weight is defined in cfg/items alongside it's name. 
    Ex.   ["wbody|WEAPON_ACWR"] = {"ACWR","Bomb",nil,5.00,"weapon"},
    Do not forget your commas or you will kill the whole config.
]]
