Config = {}

Config.ServerName = "SelfishEagle's Development Server"
Config.Locale = 'en'

Config.DefaultSpawn = vector3( -269.4, -955.3, 31.2)

Config.Debug = true

-- Settings from se-multi
Config.MaxCharacters = 5
Config.AllowDelete = true

-- New Spawn Selector Locations
-- You can add as many as you want here. The key (e.g., 'legion') must be unique.
Config.SpawnLocations = {
    ['legion'] = {
        label = 'Legion Square',
        description = 'Spawn in the heart of the city.',
        coords = vector4(200.4, -935.2, 30.7, 88.0)
    },
    ['sandy'] = {
        label = 'Sandy Shores',
        description = 'Start your journey out in the desert.',
        coords = vector4(1975.8, 3816.7, 32.4, 296.5)
    },
    ['paleto'] = {
        label = 'Paleto Bay',
        description = 'A quiet life up north awaits.',
        coords = vector4(-448.5, 6013.2, 31.7, 311.9)
    }
}

Config.Status = {
    Interval = 60000, -- Changed to 60 seconds for easy testing
    HungerDecay = 0.8,
    ThirstDecay = 1.2
}