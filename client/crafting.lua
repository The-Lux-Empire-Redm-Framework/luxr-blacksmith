local LUXRCore = exports['luxr-core']:GetCoreObject()

---------------------------------------------
-- crafting menu
---------------------------------------------
local CategoryMenus = {}

CreateThread(function()
    for _, v in ipairs(Config.BlacksmithCrafting) do
        local IngredientsMetadata = {}
        local setheader = LUXRCore.Shared.Items[tostring(v.receive)].label
        local itemimg = "nui://"..Config.Img..LUXRCore.Shared.Items[tostring(v.receive)].image

        for i, ingredient in ipairs(v.ingredients) do
            table.insert(IngredientsMetadata, { label = LUXRCore.Shared.Items[ingredient.item].label, value = ingredient.amount })
        end

        local option = {
            title = setheader,
            icon = itemimg,
            event = 'luxr-blacksmith:client:checkingredients',
            metadata = IngredientsMetadata,
            args = {
                title = setheader,
                category = v.category,
                ingredients = v.ingredients,
                crafttime = v.crafttime,
                receive = v.receive,
                giveamount = v.giveamount
            }
        }

        if not CategoryMenus[v.category] then
            CategoryMenus[v.category] = {
                id = 'crafting_menu_' .. v.category,
                title = v.category,
                menu = 'crafting_menu',
                onBack = function() end,
                options = { option }
            }
        else
            table.insert(CategoryMenus[v.category].options, option)
        end
    end
end)

CreateThread(function()
    for category, MenuData in pairs(CategoryMenus) do
        RegisterNetEvent('luxr-blacksmith:client:' .. category)
        AddEventHandler('luxr-blacksmith:client:' .. category, function()
            lib.registerContext(MenuData)
            lib.showContext(MenuData.id)
        end)
    end
end)

RegisterNetEvent('luxr-blacksmith:client:craftingmenu', function()
    local Menu = {
        id = 'crafting_menu',
        title = Lang:t('client.lang_44'),
        menu = 'blacksmith_job_menu',
        onBack = function() end,
        options = {}
    }

    for category, MenuData in pairs(CategoryMenus) do
        table.insert(Menu.options, {
            title = category,
            description = Lang:t('client.lang_45') .. category,
            event = 'luxr-blacksmith:client:' .. category,
            arrow = true
        })
    end

    lib.registerContext(Menu)
    lib.showContext(Menu.id)
end)

---------------------------------------------
-- craft item
---------------------------------------------
RegisterNetEvent('luxr-blacksmith:client:checkingredients', function(data)
    LUXRCore.Functions.TriggerCallback('luxr-blacksmith:server:checkingredients', function(hasRequired)

        if not hasRequired then 
            return 
        end

        LocalPlayer.state:set("inv_busy", true, true) -- lock inventory
        if lib.progressBar({
            duration = tonumber(data.crafttime),
            position = 'bottom',
            useWhileDead = false,
            canCancel = false,
            disableControl = true,
            disable = {
                move = true,
                mouse = true,
            },
            label = Lang:t('client.lang_46').. LUXRCore.Shared.Items[data.receive].label,
        }) then
            TriggerServerEvent('luxr-blacksmith:server:finishcrafting', data)
        end
        LocalPlayer.state:set("inv_busy", false, true) -- unlock inventory

    end, data.ingredients)
end)
