fx_version 'adamant'
game 'gta5'

description 'police job'
version '1.0.6 - latest update : fixed armory & f6 menu & livery options'
author 'Flap'

ui_page "html/ui.html"

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config/config.lua',
	'server/*.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config/config.lua',
	'client/*.lua'
}

files {
    "html/ui.html",
    "html/ui.css",
    "html/ui.js"
}

dependencies {
	'es_extended',
	'esx_billing'
}