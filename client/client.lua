local LUXRCore = exports['luxr-core']:GetCoreObject()

---------------------------------
-- blips
---------------------------------
CreateThread(function()
    for _,v in pairs(Config.BlacksmithLocations) do
        if v.showblip == true then    
            local PlayerBlacksmithBlip = BlipAddForCoords(1664425300, v.coords)
            SetBlipSprite(PlayerBlacksmithBlip, joaat(v.blipsprite), true)
            SetBlipScale(PlayerBlacksmithBlip, v.blipscale)
            SetBlipName(PlayerBlacksmithBlip, v.blipname)
        end
    end
end)

---------------------------------------------
-- get correct menu
---------------------------------------------
RegisterNetEvent('luxr-blacksmith:client:openblacksmith', function(blacksmithid, jobaccess, name)
    LUXRCore.Functions.TriggerCallback('luxr-blacksmith:server:getblacksmithdata', function(result)
        local owner = result[1].owner
        local status = result[1].status
        if owner ~= 'vacant' then
            local PlayerData = LUXRCore.Functions.GetPlayerData()
            local playerjob = PlayerData.job.name
            if playerjob == jobaccess then
                TriggerEvent('luxr-blacksmith:client:openjobmenu', blacksmithid, status)
            else
                TriggerEvent('luxr-blacksmith:client:opencustomermenu', blacksmithid, status)
            end
        else
            TriggerEvent('luxr-blacksmith:client:rentblacksmith', blacksmithid, name)
        end
    end, blacksmithid)
end)

---------------------------------------------
-- blacksmith job menu
---------------------------------------------
RegisterNetEvent('luxr-blacksmith:client:openjobmenu', function(blacksmithid, status)
    if status == 'open' then
        lib.registerContext({
            id = 'blacksmith_job_menu',
            title = Lang:t('client.lang_1'),
            options = {
                {
                    title = Lang:t('client.lang_2'),
                    icon = 'fa-solid fa-store',
                    event = 'luxr-blacksmith:client:ownerviewitems',
                    args = { blacksmithid = blacksmithid },
                    arrow = true
                },
                {
                    title = Lang:t('client.lang_3'),
                    icon = 'fa-solid fa-circle-plus',
                    iconColor = 'green',
                    event = 'luxr-blacksmith:client:newstockitem',
                    args = { blacksmithid = blacksmithid },
                    arrow = true
                },
                {
                    title = Lang:t('client.lang_4'),
                    icon = 'fa-solid fa-circle-minus',
                    iconColor = 'red',
                    event = 'luxr-blacksmith:client:removestockitem',
                    args = { blacksmithid = blacksmithid },
                    arrow = true
                },
                {
                    title = Lang:t('client.lang_5'),
                    icon = 'fa-solid fa-sack-dollar',
                    event = 'luxr-blacksmith:client:withdrawmoney',
                    args = { blacksmithid = blacksmithid },
                    arrow = true
                },
                {
                    title = Lang:t('client.lang_6'),
                    icon = 'fa-solid fa-box',
                    event = 'luxr-blacksmith:client:ownerstoragemenu',
                    args = { blacksmithid = blacksmithid },
                    arrow = true
                },
                {
                    title = Lang:t('client.lang_7'),
                    icon = 'fa-solid fa-box',
                    event = 'luxr-blacksmith:client:craftingmenu',
                    args = { blacksmithid = blacksmithid },
                    arrow = true
                },
                {
                    title = Lang:t('client.lang_8'),
                    icon = 'fa-solid fa-box',
                    event = 'luxr-blacksmith:client:rentmenu',
                    args = { blacksmithid = blacksmithid },
                    arrow = true
                },
                {
                    title = Lang:t('client.lang_9'),
                    icon = 'fa-solid fa-user-tie',
                    event = 'luxr-bossmenu:client:mainmenu',
                    arrow = true
                },
            }
        })
        lib.showContext('blacksmith_job_menu')
    else
        lib.registerContext({
            id = 'blacksmith_job_menu',
            title = Lang:t('client.lang_1'),
            options = {
                {
                    title = Lang:t('client.lang_8'),
                    icon = 'fa-solid fa-box',
                    event = 'luxr-blacksmith:client:rentmenu',
                    args = { blacksmithid = blacksmithid },
                    arrow = true
                },
            }
        })
        lib.showContext('blacksmith_job_menu')
    end
end)

