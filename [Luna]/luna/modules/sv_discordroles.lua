local cfg = module("cfg/discordroles")
local FormattedToken = "Bot " .. cfg.Bot_Token
local Discord_Sources = {} -- Discord ID: (User Source, User ID)

local error_codes_defined = {
	[200] = 'OK - The request was completed successfully..!',
	[400] = "Error - The request was improperly formatted, or the server couldn't understand it..!",
	[401] = 'Error - The Authorization header was missing or invalid..! Your Discord Token is probably wrong or does not have correct permissions attributed to it.',
	[403] = 'Error - The Authorization token you passed did not have permission to the resource..! Your Discord Token is probably wrong or does not have correct permissions attributed to it.',
	[404] = "Error - The resource at the location specified doesn't exist.",
	[429] = 'Error - Too many requests, you hit the Discord rate limit. https://discord.com/developers/docs/topics/rate-limits',
	[502] = 'Error - Discord API may be down?...'
}

local function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/" .. endpoint, function(errorCode, resultData, resultHeaders)
		data = {data = resultData, code = errorCode, headers = resultHeaders}
    end, method, #jsondata > 0 and jsondata or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken})

    while not data do
        Citizen.Wait(0)
    end
	
    return data
end

local function GetIdentifier(source, id_type)
    if type(id_type) ~= "string" then
		return print('Invalid usage')
	end

    for _, identifier in pairs(GetPlayerIdentifiers(source)) do
        if string.find(identifier, id_type) then
            return identifier
        end
    end
    return nil
end

local function Get_Client_Discord_ID(source)
	local discord_id = GetIdentifier(source, 'discord')
	if discord_id then
		return discord_id:gsub('discord:', '')
	else
		return nil
	end
end

local function Client_Has_Role(roles_table, role_id)
	for _, table_role_id in pairs(roles_table) do
		if tostring(table_role_id) == tostring(role_id) or tostring(_) == tostring(role_id) then
			return true
		end
	end
	return false
end

local function Get_Client_Has_Roles(guild_roles, client_roles)
	local has_roles = {}
	local does_not_have_roles = {}

	for role_name, guild_role_id in pairs(guild_roles) do
		local found_role = false
		for _, client_role_id in pairs(client_roles) do
			if tostring(guild_role_id) == tostring(client_role_id) then
				found_role = true
				table.insert(has_roles, guild_role_id)
				break
			end
		end
		
		if not found_role then
			table.insert(does_not_have_roles, guild_role_id)
		end
	end

	return has_roles, does_not_have_roles
end

local recent_role_cache = {}
local function GetDiscordRoles(guild_id, user_discord_id)
	if cfg.CacheDiscordRoles and recent_role_cache[user_discord_id] and recent_role_cache[user_discord_id][guild_id] then
		return recent_role_cache[user_discord_id][guild_id]
	end

	local endpoint = ("guilds/%s/members/%s"):format(guild_id, user_discord_id)
	local member = DiscordRequest("GET", endpoint, {})
	if member.code == 200 then
		local data = json.decode(member.data)
		local roles = data.roles
		local found = true
		if cfg.CacheDiscordRoles then
			recent_role_cache[user_discord_id] = recent_role_cache[user_discord_id] or {}
			recent_role_cache[user_discord_id][guild_id] = roles
			Citizen.SetTimeout(((cfg.CacheDiscordRolesTime or 60) * 1000), function()
				recent_role_cache[user_discord_id][guild_id] = nil 
			end)
		end
		return roles
	else
		return false
	end
	return false
end

