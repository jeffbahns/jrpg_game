LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")
LoadLibrary("Asset")

Asset.Run("example_map.lua")
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
gTextureAtlas = Texture.Find(gTiledMap.tilesets[1].image)
gUVs = GenerateUVs(
                   gTiledMap.tilesets[1].tilewidth,
                   gTiledMap.tilesets[1].tileheight,
                   gTextureAtlas)


-- Print out the UVs, for checking
-- for k, v in ipairs(gUVs) do
--     print(k, string.format("{%.f, %.f, %.f, %.f}", v[1], v[2], v[3], v[4]))
-- end



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

function update()
    for j = 0, gMapHeight - 1 do
        for i = 0, gMapWidth - 1 do
            local tile = GetTile(gTiles, gMapWidth, i, j)
            local uvs = gUVs[tile]
            gTileSprite:SetUVs(unpack(uvs))
            gTileSprite:SetPosition(gLeft + i * gTileWidth, gTop - j * gTileHeight)
            gRenderer:DrawSprite(gTileSprite)
        end
    end
end