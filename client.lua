OpenMenu = false

RMenu.Add('Shop', 'main', RageUI.CreateMenu("Shop", "Faites votre choix", 10, 80))
RMenu:Get('Shop', 'main').Closed = function()
    OpenMenu = false
    if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] The menu is closed") end
end

local OpenShop = function(key)
    if OpenMenu then return end
    if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] The menu is opening") end
    if  key == nil or not assert(type(key)) == "number" then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3Key^7) does not return in number") Shop.StopPrint = false end OpenMenu = false return end
    local KeyTable = Shop.PosShop[tonumber(key)]
    if  KeyTable == nil or KeyTable == '{}' or not assert(type(KeyTable)) == "table" then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3KeyTable^7) does not return in table") Shop.StopPrint = false end OpenMenu = false return end
    local GetShopType = Shop[KeyTable.Group]
    if  GetShopType == nil or GetShopType == '{}' or not assert(type(GetShopType)) == "table" then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3GetShopType^7) does not return in table") Shop.StopPrint = false end OpenMenu = false return end
    if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] The menu is open") end
    RageUI.Visible(RMenu:Get('Shop', 'main'), true)
    if not RageUI.Visible(RMenu:Get('Shop', 'main')) or not assert(type(RageUI.Visible(RMenu:Get('Shop', 'main')))) == "boolean" then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3RageUI.Visible^7) RageUI.Visible request failed") Shop.StopPrint = false end OpenMenu = false return else print(""..Shop.Prefix.." [^2Info^7] RageUI.Visible request completed successfully") end

    
end

Citizen.CreateThread(function()
    while true do
        local interval = 750
        if OpenMenu then return end
        local Player = PlayerPedId()
        for k,v in pairs(Shop.PosShop) do
            local GetDist = #(GetEntityCoords(Player) - v.Pos)
            if GetDist < 5 then
                interval = 450
                DrawMarker(21, v.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 199, 40, 170, 0, 1, 2, 0, nil, nil, 0)
                if GetDist < 2 then
                    interval = 0
                    DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour accèder menu")
                    if IsControlJustReleased(0, 38) then
                        if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^2Info^7] To request the opening of the menu") end
                        OpenShop(k)
                        OpenMenu = true
                    end
                end
            end
        end
        Wait(interval)
    end
end)

function DisplayHelpText(str)
    if str == nil then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3DisplayHelpText^7) Not defined") Shop.StopPrint = false end OpenMenu = false return end
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end