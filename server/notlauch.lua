if Config.notlauch.master then
    local function OnPlayerConnecting(name, setKickReason, deferrals)
        deferrals.defer()
        Wait(100)

        local discordLink = Config.notlauch.discordLink or "https://discord.gg/8DDA5QJu98"

        local cardJson = [[
            {
                "type": "AdaptiveCard",
                "version": "1.0",
                "body": [
                    {
                        "type": "Image",
                        "url": "https://i.imgur.com/TiUV5Jw.png",
                        "horizontalAlignment": "center",
                        "size": "medium"
                    },
                    {
                        "type": "TextBlock",
                        "text": "🚧 SERVER NAME",
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
                        "url": "]] .. discordLink .. [["
                    }
                ],
                "$schema": "http://adaptivecards.io/schemas/adaptive-card.json"
            }
        ]]

        deferrals.presentCard(cardJson, function(data, rawData)
            -- No callback needed
        end)

        Wait(10000)
        deferrals.done("🔒 Server not launched. Join our Discord for updates.")
    end

    AddEventHandler("playerConnecting", OnPlayerConnecting)
end
