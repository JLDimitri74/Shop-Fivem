OpenMenu = false

RMenu.Add('Shop', 'main', RageUI.CreateMenu("Shop", "Faites votre choix", 10, 80))
RMenu:Get('Shop', 'main').Closed = function()
    OpenMenu = false
end

local OpenShop = function(key)

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
                        if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1Info^7] Open the menu") Shop.StopPrint = false end
                        OpenShop(k)
                    end
                end
            end
        end
        Wait(interval)
    end
end)

function DisplayHelpText(str)
    if str == nil then if not Shop.Production and Shop.StopPrint then print(""..Shop.Prefix.." [^1ERROR^7] (^3DisplayHelpText^7) Non Défini") Shop.StopPrint = false end return end
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end