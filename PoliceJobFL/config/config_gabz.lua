-- udělat zbrojnici

Config                            = {}

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = false -- enable if you're using esx_license

Config.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.EnableJobBlip              = true -- enable blips for colleagues, requires esx_society

Config.MaxInService               = -1
Config.Locale                     = 'en'

Config.oldESX                    = false
Config.washMoney                 = true
Config.manageSalary              = true
Config.MaxSalary                 = 3500
Config.ESXtrigger                = "esx:getSharedObject"
Config.showFloatingHelpText      = 2
Config.showFloatingHelpTextCloakRoom      = 1
Config.OutfitFromDatastore       = "society_police_outfits"

Config.PoliceStations = {

	LSPD = {

		Blip = {
			Pos     = { x = 425.130, y = -979.558, z = 30.711 },
			Sprite  = 60,
			Display = 4,
			Scale   = 1.2,
			Colour  = 29,
			Name    = "Police department"
		},

		Cloakrooms = {
			{ x = 461.11, y = -1000.10, z = 30.2, cloakroom = "#1" },
			{ x = 462.21, y = -1000.10, z = 30.2, cloakroom = "#2" },
			{ x = 463.29, y = -1000.10, z = 30.2, cloakroom = "#3" },
			{ x = 463.91, y = -995.44, z = 30.2, cloakroom = "#4" },
			{ x = 462.88, y = -995.44, z = 30.2, cloakroom = "#5" },
			{ x = 461.72, y = -995.44, z = 30.2, cloakroom = "#6" },
			{ x = 460.6, y = -995.44, z = 30.2, cloakroom = "#7" },

			key = {
				location = { x = 457.98, y = -988.22, z = 29.69 },
				heading = 89.1,
				model = "s_m_m_armoured_01",
				scenario = 0,
				animDict = "amb@lo_res_idles@",
				animName = "world_human_lean_male_legs_crossed_lo_res_base",
			},

			access = {
				["recruit"] = true,
				["officer"] = true,
				["sergeant"] = true,
				["lieutenant"] = true,
				["boss"] = true
			}
		},

		Armories = {
			{
				ped = {
					location = { x = 482.72, y = -995.7, z = 29.69 },
					text = "press ~g~E~w~ to access the armory",
					heading = 173.25,
					model = "s_m_m_armoured_01",
					scenario = 0,
					animDict = "amb@world_human_stand_guard@male@idle_a",
					animName = "idle_c",
				},
				access = {
					["recruit"] = true,
					["officer"] = true,
					["sergeant"] = true,
					["lieutenant"] = true,
					["boss"] = true
				}
		    }
		},

		Vehicles = {
			{
				ped = {
					location = { x = 460.96, y = -975.9, z = 24.7 },
					text = "press ~g~E~w~ to take out a vehicle",
					heading = 123.92,
					model = "s_m_m_autoshop_02",
					scenario = 0,
					animDict = "amb@world_human_aa_smoke@male@idle_a",
					animName = "idle_c",
				},
				SpawnPoints = {
					{ x = 446.22, y = -986.03, z = 24.7, heading = 89.2, radius = 2.0 },
					{ x = 446.22, y = -988.73, z = 24.7, heading = 89.2, radius = 2.0 },
					{ x = 446.22, y = -991.33, z = 24.7, heading = 89.2, radius = 2.0 },
					{ x = 446.22, y = -994.21, z = 24.7, heading = 89.2, radius = 2.0 },
					{ x = 446.22, y = -996.78, z = 24.7, heading = 89.2, radius = 2.0 },
					{ x = 436.32, y = -986.15, z = 24.7, heading = 267.74, radius = 2.0 },
					{ x = 436.32, y = -988.96, z = 24.7, heading = 267.74, radius = 2.0 },
					{ x = 436.32, y = -991.69, z = 24.7, heading = 267.74, radius = 2.0 },
					{ x = 436.32, y = -994.31, z = 24.7, heading = 267.74, radius = 2.0 },
					{ x = 436.32, y = -997.02, z = 24.7, heading = 267.74, radius = 2.0 },
					{ x = 426.6, y = -976.08, z = 24.7, heading = 89.2, radius = 2.0 },
					{ x = 426.6, y = -978.77, z = 24.7, heading = 89.2, radius = 2.0 },
					{ x = 426.6, y = -981.32, z = 24.7, heading = 89.2, radius = 2.0 },
					{ x = 426.6, y = -984.01, z = 24.7, heading = 89.2, radius = 2.0 },
					{ x = 426.6, y = -988.82, z = 24.7, heading = 89.2, radius = 2.0 },
					{ x = 426.6, y = -991.42, z = 24.7, heading = 89.2, radius = 2.0 },
					{ x = 426.6, y = -994.05, z = 24.7, heading = 89.2, radius = 2.0 },
					{ x = 426.6, y = -996.8, z = 24.7, heading = 89.2, radius = 2.0 },

				},

				access = {
					["recruit"] = true,
					["officer"] = true,
					["sergeant"] = true,
					["lieutenant"] = true,
					["boss"] = true
				}
			},
		},

		Helicopters = {
			{
				SpawnPoint  = { x = 450.04, y = -981.14, z = 42.691, h = 80.0 },
				DeletePoints = {
					{ x = 449.32, y = -981.12, z = 42.69 },
				},

				ped = {
					location = { x = 461.81, y = -986.23, z = 42.69 },
					text = "press ~g~E~w~ to take out a helicopter",
					heading = 89.79,
					model = "s_m_m_armoured_01",
					scenario = 0,
					animDict = "amb@world_human_aa_smoke@male@idle_a",
					animName = "idle_c",
				},

				access = {
					["recruit"] = true,
					["officer"] = true,
					["sergeant"] = true,
					["lieutenant"] = true,
					["boss"] = true
				}
			},
		},

		VehicleDeleters = {
			{ x = 446.22, y = -986.03, z = 24.7, place = "#1" },
			{ x = 446.22, y = -988.73, z = 24.7, place = "#2" },
			{ x = 446.22, y = -991.33, z = 24.7, place = "#3" },
			{ x = 446.22, y = -994.21, z = 24.7, place = "#4" },
			{ x = 446.22, y = -996.78, z = 24.7, place = "#5" },
			{ x = 436.32, y = -986.15, z = 24.7, place = "#6" },
			{ x = 436.32, y = -988.96, z = 24.7, place = "#7" },
			{ x = 436.32, y = -991.69, z = 24.7, place = "#8" },
			{ x = 436.32, y = -994.31, z = 24.7, place = "#9" },
			{ x = 436.32, y = -997.02, z = 24.7, place = "#10" },
			{ x = 426.6, y = -976.08, z = 24.7, place = "#11" },
			{ x = 426.6, y = -978.77, z = 24.7, place = "#12" },
			{ x = 426.6, y = -981.32, z = 24.7, place = "#13" },
			{ x = 426.6, y = -984.01, z = 24.7, place = "#14" },
			{ x = 426.6, y = -988.82, z = 24.7, place = "#15" },
			{ x = 426.6, y = -991.42, z = 24.7, place = "#16" },
			{ x = 426.6, y = -994.05, z = 24.7, place = "#17" },
			{ x = 426.6, y = -996.8, z = 24.7, place = "#18" },



			access = {
				["recruit"] = true,
				["officer"] = true,
				["sergeant"] = true,
				["lieutenant"] = true,
				["boss"] = true
			}
		},

		BossActions = {
			{ x = 461.39, y = -986.16, z = 29.66, text = "press ~g~E~w~ to computer access" },

			access = {
				["recruit"] = false,
				["officer"] = false,
				["sergeant"] = false,
				["lieutenant"] = false,
				["boss"] = true
			}
		},

	},

}

