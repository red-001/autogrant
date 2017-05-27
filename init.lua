local setting_string = minetest.settings:get("auto_grant_priv") or ""
local privs_to_grant = setting_string:split(",")
minetest.register_on_joinplayer(function(player)
	local granted_privs = minetest.deserialize(player:get_attribute("autogrant:granted"))
	if not granted_privs then granted_privs = {} end
	local player_privs = core.get_player_privs(player:get_player_name())

	for i = #privs_to_grant, 1, -1 do
		local priv = privs_to_grant[i]
		local granted = false
		for _, granted_priv in ipairs(granted_privs) do
			if granted_priv == priv then
				granted = true
				break
			end
		end

		if core.registered_privileges[priv] then
			if not granted then
				player_privs[priv] = true
			end
		else
			table.remove(privs_to_grant, i)
			minetest.log("error", "Couldn't grant unknown priv: '" .. priv .. "'")
		end
	end

	core.set_player_privs(player:get_player_name(), player_privs)
	player:set_attribute("autogrant:granted", minetest.serialize(privs_to_grant))
end)
