LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")
LoadLibrary("Vector")
LoadLibrary("Asset")
LoadLibrary("Keyboard")

Asset.Run("Util.lua")
Asset.Run("Panel.lua")
Asset.Run("Textbox.lua")

gRenderer = Renderer.Create()

local textbox = Textbox:Create
{
    text = "hello",
    textScale = 2,
    size =
    {
        left = -100,
        right = 100,
        top = 32,
        bottom = -32,
    },
    textbounds =
    {
        left = 10,
        right = -10,
        top = -10,
        bottom = 10
    },
    panelArgs =
    {
        texture = Texture.Find("gradient_panel.png"),
        size = 3
    }
}

function update()
    textbox:Render(gRenderer)
end

