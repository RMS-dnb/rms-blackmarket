Config = Config or {}

Config.BlackmarketCycling = true -- Whether the blackmarket should move around
Config.BlackmarketMoveAtStart = true -- Make it so Blackmarket will only switch position every server restart!
Config.BlackmarketCanBuy = true -- Whether it's possible to sell items to blackmarket or not!
Config.CycleInterval = 240 -- How often in minutes the blackmarket should move around

Config.BlackmarketPed = 'g_m_m_unibanditos_01' -- What ped you want the blackmarket to be!
Config.BlackmarketPositions = { -- You can add as many positions, and it will spawn a random location every server start/interval, if you want him to be only one place, just only add 1 coord!
    vector4(-1242.64, -2786.64, 87.60, 45.38),
    vector4(-1345.848, 2442.7258, 308.68823, 339.39105),
    vector4(-551.7838, 2708.5024, 323.44174, 149.95095),
    vector4(1202.0118, 612.41149, 91.206932, 101.94412),
    vector4(-4227.611, -3429.571, 37.2807, 45.342361)
}


Config.BlackmarketBuy = { -- Items that you can buy to blackmarket if enabled!
    {
        name = 'bread', -- The name of the item
        price = 2, -- The price to sell this item!
    },
    {
        name = 'water',
        price = 5,
    },
--     {
--         name = 'opium',
--         price = 10,
--     },
--     {
--         name = 'goldbar',
--         price = 100,
--     },
--     {
--         name = 'peyote',
--         price = 2,
--     },
--     {
--         name = 'shrooms',
--         price = 1.25,
--     }
 }