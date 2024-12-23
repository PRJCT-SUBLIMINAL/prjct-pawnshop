Config = {}

Config.ShowBlips = true
Config.EnableLogging = false
Config.SellCooldown = 10 -- seconds

Config.BlipData = {
    sprite = 431,
    scale = 0.8,
    color = 5,
    label = 'Pawnshop'
}

Config.PedModel = `s_m_y_dealer_01`

Config.Locations = {
    {
        coords = vec3(182.1719, -1319.1627, 29.3156),
        heading = 241.4858
    },
    {
        coords = vec3(-1459.3762, -413.8532, 35.7396),
        heading = 230.0
    },
    {
        coords = vec3(412.2999, 314.5864, 103.1340),
        heading = 160.0
    }
}

Config.Items = {
    gold_necklace = {
        label = 'Gold Chain',
        price = 100
    },
    diamond = {
        label = 'Diamond',
        price = 80
    },
    gold_ring = {
        label = 'Gold Ring',
        price = 25
    },
    silver_necklace = {
        label = 'Silver Chain',
        price = 80
    }
}
