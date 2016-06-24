LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")

gTextureAtlas = Texture.Find("atlas.png")

gUVs =
{
    {0,  0, 0.0625, 0.0625},
    {0.0625, 0, 0.125, 0.0625},
    {0.125, 0, 0.1875, 0.0625},
    {0.1875, 0, 0.25, 0.0625},
    {0.25, 0, 0.3125, 0.0625},
    {0.3125, 0, 0.375, 0.0625},
    {0.375, 0, 0.4375, 0.0625},
    {0.4375, 0, 0.5, 0.0625},
    {0.5, 0, 0.5625, 0.0625},
    {0.5625, 0, 0.625, 0.0625},
    {0.625, 0, 0.6875, 0.0625},
}

gMap =
{
    1,1,1,1,5,6, 7,1,   -- 1
    1,1,1,1,5,6,7,1,    -- 2
    1,1,1,1,5,6,7,1,    -- 3
    3,3,3,3,11,6,7,1,   -- 4
    9,9,9,9,9,9,10,1,   -- 5
    1,1,1,1,1,1,1,1,    -- 6
    1,1,1,1,1,1,2,3,    -- 7
}
gMapWidth = 8
gMapHeight = 7


gTileWidth = 32
gTileHeight = 32

gDisplayWidth = System.ScreenWidth()
gDisplayHeight = System.ScreenHeight()

gTop = gDisplayHeight / 2 - gTileHeight / 2
gLeft = -gDisplayWidth / 2 + gTileWidth / 2


function GetTile(map, rowsize, x, y)
    x = x + 1 -- change from  1 -> rowsize
              -- to           0 -> rowsize - 1
    return map[x + y * rowsize]
end

gRenderer = Renderer.Create()

local row = 0
for col = 0, gMapWidth - 1 do
    local coords = string.format("[%d,%d]: ", col, row)
    print(coords, GetTile(gMap, gMapWidth, col, row))
end

gTileSprite = Sprite.Create()
gTileSprite:SetTexture(gTextureAtlas)

function update()
    for j = 0, gMapHeight - 1 do
        for i = 0, gMapWidth - 1 do
            local tile = GetTile(gMap, gMapWidth, i, j)
            local uvs = gUVs[tile]
            gTileSprite:SetUVs(unpack(uvs))
            gTileSprite:SetPosition(gLeft + i * gTileWidth, gTop - j * gTileHeight)
            gRenderer:DrawSprite(gTileSprite)
        end
    end
end