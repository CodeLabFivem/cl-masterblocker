-- Combined Connection Handler Script
-- Combines notlaunch, queue, steam, cfx, and devmode verification systems

-- Load config here or assume it's loaded elsewhere
-- Config = {}

-- Custom Card Generator
local botToken = ""
local CardGenerator = {}

-- Generate appropriate card based on rejection reason or queue status
function CardGenerator.Generate(reason, data)
    if reason == "not_launched" then
        return CardGenerator.NotLaunched(data.discordLink)
    elseif reason == "queue" then
        return CardGenerator.QueueCard(data)
    elseif reason == "steam_required" then
        return CardGenerator.SteamRequired()
    elseif reason == "steam_forbidden" then
        return CardGenerator.SteamForbidden()
    elseif reason == "cfx_required" then
        return CardGenerator.CfxRequired()
    elseif reason == "dev_only" then
        return CardGenerator.DevOnly()
    end
end

-- Not launched card
function CardGenerator.NotLaunched(discordLink)
    local link = discordLink or "https://discord.gg/8DDA5QJu98"
    local serverLogo = "https://i.imgur.com/TiUV5Jw.png"
    local serverName = "SERVER NAME"
    
    if Config.notlauch then
        if Config.notlauch.serverLogo then
            serverLogo = Config.notlauch.serverLogo
        end
        if Config.notlauch.serverName then
            serverName = Config.notlauch.serverName
        end
    end
    
    local cardJson = [[
    {
        "type": "AdaptiveCard",
        "version": "1.0",
        "body": [
            {
                "type": "Image",
                "url": "]] .. serverLogo .. [[",
                "horizontalAlignment": "center",
                "size": "medium"
            },
            {
                "type": "TextBlock",
                "text": "🚧 ]] .. serverName .. [[",
                "horizontalAlignment": "center",
                "weight": "bolder",
                "size": "large",
                "color": "attention"
            },
            {
                "type": "TextBlock",
                "text": "The server is currently not launched.",
                "horizontalAlignment": "center",
                "size": "medium",
                "wrap": true
            },
            {
                "type": "TextBlock",
                "text": "Join our Discord to stay updated on progress and announcements.",
                "horizontalAlignment": "center",
                "wrap": true
            }
        ],
        "actions": [
            {
                "type": "Action.OpenUrl",
                "title": "🔗 Join Discord",
                "url": "]] .. link .. [["
            }
        ],
        "$schema": "http://adaptivecards.io/schemas/adaptive-card.json"
    }
    ]]
    
    return cardJson
end