---------------------------------------------
-- blacksmith customer menu
---------------------------------------------
RegisterNetEvent('luxr-blacksmith:client:opencustomermenu', function(blacksmithid, status)
    if status == 'closed' then
        lib.notify({ title = Lang:t('client.lang_10'), type = 'error', duration = 7000 })
        return
    end
    lib.registerContext({
        id = 'blacksmith_customer_menu',
        title = Lang:t('client.lang_11'),
        options = {
            {
                title = Lang:t('client.lang_12'),
                icon = 'fa-solid fa-store',
                event = 'luxr-blacksmith:client:customerviewitems',
                args = { blacksmithid = blacksmithid },
                arrow = true
            },
            {
                title = Lang:t('client.lang_13'),
                icon = 'fa-solid fa-box',
                event = 'luxr-blacksmith:client:storageplayershare',
                args = { blacksmithid = blacksmithid },
                arrow = true
            },
        }
    })
    lib.showContext('blacksmith_customer_menu')
end)

---------------------------------------------
-- blacksmith rent money menu
---------------------------------------------
RegisterNetEvent('luxr-blacksmith:client:rentmenu', function(data)

    LUXRCore.Functions.TriggerCallback('luxr-blacksmith:server:getblacksmithdata', function(result)
    
        local rent = result[1].rent
        if rent > 50  then rentColorScheme = 'green' end
        if rent <= 50 and rent > 10 then rentColorScheme = 'yellow' end
        if rent <= 10 then rentColorScheme = 'red' end
        
        lib.registerContext({
            id = 'blacksmith_rent_menu',
            title = Lang:t('client.lang_14'),
            menu = 'blacksmith_job_menu',
            options = {
                {
                    title = Lang:t('client.lang_15')..rent,
                    progress = rent,
                    colorScheme = rentColorScheme,
                },
                {
                    title = Lang:t('client.lang_16'),
                    icon = 'fa-solid fa-dollar-sign',
                    event = 'luxr-blacksmith:client:payrent',
                    args = { blacksmithid = data.blacksmithid },
                    arrow = true
                },
            }
        })
        lib.showContext('blacksmith_rent_menu')

    end, data.blacksmithid)
    
end)

-------------------------------------------------------------------------------------------
-- job : view blacksmith items
-------------------------------------------------------------------------------------------
RegisterNetEvent('luxr-blacksmith:client:ownerviewitems', function(data)

    LUXRCore.Functions.TriggerCallback('luxr-blacksmith:server:checkstock', function(result)

        if result == nil then
            lib.registerContext({
                id = 'blacksmith_no_inventory',
                title = Lang:t('client.lang_17'),
                menu = 'blacksmith_job_menu',
                options = {
                    {
                        title = Lang:t('client.lang_18'),
                        icon = 'fa-solid fa-box',
                        disabled = true,
                        arrow = false
                    }
                }
            })
            lib.showContext('blacksmith_no_inventory')
        else
            local options = {}
            for k,v in ipairs(result) do
                options[#options + 1] = {
                    title = LUXRCore.Shared.Items[result[k].item].label..' ($'..result[k].price..')',
                    description = Lang:t('client.lang_19')..result[k].stock,
                    icon = 'fa-solid fa-box',
                    event = 'luxr-blacksmith:client:buyitem',
                    icon = "nui://" .. Config.Img .. LUXRCore.Shared.Items[tostring(result[k].item)].image,
                    image = "nui://" .. Config.Img .. LUXRCore.Shared.Items[tostring(result[k].item)].image,
                    args = {
                        item = result[k].item,
                        stock = result[k].stock,
                        price = result[k].price,
                        label = LUXRCore.Shared.Items[result[k].item].label,
                        blacksmithid = result[k].blacksmithid
                    },
                    arrow = true,
                }
            end
            lib.registerContext({
                id = 'blacksmith_inv_menu',
                title = Lang:t('client.lang_17'),
                menu = 'blacksmith_job_menu',
                position = 'top-right',
                options = options
            })
            lib.showContext('blacksmith_inv_menu')
        end
    end, data.blacksmithid)

end)

