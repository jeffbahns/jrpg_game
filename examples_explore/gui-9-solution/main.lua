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
    local boundsBottom = padding

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

    renderer:ScaleText(textScale)
    --
    -- Section text into box size chunks.
    --
    local faceHeight = math.ceil(renderer:MeasureText(text):Y())
    local start, finish = gRenderer:NextLine(text, 1, wrap)

    local boundsHeight = height - (boundsTop + boundsBottom)
    local currentHeight = faceHeight

    local chunks = {{string.sub(text, start, finish)}}
    while finish < #text do
        start, finish = gRenderer:NextLine(text, finish, wrap)

        -- If we're going to overflow
        if (currentHeight + faceHeight) > boundsHeight then
            -- make a new entry
            currentHeight = 0
            table.insert(chunks, {string.sub(text, start, finish)})
        else
            table.insert(chunks[#chunks], string.sub(text, start, finish))
        end
        currentHeight = currentHeight + faceHeight
    end

    -- Make each textbox be represented by one string.
    for k, v in ipairs(chunks) do
        chunks[k] = table.concat(v)
    end

    return Textbox:Create
    {
        text = chunks,
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

local width = System.ScreenWidth() - 4
local height = 102 -- a nice height
local x = 0
local y = -System.ScreenHeight()/2 + height / 2 -- bottom of the screen
local text = '"A nation can survive its fools, and even the ambitious. But it cannot survive treason from within. An enemy at the gates is less formidable, for he is known and carries his banner openly. But the traitor moves amongst those within the gate freely, his sly whispers rustling through all the alleys, heard in the very halls of government itself. For the traitor appears not a traitor; he speaks in accents familiar to his victims, and he wears their face and their arguments, he appeals to the baseness that lies deep in the hearts of all men. He rots the soul of a nation, he works secretly and unknown in the night to undermine the pillars of the city, he infects the body politic so that it can no longer resist. A murderer is less to fear.'
local title = "NPC:"
local avatar = Texture.Find("avatar.png")
local textbox = CreateFixed(gRenderer, x, y, width, height, text, title, avatar)

function update()
    if not textbox:IsDead() then
        textbox:Update(GetDeltaTime())
        textbox:Render(gRenderer)
    end

    if Keyboard.JustPressed(KEY_SPACE) then
        textbox:OnClick()
    end
end
