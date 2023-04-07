RegisterNetEvent('Dimitri74:send:payment')
AddEventHandler('Dimitri74:send:payment', function(key, Basket)
    local _src = source
    if _src == -1 or _src == nil or _src == '-1' then return end
    print(assert(type(k)))
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
        return
    end

    print(json.encode(Basket))

    local xMoney = exports['av_inventory']:getMoney(_src)

    if xMoney >= GetTypeGroup.Price then
        exports['av_inventory']:delMoney(_src, GetTypeGroup.Price)
        exports['av_inventory']:addItem(_src, GetTypeGroup.ItemName, GetTypeGroup.Quantity)
        
        Dimitri74ServerUtils.Client('esx:showAdvancedNotification', _src, "Magasin", "~b~"..KeyGroup.Group.."", "~o~Achat effectué, merci pour votre achat", "CHAR_DOM", 7)
    else
        Dimitri74ServerUtils.Client('esx:showNotification', _src, "~r~Vous n'avez pas assez d'argent")
    end
end)