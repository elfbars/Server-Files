vRPConfig = {} -- Global variable for easy referencing. 

vRPConfig.MoneyUiEnabled = false; -- Set to false to disable Money in the top right corner. 
vRPConfig.SurvivalUiEnabled = false; -- Controls the UI under the healthbar.
vRPConfig.EnableComa = true; -- Controls the NOVA coma on death.
vRPConfig.EnableFoodAndWater = false; -- Controls the food and water system.
vRPConfig.EnableHealthRegen = true; -- Controls the health regen. (Whether they regen health after taking damage do not disable if coma is enabled.)
vRPConfig.EnableBuyVehicles = true; -- Enables ability to buy vehicles from the RageUI Garages.  
vRPConfig.LoadPreviews = true; -- Controls the car previews with the RageUI Garages.
vRPConfig.VehicleStoreRadius = 250; -- Controls radius a vehicle can be stored from.
vRPConfig.AdminCoolDown = false; -- Enables an admin cooldown on call admin.
vRPConfig.AdminCooldownTime = 60; -- 1 minute in (seconds) duration of cooldown. 
vRPConfig.StoreWeaponsOnDeath = true; -- Stores the players weapon on death allowing them to be looted.
vRPConfig.DoNotDisplayIps = true; -- Removes all NOVA related references in the console to player ip addresses.
vRPConfig.LoseItemsOnDeath = true; -- Controls whether you lose inventory items on death.
vRPConfig.AllowMoreThenOneCar = false; -- Controls if you can have more than one car out.
vRPConfig.F10System = true; -- Logs warnings and can be accessed via F10 (Thanks to Rubbertoe98) (https://github.com/rubbertoe98/FiveM-Scripts/tree/master/nova_punishments)
vRPConfig.ServerName = "NOVA" -- Controls the name that is displayed on warnings title etc.
vRPConfig.PlayerSavingTime = 3000 -- Time in milliseconds to update Player saving
---------------
vRPConfig.LootBags = true; -- Enables loot bags and disables looting. 
vRPConfig.DisplayNamelLootbag = false; -- Enables notification of who's lootbag you have opened