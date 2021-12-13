--
-- Constants
--

CONST_NOTWORKING     = 0
CONST_WAITINGFORTASK = 1
CONST_PICKINGUP      = 2
CONST_DELIVERING     = 3

--
-- Configuration
--

Config = {}

Config.AbortKey         = 73 -- (X)
Config.TruckRentalPrice = 1500
Config.TruckModel       = 'phantom'
Config.PayPerMeter      = 0.5

Config.JobStart = {
	Coordinates = vector3(854.53, -3211.73, 6.0),
	Heading     = 179.33,
}

Config.Blip = {
	SpriteID = 479,
	ColorID  = 0,
	Scale    = 0.6,
}

Config.Marker = {
	DrawDistance = 100.0,
	Size = vector3(3.0, 3.0, 0.5),
	Color = {
		r = 100,
		g = 100,
		b = 155,
	},
	Type = 2,
}

Config.Routes = {
	{
		TrailerModel      = 'tr4',
		PickupCoordinates = vector3(509.23, -3039.27, 7.32),
		PickupHeading     = 357.82,
		Destinations = {			
			vector3(-810.84, -228.29, 37.21), -- Luxury Autos
			vector3(868.27, -915.56, 26.03), -- Maibatsu Motors Factory
		}
	},
	{
		TrailerModel      = 'trailerlogs',
		PickupCoordinates = vector3(-843.92, 5416.16, 36.46),
		PickupHeading     = 79.30,
		Destinations = {
			vector3(985.74, -2523.91, 28.3), -- Cypress Warehouses
			vector3(63.74, -325.91, 45.3), -- Middle of city, where wood is.
		}
	},
	{
		TrailerModel      = 'docktrailer',
		PickupCoordinates = vector3(-646.10,-1726.81, 24.99),
		PickupHeading     = 340.60,
		Destinations = {
			vector3(264.38, -1244.98, 29.14), -- Xero 24 (Postal 4027)
			vector3(1780.95, 3330.17, 41.25), -- Gas (Postal 802)
			vector3(-97.66, 6422.26, 31.43), -- Xero (Postal 911)
			vector3(-1811.93, 810.2, 138.53), -- Xero (Postal 911)
		}
	},
	{
		TrailerModel      = 'trailers4',
		PickupCoordinates = vector3(77.50,6325.53, 31.23),
		PickupHeading     = 30.00,
		Destinations = {
			vector3(1907.21, 566.12, 176.82), -- Near Mining Place
			vector3(1964.91, 4644.60, 41.88), -- Somewhere in Blaine.
			vector3(1682.20, 3271.59, 41.75), -- Near Sandy Airport
			vector3(1843.90, 2559.69, 46.67), -- Prison
			vector3(24.90, -371.69, 40.38), -- City place.
		}
	},
	{
		TrailerModel      = 'trailers2',
		PickupCoordinates = vector3(161.00,-2980.86, 5.89),
		PickupHeading     = 267.96,
		Destinations = {
			vector3(1137.96, -292.31, 69.85), -- Some place.
			vector3(1106.88, 212.87, 81.99), -- Behind CASINO
			vector3(-388.78, 279.17, 85.70), --Some pleac.e
			vector3(-306.85, -939.09, 32.08), -- Some other place.
			vector3(-133.33, -262.51, 43.81), -- In front of cluckin' bell.
		}
	},
	{
		TrailerModel      = 'armytrailer',
		PickupCoordinates = vector3(-338.16,6070.12, 31.30),
		PickupHeading     = 222.23,
		Destinations = {
			vector3(821.50, -2142.59, 29.87), -- Ammuniation.
			vector3(2554.38, 288.66, 109.46), -- Another gun stor.e
			vector3(-1133.55, 2694.31, 19.80), -- Another gun store
		}
	},
}
