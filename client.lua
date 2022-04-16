ESX = nil 
Citizen.CreateThread(function() 
    while ESX == nil do 
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
        Citizen.Wait(0) 
    end 
end)

local mb_alertsystems_display = false

RegisterNetEvent("mb:policeEnvironment:show")
RegisterNetEvent("mb:policeEnvironment:hide")
RegisterNetEvent("mb:policeEnvironment:update")

AddEventHandler("mb:policeEnvironment:show", function(text)
    mb_alertsystems_display = true
    SendNUIMessage({
        type = "policeEnvironment:show"
    })
end)

AddEventHandler("mb:policeEnvironment:hide", function()
    mb_alertsystems_display = false
    SendNUIMessage({
        type = "policeEnvironment:hide"
    })
end)

AddEventHandler("mb:policeEnvironment:update", function(environment_index, environment_max, environment)
    SendNUIMessage({
        type = "policeEnvironment:update",
        index = environment_index,
        max = environment_max,
        counter = environment.police_counter,
        text = environment.text, 
        color = environment.color,
        selected = environment.selected,
        distance = environment.distance,
        job = environment.job
    })
end)

local craftMenu_display = false

function getCraftMenuState()
    return craftMenu_display
end

RegisterNetEvent("mb:craftMenu:show")
RegisterNetEvent("mb:craftMenu:hide")
RegisterNetEvent("mb:craftMenu:update")

AddEventHandler("mb:craftMenu:show", function(input_patterns)
    craftMenu_display = true
    SetNuiFocusKeepInput(false) 
    SetNuiFocus(true, true) 
    SetCursorLocation(0.5, 0.5) 
    SendNUIMessage({
        type = "craftMenu:show",
        patterns = input_patterns
    })
end)

AddEventHandler("mb:craftMenu:hide", function()
    ExecuteCommand("e c")
    craftMenu_display = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "craftMenu:hide"
    })
end)
AddEventHandler("mb:craftMenu:update", function(patterns)
    SendNUIMessage({
        type = "craftMenu:update",
        patterns = patterns
    })
end)

local inventory_display = false

function getInventoryState()
    return inventory_display
end

RegisterNetEvent("mb:inventory:show")
RegisterNetEvent("mb:inventory:hide")
RegisterNetEvent("mb:inventory:update")
RegisterNetEvent("mb:inventory:showGiveMenu")
RegisterNetEvent("mb:inventory:pressKey")

AddEventHandler("mb:inventory:show", function(input_items, input_current_weight, input_max_weight)
    inventory_display = true
    SendNUIMessage({
        type = "inventory:show",
        items = input_items,
        current_weight = input_current_weight,
        max_weight = input_max_weight
    })
end)

AddEventHandler("mb:inventory:hide", function()
    inventory_display = false
    SendNUIMessage({
        type = "inventory:hide"
    })
end)

AddEventHandler("mb:inventory:update", function(input_items, input_current_weight, input_max_weight)
    SendNUIMessage({
        type = "inventory:update",
        items = input_items,
        current_weight = input_current_weight,
        max_weight = input_max_weight
    })
end)

AddEventHandler("mb:inventory:showGiveMenu", function(input_users)
    SendNUIMessage({
        type = "inventory:showGiveMenu",
        users = input_users
    })
end)

AddEventHandler("mb:inventory:pressKey", function(input_key)
    SendNUIMessage({
        type = "inventory:pressKey",
        key = input_key
    })
end)

RegisterNUICallback("inventory:use", function(item, cb)
    TriggerEvent('mb_inventory:use', item)
    cb({})
end)

RegisterNUICallback("inventory:give", function(data, cb)
    TriggerEvent('mb_inventory:giveMenu')
    cb({})
end)

RegisterNUICallback("inventory:drop", function(data, cb)
    local item = json.decode(data.item)
    local quantity = data.quantity
    -- llamar a la funcion para tirar objetos
    print("Tiramos: " .. quantity .. " De: " .. item.name)
    -- TriggerEvent('mb:inventory:update', items)
    cb({})
end)

RegisterNUICallback("inventory:unequip", function(item, cb)
    TriggerEvent('mb_inventory:unequip', item)
    cb({})
end)

RegisterNUICallback("inventory:giveItemToUser", function(data, cb)
    SetNuiFocus(false, false) 
    local item = json.decode(data.item)
    local user = json.decode(data.user)
    local quantity = data.quantity
    TriggerEvent('mb_inventory:give', item, user, quantity)
    cb({})
end)