-- Function to generate loading animation
function GetLoadingAnimation()
    local dots = {"⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛",
                  "⬜⬛⬛⬛⬛⬛⬛⬛⬛⬛",
                  "⬜⬜⬛⬛⬛⬛⬛⬛⬛⬛",
                  "⬜⬜⬜⬛⬛⬛⬛⬛⬛⬛",
                  "⬜⬜⬜⬜⬛⬛⬛⬛⬛⬛",
                  "⬜⬜⬜⬜⬜⬛⬛⬛⬛⬛",
                  "⬜⬜⬜⬜⬜⬜⬛⬛⬛⬛",
                  "⬜⬜⬜⬜⬜⬜⬜⬛⬛⬛",
                  "⬜⬜⬜⬜⬜⬜⬜⬜⬛⬛",
                  "⬜⬜⬜⬜⬜⬜⬜⬜⬜⬛"}
    
    local index = (math.floor(GetGameTimer() / 500) % #dots) + 1
    return dots[index]
end

-- Queue card
function CardGenerator.QueueCard(data)
    local position = data.position
    local loadingBar = GetLoadingAnimation()
    local estimatedWait = position * 10 -- Simple calculation, 10 seconds per position
    local waitingText = "Please wait"
    
    if estimatedWait < 60 then
        waitingText = waitingText .. " (Estimated time: " .. estimatedWait .. " seconds)"
    else
        waitingText = waitingText .. " (Estimated time: " .. math.floor(estimatedWait / 60) .. " minutes)"
    end
    
    -- Get server logo and website URL from config
    local serverLogo = "https://i.imgur.com/TiUV5Jw.png"
    local websiteUrl = "https://example.com"
    local serverName = "SERVER NAME"
    
    if Config.que then
        if Config.que.serverLogo then
            serverLogo = Config.que.serverLogo
        end
        if Config.que.websiteUrl then
            websiteUrl = Config.que.websiteUrl
        end
        if Config.que.serverName then
            serverName = Config.que.serverName
        end
    end
    
    local roleColor = data.roleColor or "accent"
    if roleColor:sub(1,1) ~= "#" then
        roleColor = "accent" -- Default to "accent" if not a valid color format
    end
    
    local cardJson = [[
    {
        "type": "AdaptiveCard",
        "version": "1.0",
        "body": [
            {
                "type": "Image",
                "url": "]] .. serverLogo .. [[",
                "horizontalAlignment": "center",
                "size": "medium"
            },
            {
                "type": "TextBlock",
                "text": "]] .. serverName .. [[",
                "horizontalAlignment": "center",
                "weight": "bolder",
                "size": "large"
            },
            {
                "type": "TextBlock",
                "text": "Queue Position: ]] .. position .. [[",
                "horizontalAlignment": "center",
                "weight": "bolder",
                "size": "medium"
            },
            {
                "type": "TextBlock",
                "text": "]] .. waitingText .. [[",
                "horizontalAlignment": "center"
            },
            {
                "type": "TextBlock",
                "text": "]] .. loadingBar .. [[",
                "horizontalAlignment": "center",
                "size": "medium"
            },
            {
                "type": "ColumnSet",
                "columns": [
                    {
                        "type": "Column",
                        "width": "stretch",
                        "items": [
                            {
                                "type": "TextBlock",
                                "text": "Players",
                                "horizontalAlignment": "center"
                            },
                            {
                                "type": "TextBlock",
                                "text": "]] .. data.currentPlayers .. [[/]] .. Config.que.maxPlayers .. [[",
                                "horizontalAlignment": "center",
                                "weight": "bolder"
                            }
                        ]
                    },
                    {
                        "type": "Column",
                        "width": "stretch",
                        "items": [
                            {
                                "type": "TextBlock",
                                "text": "Your Role",
                                "horizontalAlignment": "center"
                            },
                            {
                                "type": "TextBlock",
                                "text": "]] .. data.role .. [[",
                                "horizontalAlignment": "center",
                                "weight": "bolder"
                            }
                        ]
                    }
                ]
            }
        ],
        "actions": [
            {
                "type": "Action.OpenUrl",
                "title": "Visit Our Website",
                "url": "]] .. websiteUrl .. [["
            }
        ],
        "$schema": "http://adaptivecards.io/schemas/adaptive-card.json"
    }
    ]]
    
    return cardJson
end

-- Steam required card
function CardGenerator.SteamRequired()
    local logo = "https://i.imgur.com/TiUV5Jw.png"
    local message = "You must have Steam running to connect to this server."
    
    if Config.steam then
        if Config.steam.logo then
            logo = Config.steam.logo
        end
        if Config.steam.yessteamlocale then
            message = Config.steam.yessteamlocale
        end
    end
    
    local cardJson = [[
    {
        "type": "AdaptiveCard",
        "version": "1.0",
        "body": [
            {
                "type": "Image",
                "url": "]] .. logo .. [[",
                "horizontalAlignment": "center",
                "size": "medium"
            },
            {
                "type": "TextBlock",
                "text": "⚠️ Connection Failed",
                "horizontalAlignment": "center",
                "weight": "bolder",
                "size": "large",
                "color": "attention"
            },
            {
                "type": "TextBlock",
                "text": "]] .. message .. [[",
                "horizontalAlignment": "center",
                "size": "medium",
                "wrap": true
            }
        ],
        "actions": [
            {
                "type": "Action.OpenUrl",
                "title": "🔗 Get Steam",
                "url": "https://store.steampowered.com/about/"
            }
        ],
        "$schema": "http://adaptivecards.io/schemas/adaptive-card.json"
    }
    ]]
    
    return cardJson
end

-- Steam forbidden card
function CardGenerator.SteamForbidden()
    local logo = "https://i.imgur.com/TiUV5Jw.png"
    local message = "This server does not allow Steam connections."
    
    if Config.steam then
        if Config.steam.logo then
            logo = Config.steam.logo
        end
        if Config.steam.nosteamlocale then
            message = Config.steam.nosteamlocale
        end
    end
    
    local cardJson = [[
    {
        "type": "AdaptiveCard",
        "version": "1.0",
        "body": [
            {
                "type": "Image",
                "url": "]] .. logo .. [[",
                "horizontalAlignment": "center",
                "size": "medium"
            },
            {
                "type": "TextBlock",
                "text": "⚠️ Connection Failed",
                "horizontalAlignment": "center",
                "weight": "bolder",
                "size": "large",
                "color": "attention"
            },
            {
                "type": "TextBlock",
                "text": "]] .. message .. [[",
                "horizontalAlignment": "center",
                "size": "medium",
                "wrap": true
            }
        ],
        "$schema": "http://adaptivecards.io/schemas/adaptive-card.json"
    }
    ]]
    
    return cardJson
end

-- CFX required card
function CardGenerator.CfxRequired()
    local logo = "https://i.imgur.com/TiUV5Jw.png"
    local message = "You must have a CFX ID to connect to this server."
    
    if Config.cfxid then
        if Config.cfxid.logo then
            logo = Config.cfxid.logo
        end
        if Config.cfxid.yescfxlocale then
            message = Config.cfxid.yescfxlocale
        end
    end
    
    local cardJson = [[
    {
        "type": "AdaptiveCard",
        "version": "1.0",
        "body": [
            {
                "type": "Image",
                "url": "]] .. logo .. [[",
                "horizontalAlignment": "center",
                "size": "medium"
            },
            {
                "type": "TextBlock",
                "text": "⚠️ Connection Failed",
                "horizontalAlignment": "center",
                "weight": "bolder",
                "size": "large",
                "color": "attention"
            },
            {
                "type": "TextBlock",
                "text": "]] .. message .. [[",
                "horizontalAlignment": "center",
                "size": "medium",
                "wrap": true
            }
        ],
        "$schema": "http://adaptivecards.io/schemas/adaptive-card.json"
    }
    ]]
    
    return cardJson
end

-- Dev only card
function CardGenerator.DevOnly()
    local logo = "https://i.imgur.com/TiUV5Jw.png"
    
    if Config.devmode and Config.devmode.logo then
        logo = Config.devmode.logo
    end
    
    local cardJson = [[
    {
        "type": "AdaptiveCard",
        "version": "1.0",
        "body": [
            {
                "type": "Image",
                "url": "]] .. logo .. [[",
                "horizontalAlignment": "center",
                "size": "medium"
            },
            {
                "type": "TextBlock",
                "text": "🔒 Development Access Only",
                "horizontalAlignment": "center",
                "weight": "bolder",
                "size": "large",
                "color": "attention"
            },
            {
                "type": "TextBlock",
                "text": "This server is currently in development mode and only authorized developers can connect.",
                "horizontalAlignment": "center",
                "size": "medium",
                "wrap": true
            }
        ],
        "$schema": "http://adaptivecards.io/schemas/adaptive-card.json"
    }
    ]]
    
    return cardJson
end

-- Queue System Variables
local Queue = {}
local PlayerInfo = {}
local currentPlayers = 0

-- Function to get player's discord roles using Badger_Discord_API
function GetPlayerDiscordRoles(source)
    if not Config.que or not Config.que.master then
        return {priority = 0, role = "Default", color = "#808080"}
    end
    
    local identifiers = GetPlayerIdentifiers(source)
    local discordId = nil
    
    for _, identifier in pairs(identifiers) do
        if string.find(identifier, "discord:") then
            discordId = string.gsub(identifier, "discord:", "")
            break
        end
    end
    
    if not discordId then
        return {priority = 0, role = "Default", color = Config.que.discordRoles["Default"].color}
    end
    
    -- Get all roles for the user if Badger_Discord_API is available
    local playerRoles = nil
    if exports.Badger_Discord_API then
        playerRoles = exports.Badger_Discord_API:GetDiscordRoles(source)
    end
    
    if not playerRoles then
        return {priority = 0, role = "Default", color = Config.que.discordRoles["Default"].color}
    end
    
    -- Get highest priority role
    local highestPriority = 0
    local highestRole = "Default"
    local roleColor = Config.que.discordRoles["Default"].color
    
    for roleName, roleData in pairs(Config.que.discordRoles) do
        for _, roleId in ipairs(playerRoles) do
            if tostring(roleId) == tostring(roleData.roleId) and roleData.priority > highestPriority then
                highestPriority = roleData.priority
                highestRole = roleName
                roleColor = roleData.color
            end
        end
    end
    
    return {priority = highestPriority, role = highestRole, color = roleColor}
end

-- Function to get queue position
function GetQueuePosition(source)
    for i, player in ipairs(Queue) do
        if player.source == source then
            return i
        end
    end
    return #Queue + 1
end

-- Function to sort queue by priority
function SortQueue()
    table.sort(Queue, function(a, b)
        if a.priority == b.priority then
            return a.joinTime < b.joinTime -- If same priority, first come first serve
        end
        return a.priority > b.priority -- Higher priority first
    end)
end

-- Check if player has developer access
function HasDevAccess(source, identifiers)
    if not Config.devmode or not Config.devmode.master then
        return true
    end
    
    local steamIdentifier = nil
    local discordIdentifier = nil
    
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
        elseif string.find(v, "discord") then
            discordIdentifier = v:gsub("discord:", "")
        end
    end
    
    -- Check Steam ID if enabled
    if Config.devmode.steam then
        if not steamIdentifier then
            return false, "You need a Steam account linked to connect as a developer."
        end
        
        local allowedSteamHex = Config.devmode.steamHex
        if steamIdentifier ~= allowedSteamHex then
            return false, "Access denied. Your Steam ID is not authorized for development access."
        end
    end
    
    -- Check Discord role if enabled
    if Config.devmode.discord then
        if not discordIdentifier then
            return false, "You need a Discord account linked to connect as a developer."
        end
        
        -- Check if user has the required Discord role
        local hasRole = false
        
        -- Make a request to check if the player has the required Discord role
        -- This assumes you have a Discord bot token in Config.devmode.botToken
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
        end, 'GET', '', {['Content-Type'] = 'application/json', ['Authorization'] = 'Bot ' .. botToken})
        
        -- Wait for the HTTP request to complete
        Wait(1000)
        
        if not hasRole then
            return false, "Access denied. You don't have the required Discord role for development access."
        end
    end
    
    return true
