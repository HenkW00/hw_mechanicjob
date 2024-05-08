fx_version 'bodacious'
game  'gta5'
lua54 'yes'

author 'HenkW'
description 'Advanced mechanic job using OX'
version '1.0.1'

client_scripts{
	'client/client.lua', 
	'config.lua',
	'@es_extended/locale.lua' 
}

server_scripts{
	'server/server.lua',
	'server/version.lua',
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
    '@es_extended/locale.lua' 
 
}

shared_scripts {
	'@ox_lib/init.lua',
	'@es_extended/imports.lua'
}

dependencies {
	'oxmysql',
	'ox_lib',
	'hw_utils'
}

escrow_ignore {
    'config.lua',
    'fxmanifest.lua',
    'README.MD'
}server_scripts { '@mysql-async/lib/MySQL.lua' }