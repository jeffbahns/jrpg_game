LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")

gTextureAtlas = Texture.Find("atlas.png")


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

gTileSprite = Sprite.Create()
gTileSprite:SetTexture(gTextureAtlas)

function update()
    -- for j = 0, gMapHeight - 1 do
    --     for i = 0, gMapWidth - 1 do
    --         local tile = GetTile(gMap, gMapWidth, i, j)
    --         local uvs = gUVs[tile]
    --         gTileSprite:SetUVs(unpack(uvs))
    --         gTileSprite:SetPosition(gLeft + i * gTileWidth, gTop - j * gTileHeight)
    --         gRenderer:DrawSprite(gTileSprite)
    --     end
    -- end
end