end

-- Check Steam and CFX requirements
function CheckIdentifiers(source, identifiers)
    local steamIdentifier = nil
    local cfxIdentifier = nil
    
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
        elseif string.find(v, "fivem") then
            cfxIdentifier = v
        end
    end
    
    -- Check Steam requirements if enabled
    if Config.steam and Config.steam.master then
        if Config.steam.nosteam and steamIdentifier then
            return false, "steam_forbidden"
        elseif Config.steam.yessteam and not steamIdentifier then
            return false, "steam_required"
        end
    end
    
    -- Check CFX requirement if enabled
    if Config.cfxid and Config.cfxid.master and not cfxIdentifier then
        return false, "cfx_required"
    end
    
    return true
end

-- Process player connection in queue
function ProcessQueue(source, name, deferrals, roleData, currentTime)
    local queueData = {
        source = source,
        name = name,
        priority = roleData.priority,
        role = roleData.role,
        roleColor = roleData.color,
        joinTime = currentTime
    }
    
    -- Add player to queue
    table.insert(Queue, queueData)
    SortQueue() -- Sort queue by priority
    
    -- Store player info
    PlayerInfo[tostring(source)] = queueData
    
    -- Keep updating the card while in queue
    local queuePosition = 0
    local lastCard = 0
    
    while true do
        Citizen.Wait(500)
        
        currentPlayers = #GetPlayers()
        local allowJoin = (currentPlayers < Config.que.maxPlayers) and (GetQueuePosition(source) == 1)
        
        if allowJoin then
            -- Let the player join
            for i, player in ipairs(Queue) do
                if player.source == source then
                    table.remove(Queue, i)
                    break
                end
            end
            
            deferrals.done()
            return
        else
            local newPosition = GetQueuePosition(source)
            
            -- Update card every few seconds or when position changes
            if (GetGameTimer() - lastCard > Config.que.refreshTime) or (queuePosition ~= newPosition) then
                queuePosition = newPosition
                lastCard = GetGameTimer()
                
                -- Generate and present card
                local cardData = {
                    position = queuePosition,
                    currentPlayers = currentPlayers,
                    role = queueData.role,
                    roleColor = queueData.roleColor
                }
                local cardJson = CardGenerator.Generate("queue", cardData)
                
                -- Present card
                deferrals.presentCard(cardJson)
            end
        end
    end