RegisterNUICallback("inventory:enableNuiFocus", function(data, cb)
    SetNuiFocusKeepInput(false) 
    SetNuiFocus(true, false) 
    cb({})
end)
RegisterNUICallback("inventory:disableNuiFocus", function(data, cb)
    SetNuiFocus(false, false) 
    cb({})
end)

RegisterNUICallback("inventory:close", function(data, cb)
    TriggerEvent("mb:inventory:hide")
    cb({})
end)

exports('getInventoryState', getInventoryState)

local notifications_display = true

ConvertStringToTypeNoOther = function(_text)
    _text = _text:gsub("~r~", "<span class='red'>") 
    _text = _text:gsub("~b~", "<span class='blue'>")
    _text = _text:gsub("~g~", "<span class='green'>")
    _text = _text:gsub("~y~", "<span class='yellow'>")
    _text = _text:gsub("~p~", "<span class='purple'>")
    _text = _text:gsub("~c~", "<span class='grey'>")
    _text = _text:gsub("~m~", "<span class='darkgrey'>")
    _text = _text:gsub("~u~", "<span class='black'>")
    _text = _text:gsub("~o~", "<span class='gold'>")
    _text = _text:gsub("~s~", "</span>")
    _text = _text:gsub("~w~", "</span>")
    _text = _text:gsub("~b~", "<b>")
    _text = _text:gsub("~n~", "<br>")
    -- _text = "<span>" .. _text .. "</span>"
    return _text
end

function getNotificationsState()
    return notifications_display
end

RegisterNetEvent("mb:notifications:show")
RegisterNetEvent("mb:notifications:hide")
RegisterNetEvent("mb:notifications:addNew")
RegisterNetEvent("mb:notifications:isMapRendering")

AddEventHandler("mb:notifications:show", function(patterns)
    notifications_display = true
    SendNUIMessage({
        type = "notifications:show"
    })
end)

AddEventHandler("mb:notifications:hide", function()
    notifications_display = false
    SendNUIMessage({
        type = "notifications:hide"
    })
end)

AddEventHandler("mb:notifications:addNew", function(text, type, duration)
    SendNUIMessage({
        type = "notifications:addNew",
        text = ConvertStringToTypeNoOther(text) or "",
        notification_type = type,
        notification_duration = duration,
    })
end)

AddEventHandler("mb:notifications:isMapRendering", function()
    local is_map_rendering = IsMinimapRendering()
    local map = false
    if is_map_rendering then
        map = exports.mbForas:GetMinimapAnchor()
    end
    SendNUIMessage({
        type = "notifications:isMapRendering",
        is_map_rendering = IsMinimapRendering(),
        map = map,
        is_big_map_active = IsBigmapActive()
    })
end)

RegisterNUICallback("notifications:craft", function(data, cb)
    TriggerEvent("notifications:craft", data)
    cb({})
end)

exports('getNotificationsState', getNotificationsState)

local custom_menu_display = false

function getCustomMenuState()
    return custom_menu_display
end

RegisterNetEvent("mb:custom_menu:show")
RegisterNetEvent("mb:custom_menu:hide")
RegisterNetEvent("mb:custom_menu:update")
RegisterNetEvent("mb:custom_menu:pressKey")

AddEventHandler("mb:custom_menu:show", function(data)
    custom_menu_display = true
    SendNUIMessage({
        type = "custom_menu:show",
        menu_data = data
    })
end)

AddEventHandler("mb:custom_menu:hide", function()
    custom_menu_display = false
    SendNUIMessage({
        type = "custom_menu:hide"
    })
end)

AddEventHandler("mb:custom_menu:update", function(data)
    SendNUIMessage({
        type = "custom_menu:update",
        menu_data = data
    })
end)

AddEventHandler("mb:custom_menu:pressKey", function(input_key)
    SendNUIMessage({
        type = "custom_menu:pressKey",
        key = input_key
    })
end)

RegisterNUICallback("custom_menu:close", function(data, cb)
    TriggerEvent("mb:custom_menu:hide")
    cb({})
end)

RegisterNUICallback("custom_menu:action", function(data, cb)
    TriggerEvent("mb_custom_menu:action", data.category, data.item)
    cb({})
end)

exports('getCustomMenuState', getCustomMenuState)









