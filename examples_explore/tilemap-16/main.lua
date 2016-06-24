LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")
LoadLibrary("Asset")
LoadLibrary("Mouse")
LoadLibrary("Vector")

Asset.Run("larger_map.lua")
gTiledMap = CreateMap1()

function GenerateUVs(tileWidth, tileHeight, texture)

    -- This is the table we'll fill with uvs and return.
    local uvs = {}

    local textureWidth = texture:GetWidth()
    local textureHeight = texture:GetHeight()
    local width = tileWidth / textureWidth
    local height = tileHeight / textureHeight
    local cols = textureWidth / tileWidth
    local rows = textureHeight / tileHeight

    local ux = 0
    local uy = 0
    local vx = width
    local vy = height

    for j = 0, rows - 1 do
        for i = 0, cols -1 do

            table.insert(uvs, {ux, uy, vx, vy})

            -- Advance the UVs to the next column
            ux = ux + width
            vx = vx + width

        end

        -- Put the UVs back to the start of the next row
        ux = 0
        vx = width
        uy = uy + height
        vy = vy + height
    end
    return uvs
end

-- Create the UVs from the first tileset
-- Create the UVs from the first tileset
gTextureAtlas = Texture.Find(gTiledMap.tilesets[1].image)
gUVs = GenerateUVs(
                   gTiledMap.tilesets[1].tilewidth,
                   gTiledMap.tilesets[1].tileheight,
                   gTextureAtlas)


gDisplayWidth = System.ScreenWidth()
gDisplayHeight = System.ScreenHeight()



function GetTile(map, rowsize, x, y)
    x = x + 1 -- change from  1 -> rowsize
              -- to           0 -> rowsize - 1
    return map[x + y * rowsize]
end

gRenderer = Renderer.Create()

gTileSprite = Sprite.Create()
gTileSprite:SetTexture(gTextureAtlas)

gMap = gTiledMap.layers[1]
gMapHeight = gMap.height
gMapWidth = gMap.width
gTileWidth = gTiledMap.tilesets[1].tilewidth
gTileHeight = gTiledMap.tilesets[1].tileheight
gTiles = gMap.data

gTop = gDisplayHeight / 2 - gTileHeight / 2
gLeft = -gDisplayWidth / 2 + gTileWidth / 2

gRenderer:AlignTextX("center")

function PointToTile(x, y, tileSize, left, top, mapWidth, mapHeight)

    -- Tiles are rendered from the center so we adjust for this.
    x = x + tileSize / 2
    y = y - tileSize / 2

    -- Clamp the point to the bounds of the map
    x = math.max(left, x)
    y = math.min(top, y)
    x = math.min(left + (mapWidth * tileSize) - 1, x)
    y = math.max(top - (mapHeight * tileSize) + 1, y)


    -- Map from the bounded point to a tile
    local tileX = math.floor((x - left) / tileSize)
    local tileY = math.floor((top - y) / tileSize)

    return tileX, tileY
end

function update()

    for j = 0, gMapHeight - 1 do
        for i = 0, gMapWidth - 1 do

            local tile = GetTile(gTiles, gMapWidth, i, j)
            local uvs = gUVs[tile]
            gTileSprite:SetUVs(unpack(uvs))
            gTileSprite:SetPosition(gLeft + i * gTileWidth, gTop - j * gTileHeight)

            if i == tileX and j == tileY then
                gTileSprite:SetColor(Vector.Create(1, 1, 0, 1))
            else
                 gTileSprite:SetColor(Vector.Create(1, 1, 1, 1))
            end

            gRenderer:DrawSprite(gTileSprite)
        end
    end
end