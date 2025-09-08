fx_version 'cerulean'
game 'gta5'

author 'SelfishEagle'
description 'The core for the SE Framework.'
version '1.0.6'

lua54 'yes'

loadscreen 'loading/web/index.html'
loadscreen_manual_shutdown 'yes'
loadscreen_cursor 'yes'

ui_page 'multi/web/index.html'

files {
    'multi/web/index.html',
    'multi/web/style.css',
    'multi/web/script.js',
    'loading/web/index.html',
    'loading/web/style.css',
    'loading/web/script.js',
    'loading/web/config.js',
    'loading/web/assets/*'
}

shared_scripts {
    'shared/sh_main.lua',
    'shared/cfg.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/sv_player.lua',
    'server/sv_status.lua',
    'server/sv_commands.lua',
    'multi/server/sv_main.lua',
    'spawn/server/sv_main.lua',
    'server/sv_main.lua'
}

client_scripts {
    'client/cl_transition.lua',
    'client/cl_main.lua',
    'client/cl_player.lua',
    'client/cl_commands.lua',
    'multi/client/cl_main.lua',
    'spawn/client/cl_main.lua'
}

exports {
    'GetCoreObject'
}

server_exports {
    'GetCoreObject',
    'LoadCharacter',
    'AddItem',
    'UpdateAndSavePlayer'
}

