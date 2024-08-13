fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Awleks'
description 'Cinematic Camera (FiveManage)'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua'
} 

server_scripts {
    'server/server.lua',
    'server/permissions.lua'
} 

dependencies {
    'screenshot-basic'
}