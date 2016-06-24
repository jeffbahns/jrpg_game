LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("Texture")

gRenderer = Renderer:Create()

gTileSprite = Sprite:Create()
gTileSprite:SetTexture(Texture.Find("uv_example.png"))

-- Play around with different numbers to get a feel for how the UVs work
-- The first two coordinates are the U = {x, y} and the last to V = {x, y}
gTileSprite:SetUVs(0,0,1,1)
--gTileSprite:SetUVs(0.25,0.25,0.75,0.75) -- draws half the image from the center

function update()
    gRenderer:DrawSprite(gTileSprite)
end