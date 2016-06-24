LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")
LoadLibrary("Vector")
LoadLibrary("Asset")
LoadLibrary("Keyboard")

Asset.Run("Util.lua")
Asset.Run("Tween.lua")
Asset.Run("Panel.lua")
Asset.Run("Textbox.lua")

gRenderer = Renderer.Create()

function CreateFixed(renderer, x, y, width, height, text, params)

    params = params or {}
    local avatar = params.avatar
    local title = params.title

    local padding = 10
    local textScale = 1.5
    local panelTileSize = 3

    local wrap = width - padding
    local boundsTop = padding
    local boundsLeft = padding

    local children = {}

    if avatar then
        boundsLeft = avatar:GetWidth() + padding * 2
        wrap = width - (boundsLeft) - padding
        local sprite = Sprite.Create()
        sprite:SetTexture(avatar)
        table.insert(children,
        {
            type = "sprite",
            sprite = sprite,
            x = avatar:GetWidth() / 2 + padding,
            y = -avatar:GetHeight() / 2
        })
    end

    if title then
        -- adjust the top
        local size = renderer:MeasureText(title, wrap)
        boundsTop = size:Y() + padding * 2

        table.insert(children,
        {
            type = "text",
            text = title,
            x = 0,
            y = size:Y() + padding
        })
    end

    return Textbox:Create
    {
        text = text,
        textScale = textScale,
        size =
        {
            left    = x - width / 2,
            right   = x + width / 2,
            top     = y + height / 2,
            bottom  = y - height / 2
        },

        textbounds =
        {
            left = boundsLeft,
            right = -padding,
            top = -boundsTop,
            bottom = padding
        },
        panelArgs =
        {
            texture = Texture.Find("gradient_panel.png"),
            size = panelTileSize,
        },
        children = children,
        wrap = wrap
    }
end

local text = "It's dangerous to go alone! Take this."
local textbox = CreateFixed(gRenderer, 100, -100, 320, 100, text,
{
    title = "Charles:",
    avatar = Texture.Find("avatar.png")
})

function update()
    textbox:Update(GetDeltaTime())
    textbox:Render(gRenderer)
end

