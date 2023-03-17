WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 500
VIRTUAL_HEIGHT = 282
TILE_SIZE = 16

WORLD_WIDTH = 100 --tiles
WORLD_HEIGHT = 100 --tiles

SETTLEMENT_TYPES = {
    ['house'] = {width = 1, height = 1, tiles =  {15, 16, 17, 41, 42, 43}},
    ['hamlet'] = {width = 2, height = 2, startTile = 18},
    ['village'] = {width = 3, height = 2, startTile = 21},
    ['town'] = {width = 3, height = 2, startTile = 24},
    ['city'] = {width = 3, height = 3, startTile = 67},
    ['walled-city'] = {width = 3, height = 3, startTile = 70},
    ['castle1'] = {width = 3, height = 3, startTile = 73},
    ['castle2'] = {width = 3, height = 3, startTile = 76}
}

--tile id's
WATER_ID = 626
GRASS_ID = 80

ISLAND_TILES = {53, 54, 55,
                79, 80, 81,
                105, 106, 107,
            
            2, 3, 4, 28, 29}