end

-- Main connection handler
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local source = source
    local identifiers = GetPlayerIdentifiers(source)
    local currentTime = GetGameTimer()
    
    deferrals.defer()
    Wait(100)
    
    -- Step 1: Check if server is not launched
    if Config.notlauch and Config.notlauch.master then
        local discordLink = Config.notlauch.discordLink or "https://discord.gg/8DDA5QJu98"
        local cardJson = CardGenerator.Generate("not_launched", {discordLink = discordLink})
        
        deferrals.presentCard(cardJson)
        Wait(10000)
        deferrals.done("🔒 Server not launched. Join our Discord for updates.")
        return
    end
    
    -- Step 2: Check if devmode is enabled and if player has access
    if Config.devmode and Config.devmode.master and (Config.devmode.steam or Config.devmode.discord) then
        deferrals.update("Verifying developer access...")
        Wait(500)
        
        local hasAccess, reason = HasDevAccess(source, identifiers)
        if not hasAccess then
            local cardJson = CardGenerator.Generate("dev_only")
            deferrals.presentCard(cardJson)
            Wait(1000)
            deferrals.done(reason)
            return
        end
    end
    
    -- Step 3: Check Steam and CFX requirements
    deferrals.update("Checking connection requirements...")
    Wait(500)
    
    local identifiersOK, rejectReason = CheckIdentifiers(source, identifiers)
    if not identifiersOK then
        local cardJson = CardGenerator.Generate(rejectReason)
        deferrals.presentCard(cardJson)
        Wait(1000)
        
        if rejectReason == "steam_forbidden" then
            deferrals.done(Config.steam.nosteamlocale or "This server does not allow Steam connections.")
        elseif rejectReason == "steam_required" then
            deferrals.done(Config.steam.yessteamlocale or "You must have Steam running to connect to this server.")
        elseif rejectReason == "cfx_required" then
            deferrals.done(Config.cfxid.yescfxlocale or "You must have a CFX ID to connect to this server.")
        end
        return
    end
    
    -- Step 4: Queue system if enabled
    if Config.que and Config.que.master then
        deferrals.update("Checking Discord roles for queue position...")
        Wait(500)
        
        -- Get role data
        local roleData = GetPlayerDiscordRoles(source)
        
        -- Process the queue with the obtained role data
        ProcessQueue(source, name, deferrals, roleData, currentTime)
    else
        -- If no queue system, allow connection
        deferrals.done()
    end
