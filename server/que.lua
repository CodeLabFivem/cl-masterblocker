if Config.notlauch.master then
    return
end

if Config.que.master then
    -- Queue variables
    local Queue = {}
    local PlayerInfo = {}
    local currentPlayers = 0

    -- Function to get player's discord roles using Badger_Discord_API
    function GetPlayerDiscordRoles(source)
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
        
        -- Get all roles for the user
        local playerRoles = exports.Badger_Discord_API:GetDiscordRoles(source)
        
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

    -- Function to generate loading animation
    function GetLoadingAnimation(position)
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

    -- Function to create loading card HTML
-- Fix for the presentCard function in GenerateLoadingCard
function GenerateLoadingCard(source, queueData)
    local position = GetQueuePosition(source)
    local loadingBar = GetLoadingAnimation(position)
    local estimatedWait = position * 10 -- Simple calculation, 10 seconds per position
    local waitingText = "Please wait"
    
    if estimatedWait < 60 then
        waitingText = waitingText .. " (Estimated time: " .. estimatedWait .. " seconds)"
    else
        waitingText = waitingText .. " (Estimated time: " .. math.floor(estimatedWait / 60) .. " minutes)"
    end
    
    -- Create a properly escaped HTML string
    local html = [[<!DOCTYPE html>
<html>
<head>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap');
        body {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            background-color: rgba(0, 0, 0, 0.7);
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            overflow: hidden;
        }
        .container {
            width: 500px;
            background-color: rgba(23, 23, 23, 0.9);
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
            overflow: hidden;
            text-align: center;
        }
        .header {
            padding: 20px;
            background-color: rgba(40, 40, 40, 0.9);
            border-bottom: 2px solid rgba(255, 255, 255, 0.1);
        }
        .server-logo {
            width: 100px;
            height: 100px;
            margin: 0 auto 10px;
            border-radius: 50%;
            background-image: url(']] .. Config.que.serverLogo .. [[');
            background-size: cover;
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
        }
        h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 700;
        }
        .content {
            padding: 20px;
        }
        .queue-position {
            font-size: 18px;
            margin-bottom: 20px;
        }
        .position-number {
            font-size: 32px;
            font-weight: 700;
            color: ]] .. queueData.roleColor .. [[;
        }
        .loading-bar {
            margin: 20px 0;
            font-size: 24px;
            letter-spacing: 3px;
        }
        .info {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            padding: 10px;
            background-color: rgba(40, 40, 40, 0.6);
            border-radius: 5px;
        }
        .info-item {
            text-align: center;
            flex: 1;
        }
        .info-value {
            font-size: 22px;
            font-weight: 700;
        }
        .role-badge {
            display: inline-block;
            padding: 5px 10px;
            background-color: ]] .. queueData.roleColor .. [[;
            border-radius: 15px;
            font-weight: 600;
            font-size: 14px;
            margin-top: 5px;
        }
        .footer {
            padding: 15px;
            background-color: rgba(40, 40, 40, 0.9);
            border-top: 2px solid rgba(255, 255, 255, 0.1);
            font-size: 14px;
        }
        .footer a {
            color: ]] .. queueData.roleColor .. [[;
            text-decoration: none;
        }
        .footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="server-logo"></div>
            <h1>]] .. Config.que.serverName .. [[</h1>
        </div>
        <div class="content">
            <div class="queue-position">
                You are in queue position: <span class="position-number">]] .. position .. [[</span>
            </div>
            <div>]] .. waitingText .. [[</div>
            <div class="loading-bar">]] .. loadingBar .. [[</div>
            <div class="info">
                <div class="info-item">
                    <div>Players</div>
                    <div class="info-value">]] .. currentPlayers .. [[/]] .. Config.que.maxPlayers .. [[</div>
                </div>
                <div class="info-item">
                    <div>Your Role</div>
                    <div class="role-badge">]] .. queueData.role .. [[</div>
                </div>
            </div>
        </div>
        <div class="footer">
            Visit our website: <a href="]] .. Config.que.websiteUrl .. [[" target="_blank">]] .. Config.que.websiteUrl .. [[</a>
        </div>
    </div>
</body>
</html>]]    
    local card = {
        type = "AdaptiveCard",
        version = "1.0",
        body = {
            {
                type = "Container",
                items = {
                    {
                        type = "TextBlock",
                        text = Config.que.serverName,
                        weight = "bolder",
                        size = "large"
                    },
                    {
                        type = "TextBlock",
                        text = "Queue Position: " .. position,
                        weight = "bolder",
                        size = "medium"
                    },
                    {
                        type = "TextBlock",
                        text = waitingText,
                        isSubtle = true
                    },
                    {
                        type = "TextBlock",
                        text = "Players: " .. currentPlayers .. "/" .. Config.que.maxPlayers,
                        isSubtle = true
                    },
                    {
                        type = "TextBlock",
                        text = "Role: " .. queueData.role,
                        isSubtle = true
                    }
                }
            }
        }
    }
    
    -- Two options to fix the issue:
    
    -- Option 1: Use an Adaptive Card (JSON format)
    local jsonCard = json.encode(card)
    return jsonCard
    
    -- Option 2: If the server supports HTML cards, use this instead:
    -- return { html = html }
end

-- And in the ProcessQueue function, update how we present the card:
function ProcessQueue(source, name, deferrals, roleData, currentTime)
    -- [existing code]
    
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
                local cardData = GenerateLoadingCard(source, queueData)
                
                -- Option 1: If using JSON Adaptive Card
                deferrals.presentCard(cardData)
                
                -- Option 2: If your server supports HTML cards
                -- deferrals.presentCard(cardData.html, function(data, rawData) end)
            end
        end
    end
end

    -- Process player connection
    AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
        local source = source
        local currentTime = GetGameTimer()
        
        deferrals.defer()
        deferrals.update("Checking your Discord roles...")
        
        -- Process the player's queue position with Badger_Discord_API
        Citizen.Wait(500) -- Small delay to ensure Discord info is loaded
        
        -- Get role data using the new function
        local roleData = GetPlayerDiscordRoles(source)
        
        -- Process the queue with the obtained role data
        ProcessQueue(source, name, deferrals, roleData, currentTime)
    end)

    -- Function to process the queue after role determination
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
                    local cardHtml = GenerateLoadingCard(source, queueData)
                    deferrals.presentCard(cardHtml, function(data, rawData) end)
                end
            end
        end
    end

    -- Handle disconnects
    AddEventHandler('playerDropped', function(reason)
        local source = source
        
        -- Remove from queue if present
        for i, player in ipairs(Queue) do
            if player.source == source then
                table.remove(Queue, i)
                break
            end
        end
        
        -- Clean up player info
        PlayerInfo[tostring(source)] = nil
    end)

    -- Optionally, add command to see queue status for admins
    RegisterCommand("queuestatus", function(source, args, rawCommand)
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

    -- Add command to refresh the queue (admin only)
    RegisterCommand("refreshqueue", function(source, args, rawCommand)
        if source == 0 or IsPlayerAceAllowed(source, "command.refreshqueue") then
            SortQueue()
            print("^2[QUEUE] Queue has been refreshed and sorted.")
        end
    end, false)

    print("^2[QUEUE] Queue system with Discord priorities loaded successfully.")
end