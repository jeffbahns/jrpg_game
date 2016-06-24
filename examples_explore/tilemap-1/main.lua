LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("Texture")

gRenderer = Renderer:Create()

gTileSprite = Sprite:Create()
gTileSprite:SetTexture(Texture.Find("grass_tile.png"))

function update()
  gRenderer:DrawSprite(gTileSprite)
end
