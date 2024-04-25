Config = {}

--------------------
------SETTINGS------
--------------------
Config.Debug = true -- For debugging stuff
Config.checkForUpdates = true -- Recommended to leave as 'true'
Config.Logs = true -- Do you want to enable discord logs?

------------------------
------LOG SETTINGS------
------------------------
Config.DiscordWebhook = 'https://discord.com/api/webhooks/1233098120922140723/1-K3krrJJrwmhtC99z-EcJ5WwuSOayv5AXsEwFp3NQ3sYIAvNt3h-gxGV9emlatES16l' -- Place here your webhook url
Config.DiscordBotName = 'HW Development' -- Name of the discord bot?
Config.DiscordLogTitle = '🧰 __Mechanic Interactions__ 🧰' -- What should the embed title be?
Config.DiscordEmbedStyle = 'rich' -- Default style, reccomand NOT to change this
Config.DiscordLogColour = 0xFfff33 -- The color for the discord log?
Config.DiscordLogFooter = 'HW Development | Logs' -- What would the footer be?


----------------------------
------UNIFORM SETTINGS------
----------------------------
Config.Uniforms = {
	work = {
		male = {
			tshirt_1 = 15,  tshirt_2 = 0,
			torso_1 = 20,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 11,
			pants_1 = 20,   pants_2 = 0,
			shoes_1 = 16,   shoes_2 = 3,
			helmet_1 = -1,  helmet_2 = -1,
			chain_1 = -1,    chain_2 = -1,
			ears_1 = -1,     ears_2 = -1
		},
		female = {
			tshirt_1 = 36,  tshirt_2 = 1,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = 45,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	}, 
}

----------------------------
------VEHICLE SETTINGS------
----------------------------
Config.SpawnVehicle ={  
    Spawn =
    {
        model = "flatbed",
        Plate = "mechanic",
        PlateColor = 1,
    },

        --[[
            PlateColor:
            Blue/White - 0
            Yellow/black - 1
            Yellow/Blue - 2
            Blue/White2 - 3
            Blue/White3 - 4
            Yankton - 5
      ]]
 
}   