Config = {}

Config.DefaultVolume = 0.1 -- Accepted values are 0.01 - 1

Config.Locations = {
    ['vanilla'] = {
        ['job'] = 'police', -- Required job to use booth
        ['radius'] = 20, -- The radius of the sound from the booth
        ['coords'] = vector3(2308.0, -330.46, 41.69), -- Where the booth is located
        ['playing'] = false
    }
}
