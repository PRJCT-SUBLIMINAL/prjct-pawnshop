local function getPriceWithVariation(basePrice)
    local variation = math.random(90, 110) / 100
    return math.floor(basePrice * variation)
end

local function createPawnshopPed(coords, heading)
    local model = Config.PedModel
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(50)
    end
    
    local ped = CreatePed(4, model, coords.x, coords.y, coords.z - 1.0, heading, false, false)
    SetEntityHeading(ped, heading)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    
    return ped
end

local function openPawnMenu()
    local options = {}
    
    for item, data in pairs(Config.Items) do
        local count = exports.ox_inventory:GetItemCount(item)
        if count > 0 then
            local estimatedPrice = getPriceWithVariation(data.price)
            table.insert(options, {
                title = data.label,
                description = ('Sell for $%s-%s each'):format(
                    math.floor(data.price * 0.9),
                    math.floor(data.price * 1.1)
                ),
                metadata = {
                    ['Current Stock'] = count,
                    ['Estimated Value'] = ('$%s each'):format(estimatedPrice)
                },
                onSelect = function()
                    local input = lib.inputDialog('Pawnshop', {
                        {
                            type = 'number',
                            label = 'Amount to sell',
                            description = ('Max: %s'):format(count),
                            default = 1,
                            min = 1,
                            max = count
                        }
                    })
                    
                    if input and input[1] > 0 then
                        TriggerServerEvent('prjct-pawnshop:sellItem', {
                            item = item,
                            count = input[1]
                        })
                    end
                end
            })
        end
    end
    
    if #options == 0 then
        lib.notify({
            title = 'Pawnshop',
            description = 'You have nothing I want to buy',
            type = 'error'
        })
        return
    end
    
    lib.registerContext({
        id = 'pawnshop_menu',
        title = 'Pawnshop',
        options = options
    })

    lib.showContext('pawnshop_menu')
end

CreateThread(function()
    for _, shop in pairs(Config.Locations) do
        -- Create ped for location
        local ped = createPawnshopPed(shop.coords, shop.heading)
        
        -- Add target to ped
        exports.ox_target:addLocalEntity(ped, {
            {
                name = 'pawnshop',
                icon = 'fas fa-dollar-sign',
                label = 'Sell Items',
                distance = 2.0,
                onSelect = openPawnMenu
            }
        })
        
        -- Create blip
        if Config.ShowBlips then
            local blip = AddBlipForCoord(shop.coords.x, shop.coords.y, shop.coords.z)
            SetBlipSprite(blip, Config.BlipData.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, Config.BlipData.scale)
            SetBlipColour(blip, Config.BlipData.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(Config.BlipData.label)
            EndTextCommandSetBlipName(blip)
        end
    end
end)