end)

-- Handle disconnects for queue management
AddEventHandler('playerDropped', function(reason)
    local source = source
    
    -- Remove from queue if present
    if Config.que and Config.que.master then
        for i, player in ipairs(Queue) do
            if player.source == source then
                table.remove(Queue, i)
                break
            end
        end
        
        -- Clean up player info
        PlayerInfo[tostring(source)] = nil
    end
end)

-- Admin command to see queue status
RegisterCommand("queuestatus", function(source, args, rawCommand)
    if not Config.que or not Config.que.master then
        return
    end
    
    if source == 0 or IsPlayerAceAllowed(source, "command.queuestatus") then
        print("^2[QUEUE] Current Queue Status:")
        print("^3Players Online: " .. currentPlayers .. "/" .. Config.que.maxPlayers)
        print("^3Queue Length: " .. #Queue)
        
        if #Queue > 0 then
            for i, player in ipairs(Queue) do
                print("^3" .. i .. ". " .. player.name .. " - Role: " .. player.role .. " - Priority: " .. player.priority)
            end
        else
            print("^3No players in queue.")
        end
    end
end, false)

-- Admin command to refresh the queue
RegisterCommand("refreshqueue", function(source, args, rawCommand)
    if not Config.que or not Config.que.master then
        return
    end
    
    if source == 0 or IsPlayerAceAllowed(source, "command.refreshqueue") then
        SortQueue()
        print("^2[QUEUE] Queue has been refreshed and sorted.")
    end
end, false)

print("^2[CONNECTION SYSTEM] Combined connection handler loaded successfully.")