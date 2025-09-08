fx_version 'cerulean'
game 'gta5'

author 'SelfishEagle & Gemini'
description 'Spawn selector for the SE Framework.'
version '1.0.0'

lua54 'yes'

-- The UI for the spawn selector
ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/script.js'
}

client_script 'client/cl_main.lua'
server_script 'server/sv_main.lua'

-- We need to use the config file from se-core to get the spawn locations
shared_script '@se-core/shared/cfg.lua'
