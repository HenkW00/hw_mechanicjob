ESX = exports["es_extended"]:getSharedObject()  

-- Function for sending discord logs
function sendLog(playerIdentifier, message)
    if Config.Logs and Config.DiscordWebhook ~= "" then
    
        local embeds = {
            {
                title = Config.DiscordLogTitle,
                description = message,
                type = Config.DiscordEmbedStyle,
                color = Config.DiscordLogColour,
                footer = {
                    text = Config.DiscordLogFooter,
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }

        PerformHttpRequest(Config.DiscordWebhook, function() end, 'POST', json.encode({username = Config.DiscordBotName or 'HW Development | Logs', embeds = embeds}), {['Content-Type'] = 'application/json'})
    end
end

-- Check/register number/society
TriggerEvent('esx_phone:registerNumber', 'mechanic', 'phone', true, true)
TriggerEvent('esx_society:registerSociety', 'mechanic', 'mechanic', 'society_mechanic', 'society_mechanic', 'society_mechanic', {type = 'private'})

-- Callback for removing repairkit
lib.callback.register('repairkit:remove', function(source, item, metadata, target)
    local Player = source
    exports.ox_inventory:RemoveItem(Player, 'repair_kit', 1)
    sendLog(source, string.format('Player **%s** used `1x` **repairkit**.', source))
    if Config.Debug then
        print('^0[^1DEBUG^0] ^5Player ^3' .. source .. '^5 used a ^3repairkit^0')
    end
end)

-- Callback for removing wash tool and sponge
lib.callback.register('washing:remove', function(source, item, metadata, target)
	local Player = source
    exports.ox_inventory:RemoveItem(Player, 'wash_tool', 1)
    exports.ox_inventory:RemoveItem(Player, 'sponge', 1) 
    sendLog(source, string.format('Player **%s** started with washing the vehicle.', source))
    if Config.Debug then
        print('^0[^1DEBUG^0] ^5Player ^3' .. source .. '^5 started washing a vehicle^0')
    end
end)

-- Callback for adding dirty sponge
lib.callback.register('washing:dirtysponge', function(source, item, metadata, target)
	local Player = source 
    local success = exports.ox_inventory:AddItem(Player, 'dirty_sponge', 1)
    sendLog(source, string.format('Player **%s** received `1x` **dirty sponge**.', source))
    if Config.Debug then
        print('^0[^1DEBUG^0] ^5Player ^3' .. source .. '^5 received a ^3dirty sponge^0')
    end
end)

-- Callback for adding clean sponge
lib.callback.register('washing:spongeadd', function(source, item, metadata, target)
	local Player = source 
    exports.ox_inventory:RemoveItem(Player, 'dirty_sponge', 1)
    local success = exports.ox_inventory:AddItem(Player, 'sponge', 1)
    sendLog(source, string.format('Player **%s** received `1x` **clean sponge**.', source))
    if Config.Debug then
        print('^0[^1DEBUG^0] ^5Player ^3' .. source .. '^5 reveived a ^3clean sponge^0')
    end
end)

-- Callback for removing welding torch
lib.callback.register('hackcar:remove', function(source, item, metadata, target)
	local Player = source 
    exports.ox_inventory:RemoveItem(Player, 'welding_torch', 1)  
    sendLog(source, string.format('Player **%s** used `1x` **welding torch**.', source))
    if Config.Debug then
        print('^0[^1DEBUG^0] ^5Player ^3' .. source .. '^5 user a ^3welding torch^0')
    end
end)