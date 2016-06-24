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
gPanel:CenterPosition(0, 0, 128, 32)


function update()
    gPanel:Render(gRenderer)

    gRenderer:AlignText("center", "center")
    gRenderer:DrawText2d(0,0, "Hello World", Vector.Create(1,1,1,1))
end

