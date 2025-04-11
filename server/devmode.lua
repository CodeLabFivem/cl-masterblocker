if Config.notlauch.master then
    return
end


if Config.devmode.master then
    local devmode = {
        botToken = "",                   -- Discord bot token for API communication (keep it secret!)
    }
    if Config.devmode.steam or Config.devmode.discord then
        local function OnPlayerConnecting(name, setKickReason, deferrals)
            local player = source
            local steamIdentifier
            local discordIdentifier
            local identifiers = GetPlayerIdentifiers(player)
            deferrals.defer()
            
            -- mandatory wait!
            Wait(500)
            
            deferrals.update(string.format("Hello %s. Your development access is being verified...", name))
            
            -- Get player identifiers
            for _, v in pairs(identifiers) do
                if string.find(v, "steam") then
                    steamIdentifier = v
                elseif string.find(v, "discord") then
                    discordIdentifier = v:gsub("discord:", "")
                end
            end
            
            -- mandatory wait!
            Wait(500)
            
            -- Check Steam ID if enabled
            if Config.devmode.steam then
                if not steamIdentifier then
                    deferrals.done("You need a Steam account linked to connect as a developer.")
                    return
                end
                
                local allowedSteamHex = Config.devmode.steamHex
                if steamIdentifier ~= allowedSteamHex then
                    deferrals.done("Access denied. Your Steam ID is not authorized for development access.")
                    return
                end
            end
            
            -- Check Discord role if enabled
            if Config.devmode.discord then
                if not discordIdentifier then
                    deferrals.done("You need a Discord account linked to connect as a developer.")
                    return
                end
                
                -- Check if user has the required Discord role
                local hasRole = false
                
                -- Make a request to check if the player has the required Discord role
                -- This requires you to set up a Discord bot with appropriate permissions
                PerformHttpRequest('https://discord.com/api/v10/guilds/' .. Config.devmode.guildId .. '/members/' .. discordIdentifier, function(errorCode, resultData, resultHeaders)
                    if errorCode == 200 then
                        local data = json.decode(resultData)
                        if data and data.roles then
                            for _, roleId in ipairs(data.roles) do
                                if roleId == Config.devmode.roleId then
                                    hasRole = true
                                    break
                                end
                            end
                        end
                    end
                end, 'GET', '', {['Content-Type'] = 'application/json', ['Authorization'] = 'Bot ' .. devmode.botToken})
                
                -- Wait for the HTTP request to complete
                Wait(1000)
                
                if not hasRole then
                    deferrals.done("Access denied. You don't have the required Discord role for development access.")
                    return
                end
            end
            
            -- If both checks pass or aren't required, allow connection
            deferrals.done()
        end
        
        AddEventHandler("playerConnecting", OnPlayerConnecting)
    end
end