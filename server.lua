RegisterNetEvent('Dimitri74:send:payment')
AddEventHandler('Dimitri74:send:payment', function(key, Basket)
    local _src = source
    local Price = 0
    if _src == -1 or _src == nil or _src == '-1' then return end
    if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] Request received") end
    if  key == nil or assert(type(key)) ~= "number" then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3Key^7) does not return in number") Shop.StopPrint = false end OpenMenu = false return end
    local KeyTable = Shop.PosShop[tonumber(key)]
    if  Basket == nil or assert(type(Basket)) ~= "table" then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3Basket^7) does not return in table") Shop.StopPrint = false end OpenMenu = false return end
    if  KeyTable == nil or KeyTable == '{}' or assert(type(KeyTable)) ~= "table" then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3KeyTable^7) does not return in table") Shop.StopPrint = false end OpenMenu = false return end
    local GetShopType = Shop[KeyTable.Group]
    if  GetShopType == nil or GetShopType == '{}' or assert(type(GetShopType)) ~= "table" then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3GetShopType^7) does not return in table") Shop.StopPrint = false end OpenMenu = false return end
    local GetShopPos = Shop.PosShop[tonumber(key)].Pos
    if GetShopPos == nil or GetShopPos == '{}' or assert(type(GetShopPos)) ~= "vector3" then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3GetShopPos^7) does not return in vector3") Shop.StopPrint = false end OpenMenu = false return end
    
    local PlayerPos = GetEntityCoords(GetPlayerPed(_src))
    if #(PlayerPos - GetShopPos) > 4 then
        DropPlayer(_src, "Tentative de Cheat")
        if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] Tried to cheat") end
        return
    end

    for key, value in pairs(Basket) do
        Price = Price + (GetShopType[key].Price*value)
    end

    local xMoney = exports['av_inventory']:getMoney(_src)
    if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] Check if he can pay") end
    if xMoney >= Price then
        exports['av_inventory']:delMoney(_src, tonumber(Price))
        if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] Payment made successfully [^1"..tonumber(Price).." $^7]") end
    for key, value in pairs(Basket) do
        exports['av_inventory']:addItem(_src, key, tonumber(value))
        if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] Give the items [^5"..key.."^7] x [^2"..tonumber(value).."^7]") end
    end   
        TriggerClientEvent('Dimitri74:ShowNotification', _src, "~g~Merci pour votre achat")
        if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] Send the payment confirmation message") end
    else
        TriggerClientEvent('Dimitri74:ShowNotification', _src, "~r~Vous n'avez pas assez d'argent")
        if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] sends the payment declined message") end
        if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] You do not have enough money") end
    end
end)