-------------------------------------------------------------------------------------------
-- customer : view blacksmith items
-------------------------------------------------------------------------------------------
RegisterNetEvent('luxr-blacksmith:client:customerviewitems', function(data)
    LUXRCore.Functions.TriggerCallback('luxr-blacksmith:server:checkstock', function(result)
        if result == nil then
            lib.registerContext({
                id = 'blacksmith_no_inventory',
                title = Lang:t('client.lang_17'),
                menu = 'blacksmith_customer_menu',
                options = {
                    {
                        title = Lang:t('client.lang_18'),
                        icon = 'fa-solid fa-box',
                        disabled = true,
                        arrow = false
                    }
                }
            })
            lib.showContext('blacksmith_no_inventory')
        else
            local options = {}
            for k,v in ipairs(result) do
                options[#options + 1] = {
                    title = LUXRCore.Shared.Items[result[k].item].label..' ($'..result[k].price..')',
                    description = Lang:t('client.lang_19')..result[k].stock,
                    icon = 'fa-solid fa-box',
                    event = 'luxr-blacksmith:client:buyitem',
                    icon = "nui://" .. Config.Img .. LUXRCore.Shared.Items[tostring(result[k].item)].image,
                    image = "nui://" .. Config.Img .. LUXRCore.Shared.Items[tostring(result[k].item)].image,
                    args = {
                        item = result[k].item,
                        stock = result[k].stock,
                        price = result[k].price,
                        label = LUXRCore.Shared.Items[result[k].item].label,
                        blacksmithid = result[k].blacksmithid
                    },
                    arrow = true,
                }
            end
            lib.registerContext({
                id = 'blacksmith_inv_menu',
                title = Lang:t('client.lang_17'),
                menu = 'blacksmith_customer_menu',
                position = 'top-right',
                options = options
            })
            lib.showContext('blacksmith_inv_menu')
        end
    end, data.blacksmithid)

end)

-------------------------------------------------------------------
-- sort table function
-------------------------------------------------------------------
local function compareNames(a, b)
    return a.value < b.value
end

