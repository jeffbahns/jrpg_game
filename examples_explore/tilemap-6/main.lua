LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")

gRenderer = Renderer.Create()

gTexture = Texture.Find("grass_tile.png")
gTileWidth = gTexture:GetWidth()
gTileHeight = gTexture:GetHeight()

gDisplayWidth = System.ScreenWidth()
gDisplayHeight = System.ScreenHeight()

gTop = gDisplayHeight / 2 - gTileHeight / 2
gLeft = -gDisplayWidth / 2 + gTileWidth / 2

gTilesPerRow = math.ceil(gDisplayWidth/gTileWidth)
gTilesPerColumn = math.max(gDisplayHeight/gTileHeight)

gTileSprite = Sprite.Create()
gTileSprite:SetTexture(gTexture)

function update()
    for i = 0, gTilesPerRow - 1 do
        gTileSprite:SetPosition(gLeft + i * gTileWidth, gTop)
        gRenderer:DrawSprite(gTileSprite)
    end
end