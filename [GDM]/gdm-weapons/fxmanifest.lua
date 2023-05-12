fx_version 'cerulean'
games { 'rdr3', 'gta5' }
shared_script {
    "cfg/cfg_weaponModels",
}


files {
	"data/loadouts.meta",
	'**/weaponcomponents.meta',
    '**/weaponarchetypes.meta',
	'**/weaponanimations.meta',
	'**/pedpersonality.meta',
	'**/weapons.meta',
}

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponents.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimations.meta'
data_file "LOADOUTS_FILE" "data/loadouts.meta"
data_file 'PED_PERSONALITY_FILE' '**/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' '**/weapons.meta'


client_scripts {
    "cl_weaponNames.lua",
    "cl_weaponsonback.lua",
}