Config.ArmorySystem = {
	-- Allow only 1 thing
	yrpNUI           = true,  -- yrp nui by Flap
	esx_inventoryhud = false, -- esx_inventoryhud by trsak
	customInventory  = false  -- your custom trigger in flap_police_job/client/inventory.lua
}

Config.PoliceShop = {
	items = {
		{name = "bread", label = "Bread", price = 20},
		{name = "water", label = "Water", price = 10}
	},
	weapons = {
		{name = "WEAPON_PISTOL", label = "Pistol", price = 1000},
		{name = "WEAPON_COMBATPISTOL", label = "Combat pistol", price = 1000}
	}
}

Config.CustomClothing = {
	parts = {
		{name = "torso_1", label = "Torso 1", type = "outfit", min = 1, max = 10, zoomOffset = 0.35, camOffset = 0.0},
		{name = "torso_2", label = "Torso 2", type = "outfit", min = 1, max = 10, zoomOffset = 0.35, camOffset = 0.0},
		{name = "bproof_1", label = "Vest 1", type = "outfit", min = 1, max = 10, zoomOffset = 0.35, camOffset = 0.0},
		{name = "bproof_2", label = "Vest 2", type = "outfit", min = 1, max = 10, zoomOffset = 0.35, camOffset = 0.0},
		{name = "pants_1", label = "Pants 1", type = "outfit", min = 1, max = 10, zoomOffset = -0.50, camOffset = 0.0},
		{name = "pants_2", label = "Pants 2", type = "outfit", min = 1, max = 10, zoomOffset = 0.35, camOffset = 0.0},
		{name = "shoes_1", label = "Shoes 1", type = "outfit", min = 1, max = 10, zoomOffset = -0.50, camOffset = 0.0},
		{name = "shoes_2", label = "Shoes 2", type = "outfit", min = 1, max = 10, zoomOffset = 0.35, camOffset = 0.0},
		{name = "save", label = "Save your outfit", type = "save"}
	},

	pedHeading = 0.0
}

Config.AuthorizedVehicles = {
	Shared = {
		{
			model = 'police',
			label = 'Police Cruiser',
			livery = 0
		},
		{
			model = 'pbus',
			label = 'Police Prison Bus',
			livery = 0
		}
	},

	recruit = {

	},

	officer = {
		{
			model = 'police3',
			label = 'Police Interceptor',
			livery = 0
		}
	},

	sergeant = {
		{
			model = 'policet',
			label = 'Police Transporter',
			livery = 0
		},
		{
			model = 'policeb',
			label = 'Police Bike',
			livery = 0
		}
	},

	intendent = {

	},

	lieutenant = {
		{
			model = 'riot',
			label = 'Police Riot',
			livery = 0
		},
		{
			model = 'fbi2',
			label = 'FIB SUV',
			livery = 0
		}
	},

	chef = {

	},

	boss = {

	}
}

Config.AuthorizedHelicopters = {
	Shared = {
		{
			model = 'polmav',
			label = 'Police helicopter'
		},
		{
			model = 'buzzard',
			label = 'Buzzard'
		}
	},

	recruit = {
	},

	officer = {
	},

	sergeant = {
	},

	intendent = {
	},

	lieutenant = {
	},

	chef = {
	},

	boss = {
	}
}

Config.Uniforms = {
	bullet_wear = {
		male = {
			['bproof_1'] = 11,  ['bproof_2'] = 1
		},
		female = {
			['bproof_1'] = 13,  ['bproof_2'] = 1
		}
	},
	gilet_wear = {
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 1
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1
		}
	}

}