Config = {}

-- Steam configuration
Config.steam = {
    master = true,  -- Enable or disable Steam verification system
    nosteam = false,  -- Kick players who have Steam running (true/false)
    yessteam = false,  -- Allow players with Steam running (true/false)
    Checkinglocale = "Hello %s, your Steam ID is being checked.",  -- Message shown during verification
    yessteamlocale = "You are not connected to Steam.",  -- Message when Steam isn't detected
    nosteamlocale = "You are connected to Steam. Please close it and reconnect."  -- Message when Steam is detected but not allowed
}

-- Developer mode configuration
Config.devmode = {
    master = true,  -- Enable or disable developer mode system
    steam = false,  -- Use Steam Hex verification for developers (true/false)
    steamHex = {  -- Whitelist of developer Steam Hex IDs
        -- Format: "steam:110000112345678"
    },
    discord = true,  -- Enable Discord role verification for developers (true/false)
    guildId = "",  -- Discord server ID for developer verification
    roleId = "",  -- Discord role ID required for developer access
    -- Note: Bot token is configured in server/devmode.lua
}

-- CFX ID configuration
Config.cfxid = {
    master = true,  -- Enable or disable CFX ID verification system
    Checkinglocale = "Hello %s, your CFX ID is being checked.",  -- Verification in-progress message
    yescfxlocale = "You are not connected to a CFX ID."  -- Message when CFX ID is missing
}

Config.notlauch = {
    master = true,  -- Enable or disable launch verification system
    discordLink = "https://discord.gg/8DDA5QJu98",  -- Discord invite shown if verification fails
}

Config.que = {
    master = true,  -- Enable or disable queue system
    serverName = "Your Server Name",  -- Displayed in queue interface
    serverLogo = "https://your-logo-url.png",  -- URL to server logo image
    maxPlayers = 64,  -- Maximum allowed players
    refreshTime = 5000,  -- How often queue updates (in milliseconds)
    
    discordRoles = {  -- Priority roles for queue skipping
        ["VIP"] = {roleId = "VIP_ROLE_ID", priority = 100, color = "#e74c3c"},  -- Highest priority
        ["Premium"] = {roleId = "PREMIUM_ROLE_ID", priority = 75, color = "#f1c40f"},  -- Medium priority
        ["Member"] = {roleId = "MEMBER_ROLE_ID", priority = 50, color = "#3498db"},  -- Low priority
        ["Default"] = {roleId = "DEFAULT_ROLE_ID", priority = 0, color = "#95a5a6"}  -- Default/no priority
    },
    
    websiteUrl = "https://your-website.com"  -- Shown in queue interface
}