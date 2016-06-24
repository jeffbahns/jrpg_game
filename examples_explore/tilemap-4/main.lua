LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")

gRenderer = Renderer.Create()
gLeft = -System.ScreenWidth() / 2
gTop = System.ScreenHeight() / 2

gTileSprite = Sprite.Create()

gGrassTexture = Texture.Find("grass_tile.png")
gTileWidth = gGrassTexture:GetWidth()
gTileHeight = gGrassTexture:GetHeight()

gTileSprite:SetTexture(gGrassTexture)
gTileSprite:SetPosition(gLeft + gTileWidth / 2, gTop - gTileHeight / 2)

function update()
    gRenderer:DrawSprite(gTileSprite)
end