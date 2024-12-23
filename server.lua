local ox_inventory = exports.ox_inventory

-- Server-side cooldown tracking
local playerCooldowns = {}

-- Function to check cooldown
local function checkCooldown(source)
    local currentTime = os.time()
    if playerCooldowns[source] and currentTime - playerCooldowns[source] < Config.SellCooldown then
        return false
    end
    playerCooldowns[source] = currentTime
    return true
end

-- Clean up cooldowns when player disconnects
AddEventHandler('playerDropped', function()
    playerCooldowns[source] = nil
end)

RegisterNetEvent('prjct-pawnshop:sellItem')
AddEventHandler('prjct-pawnshop:sellItem', function(data)
    local source = source
    
    if not checkCooldown(source) then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Pawnshop',
            description = 'You must wait before selling again',
            type = 'error'
        })
        return
    end

    local item = data.item
    local count = data.count
    
    if not Config.Items[item] then return end
    
    local itemConfig = Config.Items[item]
    local price = math.floor(itemConfig.price * count * (math.random(90, 110) / 100))
    
    if ox_inventory:GetItem(source, item, nil, true) >= count then
        if ox_inventory:RemoveItem(source, item, count) then
            ox_inventory:AddItem(source, 'money', price)
            
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Pawnshop',
                description = ('Sold %sx %s for $%s'):format(count, itemConfig.label, price),
                type = 'success'
            })
            
            -- Log the transaction if enabled
            if Config.EnableLogging then
                local message = ('Player %s sold %sx %s for $%s'):format(GetPlayerName(source), count, itemConfig.label, price)
                print(message) -- Replace with your logging system
            end
        end
    end
end)
