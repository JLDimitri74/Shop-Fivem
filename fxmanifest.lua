fx_version 'adamant'
game 'gta5'

description 'Shop Fivem Version 1.0'
author 'Dimitri74'
version '1.0'

shared_script {'config.lua'}

client_script {
    -- RageUI --
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
    -- Fin RageUI --
    'client.lua'
}

server_script {'server.lua'}

dependencies {'es_extended'}

