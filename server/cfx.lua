if Config.notlauch.master then
    return
end

if Config.cfxid.master then

        local function OnPlayerConnecting(name, setKickReason, deferrals)
            local player = source
            local cfxIdentifier
            local identifiers = GetPlayerIdentifiers(player)
            deferrals.defer()
        
            -- mandatory wait!
            Wait(500)
        
            deferrals.update(string.format(Config.cfxid.Checkinglocale, name))
        
            for _, v in pairs(identifiers) do
                if string.find(v, "fivem") then
                    cfxIdentifier = v
                    break
                end
            end
        
            -- mandatory wait!
            Wait(500)
        
            if not cfxIdentifier then
                deferrals.done(Config.cfxid.yescfxlocale)
            else   
                deferrals.done()
            end
        end
        
        AddEventHandler("playerConnecting", OnPlayerConnecting)

end