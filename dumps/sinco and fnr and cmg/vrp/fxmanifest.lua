fx_version 'cerulean'
games {  'gta5' }

description "RP module/framework"

dependency "ghmattimysql"
dependency "vrp_mysql"

ui_page "gui/index.html"

shared_scripts {
  "sharedcfg/*",
  "shared/*.lua"
}

-- client files
files{
  "cfg/client.lua",
  "cfg/cfg_*.lua",
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
  "gui/fonts/GTA.woff",
  "gui/img/death.png",
  "gui/img/death2.png",
}

-- client scripts
client_scripts{
  "rageui/RMenu.lua",
  "rageui/menu/RageUI.lua",
  "rageui/menu/Menu.lua",
  "rageui/menu/MenuController.lua",
  "rageui/components/*.lua",
  "rageui/menu/elements/*.lua",
  "rageui/menu/items/*.lua",
  "rageui/menu/panels/*.lua",
  "rageui/menu/panels/*.lua",
  "rageui/menu/windows/*.lua",
  "lib/cl_thread.lua",
  "lib/cl_cache.lua",
  "lib/cl_util.lua",
  "cfg/atms.lua",

  
  "cfg/cfg_weapons.lua",
  "cfg/skinshops.lua",
  "cfg/garages.lua",
  "cfg/admin_menu.lua",
  "cfg/cfg_adminmenu.lua",
  "cfg/gangfunds.lua",
  "lib/utils.lua",
  "lib/cl_mouse.lua",
  "client/Tunnel.lua",
  "client/Proxy.lua",
  "client/base.lua",
  "client/cl_combattimer.lua",
  "utils/*",
  "client/iplloader.lua",
  "client/cl_policemenu.lua",
  "client/gui.lua",
  "client/player_state.lua",
  "client/survival.lua",
  "client/map.lua",
  "client/identity.lua",
  "client/cl_*.lua",
  "client/basic_garage.lua",
  "client/police.lua",
  "client/lockcar-client.lua",
  "client/admin.lua",
  "client/enumerators.lua",
  "client/clothing.lua",
  "client/atms.lua",
  "client/garages.lua",
  "client/panic_cl.lua",
  "client/adminmenu.lua",
  "client/LsCustomsMenu.lua",
  "client/LsCustoms.lua",
  "client/warningsystem.lua",
  "cl_pausmenu.lua",
  "MergedClient/*",
  "MergedClient/drugs/*.lua",
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
  "modules/police.lua",
  "modules/mission.lua",
  "modules/aptitude.lua",

  -- basic implementations
  "modules/basic_phone.lua",
  "modules/sv_nilperm.lua",
  "modules/basic_atm.lua",
  "modules/sv_gangmenu.lua",
  "modules/basic_gunshop.lua",
  "modules/basic_garage.lua",
  "modules/basic_items.lua",
  "modules/basic_skinshop.lua",
  "modules/sv_policemenu.lua",
  "modules/paycheck.lua",
  "modules/LsCustoms.lua",
  "modules/server_commands.lua",
  "modules/warningsystem.lua",
  "modules/sv_cmds.lua",
  "modules/sv_dealership.lua",
  "modules/sv_entitygun.lua",
  "modules/panic_sv.lua",
  "modules/sv_tebex.lua",
  "modules/sv_adminmenu.lua",
  "modules/sv_moneydrops.lua",
  "modules/sv_phone.lua",
  "MergedServer/*",
  "modules/sv_cardev.lua",
  "modules/sv_anticheat.lua",
  "modules/sv_gangfunds.lua",
  "modules/sv_speedgun.lua",
  "modules/sv_djmenu.lua",
  "modules/sv_drugs.lua",
  "modules/sv_discordroles.lua",
  "modules/sv_groupselector.lua",
  "MergedServer/drugs/*.lua",
  "cfg/discordroles.lua",
}