-------------------------------------------------------------------
-- add / update stock item
-------------------------------------------------------------------
RegisterNetEvent('luxr-blacksmith:client:newstockitem', function(data)

    local items = {}

    for k,v in pairs(LUXRCore.Functions.GetPlayerData().items) do
        local content = { value = v.name, label = v.label..' ('..v.amount..')' }
        items[#items + 1] = content
    end

    table.sort(items, compareNames)

    local item = lib.inputDialog(Lang:t('client.lang_20'), {
        { 
            type = 'select',
            options = items,
            label = Lang:t('client.lang_21'),
            required = true
        },
        { 
            type = 'input',
            label = Lang:t('client.lang_22'),
            placeholder = '0',
            icon = 'fa-solid fa-hashtag',
            required = true
        },
        { 
            type = 'input',
            label = Lang:t('client.lang_23'),
            placeholder = '0.00',
            icon = 'fa-solid fa-dollar-sign',
            required = true
        },
    })
    
    if not item then 
        return 
    end
    
    local hasItem = LUXRCore.Functions.HasItem(item[1], item[2])
    
    if hasItem then
        TriggerServerEvent('luxr-blacksmith:server:newstockitem', data.blacksmithid, item[1], tonumber(item[2]), tonumber(item[3]))
    else
        lib.notify({ title = Lang:t('client.lang_24'), type = 'error', duration = 7000 })
    end

end)

-------------------------------------------------------------------------------------------
-- remove stock item
-------------------------------------------------------------------------------------------
RegisterNetEvent('luxr-blacksmith:client:removestockitem', function(data)
    LUXRCore.Functions.TriggerCallback('luxr-blacksmith:server:checkstock', function(result)
        if result == nil then
            lib.registerContext({
                id = 'blacksmith_no_stock',
                title = Lang:t('client.lang_25'),
                menu = 'blacksmith_owner_menu',
                options = {
                    {
                        title = Lang:t('client.lang_26'),
                        icon = 'fa-solid fa-box',
                        disabled = true,
                        arrow = false
                    }
                }
            })
            lib.showContext('blacksmith_no_stock')
        else
            local options = {}
            for k,v in ipairs(result) do
                options[#options + 1] = {
                    title = LUXRCore.Shared.Items[result[k].item].label,
                    description = Lang:t('client.lang_19')..result[k].stock,
                    icon = 'fa-solid fa-box',
                    serverEvent = 'luxr-blacksmith:server:removestockitem',
                    icon = "nui://" .. Config.Img .. LUXRCore.Shared.Items[tostring(result[k].item)].image,
                    image = "nui://" .. Config.Img .. LUXRCore.Shared.Items[tostring(result[k].item)].image,
                    args = {
                        item = result[k].item,
                        blacksmithid = result[k].blacksmithid
                    },
                    arrow = true,
                }
            end
            lib.registerContext({
                id = 'blacksmith_stock_menu',
                title = Lang:t('client.lang_25'),
                menu = 'blacksmith_job_menu',
                position = 'top-right',
                options = options
            })
            lib.showContext('blacksmith_stock_menu')
        end
    end, data.blacksmithid)
end)

-------------------------------------------------------------------------------------------
-- withdraw money 
-------------------------------------------------------------------------------------------
RegisterNetEvent('luxr-blacksmith:client:withdrawmoney', function(data)
    LUXRCore.Functions.TriggerCallback('luxr-blacksmith:server:getmoney', function(result)
        local input = lib.inputDialog(Lang:t('client.lang_27'), {
            { 
                type = 'input',
                label = Lang:t('client.lang_28')..result.money,
                icon = 'fa-solid fa-dollar-sign',
                required = true
            },
        })
        if not input then
            return 
        end
        local withdraw = tonumber(input[1])
        if withdraw <= result.money then
            TriggerServerEvent('luxr-blacksmith:server:withdrawfunds', withdraw, data.blacksmithid)
        else
            lib.notify({ title = Lang:t('client.lang_29'), type = 'error', duration = 7000 })
        end
    end, data.blacksmithid)
end)

---------------------------------------------
-- buy item amount
---------------------------------------------
RegisterNetEvent('luxr-blacksmith:client:buyitem', function(data)
    local input = lib.inputDialog(Lang:t('client.lang_30')..data.label, {
        { 
            label = Lang:t('client.lang_31'),
            type = 'input',
            required = true,
            icon = 'fa-solid fa-hashtag'
        },
    })
    if not input then
        return
    end
    
    local amount = tonumber(input[1])
    
    if data.stock >= amount then
        local newstock = (data.stock - amount)
        TriggerServerEvent('luxr-blacksmith:server:buyitem', amount, data.item, newstock, data.price, data.label, data.blacksmithid)
    else
        lib.notify({ title = Lang:t('client.lang_32'), type = 'error', duration = 7000 })
    end
end)

---------------------------------------------
-- rent blacksmith
---------------------------------------------
RegisterNetEvent('luxr-blacksmith:client:rentblacksmith', function(blacksmithid, name)
    
    local input = lib.inputDialog(Lang:t('client.lang_33')..name, {
        {
            label = Lang:t('client.lang_34')..Config.RentStartup,
            type = 'select',
            options = {
                { value = 'yes', label = Lang:t('client.lang_35') },
                { value = 'no',  label = Lang:t('client.lang_36') }
            },
            required = true
        },
    })

    -- check there is an input
    if not input then
        return 
    end

    -- if no then return
    if input[1] == 'no' then
        return
    end

    LUXRCore.Functions.TriggerCallback('luxr-multijob:server:checkjobs', function(canbuy)
        if not canbuy then
            lib.notify({ title = Lang:t('client.lang_50'), type = 'error', duration = 7000 })
            return
        else
            LUXRCore.Functions.TriggerCallback('luxr-blacksmith:server:countowned', function(result)

                if result >= Config.MaxBalacksmiths then
                    lib.notify({ title = Lang:t('client.lang_48'), description = Lang:t('client.lang_49'), type = 'error', duration = 7000 })
                    return
                end
        
                -- check player has a licence
                if Config.LicenseRequired then
                    local hasItem = LUXRCore.Functions.HasItem('blacksmithlicence', 1)
        
                    if hasItem then
                        TriggerServerEvent('luxr-blacksmith:server:rentblacksmith', blacksmithid)
                    else
                        lib.notify({ title = Lang:t('client.lang_37'), type = 'error', duration = 7000 })
                    end
                else
                    TriggerServerEvent('luxr-blacksmith:server:rentblacksmith', blacksmithid)
                end
            
            end)
        end
    end)
end)

-------------------------------------------------------------------------------------------
-- pay rent
-------------------------------------------------------------------------------------------
RegisterNetEvent('luxr-blacksmith:client:payrent', function(data)

        local input = lib.inputDialog(Lang:t('client.lang_38'), {
            { 
                label = Lang:t('client.lang_39'),
                type = 'input',
                icon = 'fa-solid fa-dollar-sign',
                required = true
            },
        })
        if not input then
            return 
        end
        
        TriggerServerEvent('luxr-blacksmith:server:addrentmoney', input[1], data.blacksmithid)

end)

---------------------------------------------
-- owner blacksmith storage menu
---------------------------------------------
RegisterNetEvent('luxr-blacksmith:client:ownerstoragemenu', function(data)
    lib.registerContext({
        id = 'owner_storage_menu',
        title = Lang:t('client.lang_43'),
        menu = 'blacksmith_job_menu',
        options = {
            {
                title = Lang:t('client.lang_40'),
                icon = 'fa-solid fa-box',
                event = 'luxr-blacksmith:client:storageplayershare',
                args = { blacksmithid = data.blacksmithid },
                arrow = true
            },
            {
                title = Lang:t('client.lang_41'),
                icon = 'fa-solid fa-box',
                event = 'luxr-blacksmith:client:storagecrafting',
                args = { blacksmithid = data.blacksmithid },
                arrow = true
            },
            {
                title = Lang:t('client.lang_42'),
                icon = 'fa-solid fa-box',
                event = 'luxr-blacksmith:client:storagestock',
                args = { blacksmithid = data.blacksmithid },
                arrow = true
            },
        }
    })
    lib.showContext('owner_storage_menu')
end)

---------------------------------------------
-- player share storage
---------------------------------------------
RegisterNetEvent('luxr-blacksmith:client:storageplayershare', function(data)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", 'share_'..data.blacksmithid, {
        maxweight = Config.BarTrayMaxWeight,
        slots = Config.BarTrayMaxSlots,
    })
    TriggerEvent("inventory:client:SetCurrentStash", 'share_'..data.blacksmithid)
end)

---------------------------------------------
-- crafting storage
---------------------------------------------
RegisterNetEvent('luxr-blacksmith:client:storagecrafting', function(data)
    local PlayerData = LUXRCore.Functions.GetPlayerData()
    local playerjob = PlayerData.job.name
    if playerjob == data.blacksmithid then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", 'crafting_'..data.blacksmithid, {
            maxweight = Config.CraftingMaxWeight,
            slots = Config.CraftingMaxSlots,
        })
        TriggerEvent("inventory:client:SetCurrentStash", 'crafting_'..data.blacksmithid)
    end
end)

---------------------------------------------
-- stock storage
---------------------------------------------
RegisterNetEvent('luxr-blacksmith:client:storagestock', function(data)
    local PlayerData = LUXRCore.Functions.GetPlayerData()
    local playerjob = PlayerData.job.name
    if playerjob == data.blacksmithid then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", 'stock_'..data.blacksmithid, {
            maxweight = Config.StockMaxWeight,
            slots = Config.StockMaxSlots,
        })
        TriggerEvent("inventory:client:SetCurrentStash", 'stock_'..data.blacksmithid)
    end
end)
