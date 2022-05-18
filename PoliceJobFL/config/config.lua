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
			{ x = 450.28, y = -994.0, z = 30.20, cloakroom = "#1" },
			{ x = 451.1, y = -994.0, z = 30.20, cloakroom = "#2" },
			{ x = 451.83, y = -994.0, z = 30.20, cloakroom = "#3" },
			{ x = 452.59, y = -994.0, z = 30.20, cloakroom = "#4" },
			{ x = 453.36, y = -994.0, z = 30.20, cloakroom = "#5" },

			{ x = 449.0, y = -992.94, z = 30.20, cloakroom = "#6" },
			{ x = 449.0, y = -992.15, z = 30.20, cloakroom = "#7" },
			{ x = 449.0, y = -991.31, z = 30.20, cloakroom = "#8" },
			{ x = 449.0, y = -990.51, z = 30.20, cloakroom = "#9" },

			key = {
				location = { x = 447.04, y = -988.8, z = 29.69 },
				heading = 3.38,
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
					location = { x = 454.28, y = -980.14, z = 29.69 },
					text = "press ~g~E~w~ to access the armory",
					heading = 86.78,
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
					location = { x = 458.27, y = -1017.22, z = 27.24 },
					text = "press ~g~E~w~ to take out a vehicle",
					heading = 93.92,
					model = "s_m_m_autoshop_02",
					scenario = 0,
					animDict = "amb@world_human_aa_smoke@male@idle_a",
					animName = "idle_c",
				},
				SpawnPoints = {
					{ x = 452.68, y = -997.03, z = 24.76, heading = 0.81, radius = 2.0 },
					{ x = 447.6, y = -997.03, z = 24.76, heading = 0.81, radius = 2.0 },
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
			{ x = 452.68, y = -997.03, z = 24.76, place = "#1" },
			{ x = 447.6, y = -997.03, z = 24.76, place = "#2" },

			access = {
				["recruit"] = true,
				["officer"] = true,
				["sergeant"] = true,
				["lieutenant"] = true,
				["boss"] = true
			}
		},

		BossActions = {
			{ x = 447.0, y = -974.55, z = 30.0, text = "press ~g~E~w~ to computer access" },

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