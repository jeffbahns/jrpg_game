LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")

gTextures =
{
    Texture.Find("tiles_00.png"),
    Texture.Find("tiles_01.png"),
    Texture.Find("tiles_02.png"),
    Texture.Find("tiles_03.png"),
    Texture.Find("tiles_04.png"),
    Texture.Find("tiles_05.png"),
    Texture.Find("tiles_06.png"),
    Texture.Find("tiles_07.png"),
    Texture.Find("tiles_08.png"),
    Texture.Find("tiles_09.png"),
    Texture.Find("tiles_10.png"),
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


gTileWidth = gTextures[1]:GetWidth()
gTileHeight = gTextures[1]:GetHeight()

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
gTileSprite:SetTexture(gTextures[1])

function update()
    for j = 0, gMapHeight - 1 do
        for i = 0, gMapWidth - 1 do
            local tile = GetTile(gMap, gMapWidth, i, j)
            local texture = gTextures[tile]
            gTileSprite:SetTexture(texture)
            gTileSprite:SetPosition(gLeft + i * gTileWidth, gTop - j * gTileHeight)
            gRenderer:DrawSprite(gTileSprite)
        end
    end
end