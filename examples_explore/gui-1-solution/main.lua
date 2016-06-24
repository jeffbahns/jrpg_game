LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")
LoadLibrary("Vector")
LoadLibrary("Asset")
LoadLibrary("Keyboard")

Asset.Run("Util.lua")
Asset.Run("Panel.lua")

gRenderer = Renderer.Create()

local gPanel = Panel:Create
{
    texture = Texture.Find("simple_panel.png"),
    size = 3,
}
local left = -100
local top = 0
local right = 100
local bottom = -100
gPanel:Position(left, top, right, bottom)


function update()
    gPanel:Render(gRenderer)
end