local function Modify_Client_Roles(MAIN, discord_id, user_id)
	local discord_roles = GetDiscordRoles(cfg.Guilds[MAIN], discord_id)
	if discord_roles then
		local has_roles, does_not_have_roles = Get_Client_Has_Roles(cfg.Guild_Roles[MAIN], discord_roles)
		for _, role_id in pairs(does_not_have_roles) do
			for k,v in pairs(cfg.Guild_Roles[MAIN]) do
                if v == role_id and LUNA.hasGroup(user_id, k) then
					print('has group '..k..' without role so removing')
                    LUNA.removeUserGroup(user_id, k)
                end
			end
		end

		for _, role_id in pairs(has_roles) do
            for k,v in pairs(cfg.Guild_Roles[MAIN]) do
                if v == role_id and not LUNA.hasGroup(user_id, k) then
					print('has role but not group '..k..' so adding')
                    LUNA.addUserGroup(user_id, k)
                end
            end
		end
	end
	LUNA.getJobSelectors(LUNA.getUserSource(user_id))
end

local tracked = {}
RegisterNetEvent('LUNA:getFactionWhitelistedGroups')
AddEventHandler('LUNA:getFactionWhitelistedGroups', function()
	local source = source
	tLUNA.getFactionGroups(source)
end)

function tLUNA.getFactionGroups(source)
    local source = source
	local fivem_license = GetIdentifier(source, 'license')
	if not tracked[fivem_license] then 
		tracked[fivem_license] = true
	end

	local user_id = LUNA.getUserId(source)
	if user_id then
		local discord_id = Get_Client_Discord_ID(source)
		if discord_id then
			-- Check if user is in the guild
			local guilds = GetDiscordRoles(cfg.Guilds['MAIN'], discord_id)
			if not guilds then
				-- If user is not in the guild, drop the connection
				print('Blaaammm, User is not in the guild!!')
				DropPlayer(source, 'You must join our Discord guild to play on this server. Please join at discord.gg/LUNA5M')
				return
			end

			Discord_Sources[discord_id] = {user_source = source, user_id = user_id}
			Modify_Client_Roles('MAIN', discord_id, user_id)
			Modify_Client_Roles('Police', discord_id, user_id)
			Modify_Client_Roles('NHS', discord_id, user_id)
			Modify_Client_Roles('HMP', discord_id, user_id)
			--Modify_Client_Roles('LFB', discord_id, user_id)
		end
	end
end


local function Get_Guild_Nickname(guild_id, discord_id)
	local endpoint = ("guilds/%s/members/%s"):format(guild_id, discord_id)
	local member = DiscordRequest("GET", endpoint, {})
	if member.code == 200 then
		local data = json.decode(member.data)
		local nickname = data.nick
		return nickname
	else
		return nil
	end
end

exports('Get_Client_Discord_ID', function(source)
	return Get_Client_Discord_ID(source)
end)

exports('Get_Guild_Nickname', function(guild_id, discord_id)
	return Get_Guild_Nickname(guild_id, discord_id)
end)

exports('Get_Guilds', function()
	return cfg.Guilds
end)

exports('Get_User_Source', function(user_discord_id)
	return Discord_Sources[user_discord_id]
end)

local function Get_Guild_Status(guild)
	if guild.code == 200 then
		local data = json.decode(guild.data)
		print(("Successful connection to Guild: %s (%s)"):format(data.name, data.id))
  	else
		print(("An error occured, please check your config and ensure everything is correct. Error: %s"):format(guild.data and json.decode(guild.data) or guild.code))
  	end
end

Citizen.CreateThread(function()
	if cfg.Multiguild then 
		for _, guildID in pairs(cfg.Guilds) do
			local guild = DiscordRequest("GET", "guilds/" .. guildID, {})
			Get_Guild_Status(guild)
		end
	else
		local guild = DiscordRequest("GET", "guilds/" .. cfg.Guild_ID, {})
		Get_Guild_Status(guild)
	end
end)

function tLUNA.checkForRole(user_id, role_id)
	local discord_id = GetIdentifier(source, 'discord')
	if discord_id then
		return discord_id:gsub('discord:', '')
	else
		return false
	end
	local endpoint = ("guilds/%s/members/%s"):format(cfg.Guild_ID, discord_id)
	local member = DiscordRequest("GET", endpoint, {})
	if member.code == 200 then
		local data = json.decode(member.data)
		if data then
			local has_role = Client_Has_Role(data.roles, role_id)
			return has_role
		end
	end
	return false
end