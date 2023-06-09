

fx_version 'cerulean'
games {  'gta5' }

description "RP module/framework"

dependency "ghmattimysql"
dependency "vrp_mysql"

ui_page "gui/index.html"

shared_scripts {
  "sharedcfg/*",
}

-- RageUI
client_scripts {
	"rageui/RMenu.lua",
	"rageui/menu/RageUI.lua",
	"rageui/menu/Menu.lua",
	"rageui/menu/MenuController.lua",
	"rageui/components/*.lua",
	"rageui/menu/elements/*.lua",
	"rageui/menu/items/*.lua",
	"rageui/menu/panels/*.lua",
	"rageui/menu/panels/*.lua",
	"rageui/menu/windows/*.lua"
}

-- server scripts
server_scripts{ 
  "lib/utils.lua",
  "lib/Housingutils.lua",
  "base.lua",
  "modules/gui.lua",
  "modules/group.lua",
  "modules/admin.lua",
  "modules/survival.lua",
  "modules/player_state.lua",
  "modules/map.lua",
  "modules/money.lua",
  "modules/inventory.lua",
  "modules/identity.lua",
  "modules/business.lua",
  "modules/item_transformer.lua",
  "modules/emotes.lua",
  "modules/police.lua",
  "modules/home_components.lua",
  "modules/mission.lua",
  "modules/aptitude.lua",

  -- basic implementations
  "modules/basic_phone.lua",
  "modules/sv_nilperm.lua",
  "modules/sv_gangmenu.lua",
  "modules/basic_market.lua",
  "modules/basic_gunshop.lua",
  "modules/basic_garage.lua",
  "modules/basic_items.lua",
  "modules/basic_skinshop.lua",
  "modules/cloakroom.lua",
  "modules/paycheck.lua",
  "modules/LsCustoms.lua",
  "modules/server_commands.lua",
  "modules/warningsystem.lua",
  "modules/sv_cmds.lua",
  "modules/sv_lootbags.lua",
  "modules/sv_dealership.lua",
  "modules/sv_dealership2.lua",
  "modules/sv_tebex.lua",
  "modules/sv_adminmenu.lua",
  "modules/phone_integration.lua",
  "modules/sv_phone.lua",
  "MergedServer/*",
  "modules/basic_gunshop.lua",
  "modules/sv_death.lua",
  "modules/sv_vehcleanup",
  "modules/sv_cardev.lua",
  "modules/sv_anticheat.lua",
  "modules/sv_blips.lua",
  "modules/sv_dailyrewards.lua",
}

-- client scripts
client_scripts{
  "cfg/skinshops.lua",
  "cfg/garages.lua",
  "cfg/admin_menu.lua",
  "cfg/cfg_adminmenu.lua",
  "lib/utils.lua",
  "lib/cl_mouse.lua",
  "client/Tunnel.lua",
  "client/Proxy.lua",
  "client/base.lua",
  "client/cl_combattimer.lua",
  "utils/*",
  "client/iplloader.lua",
  "client/gui.lua",
  "client/player_state.lua",
  "client/survival.lua",
  "client/map.lua",
  "client/identity.lua",
  "client/basic_garage.lua",
  "client/cl_anticheat.lua",
  "client/lockcar-client.lua",
  "client/admin.lua",
  "client/enumerators.lua",
  "client/clothing.lua",
  "client/garages.lua",
  "client/adminmenu.lua",
  "client/LsCustomsMenu.lua",
  "client/LsCustoms.lua",
  "client/warningsystem.lua",
  "client/lootbags.lua",
  "client/No-clip.lua",
  "client/Instructional_Buttons.lua",
  "client/cl_adminmenu.lua",
  "cl_pausmenu.lua",
  'client/cl_phone.lua',
  "client/cl_vehcleanup",
  "MergedClient/*",
  "client/cl_death.lua",
  "client/cl_cmds.lua",
  "client/cl_cardev.lua",
  "client/cl_dailyrewards.lua",
}

files{
  "lib/HousingTunnel.lua",
  "cfg/client.lua",
  "gui/index.html",
  "gui/design.css",
  "gui/main.js",
  "gui/Menu.js",
  "gui/ProgressBar.js",
  "gui/WPrompt.js",
  "gui/RequestManager.js",
  "gui/AnnounceManager.js",
  "gui/Div.js",
  "gui/dynamic_classes.js",
  "gui/fonts/Pdown.woff",
  "gui/fonts/GTA.woff"
}
