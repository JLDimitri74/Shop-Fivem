local OpenMenu = false


local OpenShop = function(key)
    if OpenMenu then return end
    OpenMenu = true
    if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] The menu is opening") end
    if  key == nil or assert(type(key)) ~= "number" then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3Key^7) does not return in number") Shop.StopPrint = false end OpenMenu = false return end
    local KeyTable = Shop.PosShop[tonumber(key)]
    if  KeyTable == nil or KeyTable == '{}' or assert(type(KeyTable)) ~= "table" then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3KeyTable^7) does not return in table") Shop.StopPrint = false end OpenMenu = false return end
    local GetShopType = Shop[KeyTable.Group]
    if  GetShopType == nil or GetShopType == '{}' or assert(type(GetShopType)) ~= "table" then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3GetShopType^7) does not return in table") Shop.StopPrint = false end OpenMenu = false return end
    local GetShopPos = Shop.PosShop[tonumber(key)].Pos
    if GetShopPos == nil or GetShopPos == '{}' or assert(type(GetShopPos)) ~= "vector3" then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3GetShopPos^7) does not return in vector3") Shop.StopPrint = false end OpenMenu = false return end
    if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] The menu is open") end
    local basket = {}
    
    RMenu.Add('Shop', 'main', RageUI.CreateMenu("Shop", "Faites votre choix", 10, 80))
    RMenu:Get('Shop', 'main').Closed = function()
        OpenMenu = false
        if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] The menu is closed") end
    end

    RageUI.Visible(RMenu:Get('Shop', 'main'), true)
    if not RageUI.Visible(RMenu:Get('Shop', 'main')) or assert(type(RageUI.Visible(RMenu:Get('Shop', 'main')))) ~= "boolean" then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3RageUI.Visible^7) RageUI.Visible request failed") Shop.StopPrint = false end OpenMenu = false return else print(""..Shop.Prefix.." [^2Info^7] RageUI.Visible request completed successfully") end
    Citizen.CreateThread(function()
        while OpenMenu do
            local Player = PlayerPedId()
            if #(GetEntityCoords(Player) - GetShopPos) > 2 then
                SetEntityCoords(Player, GetShopPos)
                DisplayHelpText("~r~Veuillez ne pas vous éloigner.")
                if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] The DisplayHelpText has been sent successfully") end
            end 
            RageUI.IsVisible(RMenu:Get('Shop', 'main'), true, true, true, function()
                local PriceBasket = function()
                    local result = 0
                    for Id, Count in pairs(basket) do
                        result = result + (GetShopType[Id].Price*Count)
                    end
                    return result
                end
                RageUI.Separator(("Prix du panier: ~g~%s$"):format(tonumber(PriceBasket())))
                
                for k,v in pairs(GetShopType) do
                    if v.category ~= nil then 
                        RageUI.Separator(v.category)
                    else 
                    RageUI.ButtonWithStyle(v.Name, nil, {RightLabel = ("~g~Ajouter ~s~(~g~%s$~s~) ~s~→→"):format(tonumber(v.Price))}, true, function(h, a, s)
                        if s then
                            if not basket[k] then
                                basket[k] = 1
                                if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] Basket initialization for the item [^5"..k.."^7]") end
                            else
                                basket[k] = basket[k] + 1
                                if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] Add item [^5"..k.."^7] x [^2"..basket[k].."^7] to cart") end
                            end
                        end
                    end)
                end
            end

            if tonumber(PriceBasket()) > 1 then 
                RageUI.Separator("↓ ~y~Mon panier ~s~↓")
                RageUI.ButtonWithStyle("~r~Vider tout mon panier", nil, {RightLabel = "→→"}, true, function(_,_,s)
                    if s then
                        basket = {}
                        if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] Cart remove") end
                    end
                end)
                RageUI.ButtonWithStyle("Procéder au ~g~paiement", nil, { RightLabel = "→→" }, true, function(_, _, s)
                    if s then
                        -- Todo --> pay in cash by bank
                        if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] Preparing to send",json.encode(basket)) end
                        TriggerServerEvent("Dimitri74:send:payment",tonumber(key), basket)
                        if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] Payment trigger send") end
                    end
                end)
            end

            end, function()
            end)
        Wait(0)
    end
    RMenu:Delete('Shop', "main")
end)
    
end

Citizen.CreateThread(function()
    while true do
        local interval = 750
        local Player = PlayerPedId()
        for k,v in pairs(Shop.PosShop) do
            local GetDist = #(GetEntityCoords(Player) - v.Pos)
            if not OpenMenu and GetDist < 5 then
                interval = 450
                DrawMarker(21, v.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 199, 40, 170, 0, 1, 2, 0, nil, nil, 0)
                if GetDist < 2 then
                    interval = 0
                    DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour accèder menu")
                    if IsControlJustReleased(0, 38) then
                        if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] To request the opening of the menu") end
                        OpenShop(k)
                    end
                end
            end
        end
        Wait(interval)
    end
end)

DisplayHelpText = function(str)
    if str == nil then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3DisplayHelpText^7) Not defined") Shop.StopPrint = false OpenMenu = false end return end
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

ShowNotification = function(msg)
    if msg == nil then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3ShowNotification^7) Not defined") Shop.StopPrint = false OpenMenu = false end return end
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(msg)
	DrawNotification(false, true)
end

RegisterNetEvent("Dimitri74:ShowNotification")
AddEventHandler("Dimitri74:ShowNotification", function(msg)
    if msg == nil then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3Dimitri74:ShowNotification^7) Not defined") Shop.StopPrint = false OpenMenu = false end return end
    ShowNotification(msg)
end)