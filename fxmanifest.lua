fx_version 'cerulean'
games { 'gta5' }

author 'Code lab'
description 'cl-masterblocker'
version '1.0.0'
lua54 "yes"

shared_scripts {	
	"config.lua"
}

server_script 'server/*.lua'
client_script 'client/*.lua'