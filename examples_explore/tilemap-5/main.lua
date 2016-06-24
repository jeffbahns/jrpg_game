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

gTilesPerRow = math.ceil(gDisplayWidth/gTileWidth)
gTilesPerColumn = math.ceil(gDisplayHeight/gTileHeight)


function update()
    local y = 0
    local x = -100
    gRenderer:DrawText2d(x, y, "Display Width: " .. gDisplayWidth)
    y = y + 30
    gRenderer:DrawText2d(x, y, "Display Height: " .. gDisplayHeight)
    y = y + 30
    gRenderer:DrawText2d(x, y, "Tiles per row: " .. math.ceil(gDisplayWidth/gTileWidth))
    y = y + 30
    gRenderer:DrawText2d(x, y, "Tiles per column: " .. math.ceil(gDisplayHeight/gTileHeight))
end