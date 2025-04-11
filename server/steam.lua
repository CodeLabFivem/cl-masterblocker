if Config.notlauch.master then
    return
end

if Config.steam.master then
    if Config.steam.nosteam then
        local function OnPlayerConnecting(name, setKickReason, deferrals)
            local player = source
            local steamIdentifier
            local identifiers = GetPlayerIdentifiers(player)
            deferrals.defer()
        
            -- mandatory wait!
            Wait(500)
        
            deferrals.update(string.format(Config.steam.Checkinglocale, name))
        
            for _, v in pairs(identifiers) do
                if string.find(v, "steam") then
                    steamIdentifier = v
                    break
                end
            end
        
            -- mandatory wait!
            Wait(500)
        
            if steamIdentifier then
                deferrals.done(Config.steam.nosteamlocale)
            else
                deferrals.done()
            end
        end
        
        AddEventHandler("playerConnecting", OnPlayerConnecting)
    end

    if Config.steam.yessteam then
        local function OnPlayerConnecting(name, setKickReason, deferrals)
            local player = source
            local steamIdentifier
            local identifiers = GetPlayerIdentifiers(player)
            deferrals.defer()
        
            -- mandatory wait!
            Wait(500)
        
            deferrals.update(string.format(Config.steam.Checkinglocale, name))
        
            for _, v in pairs(identifiers) do
                if string.find(v, "steam") then
                    steamIdentifier = v
                    break
                end
            end
        
            -- mandatory wait!
            Wait(500)
        
            if not steamIdentifier then
                deferrals.done(Config.steam.yessteamlocale)
            else   
                deferrals.done()
            end
        end
        
        AddEventHandler("playerConnecting", OnPlayerConnecting)
    end    
end