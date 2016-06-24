LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")
LoadLibrary("Vector")
LoadLibrary("Asset")
LoadLibrary("Keyboard")

Asset.Run("Map.lua")
Asset.Run("Util.lua")
Asset.Run("small_room.lua")

local gMap = Map:Create(CreateMap1())
gRenderer = Renderer:Create()


gMap:GotoTile(5, 5)

gHeroTexture = Texture.Find("walk_cycle.png")
local heroWidth = 16  -- pixels
local heroHeight = 24
gHeroUVs = GenerateUVs(heroWidth,
                       heroHeight,
                       gHeroTexture)

gHeroSprite = Sprite:Create()
gHeroSprite:SetTexture(gHeroTexture)
-- 9 is the hero facing forward
gHeroSprite:SetUVs(unpack(gHeroUVs[9]))

function Teleport(tileX, tileY, map)
    local x, y = map:GetTileFoot(tileX, tileY)
    gHeroSprite:SetPosition(x,
                            y + heroHeight / 2)
end
-- 10, 2 is the tile in front of the door
gHeroX = 10
gHeroY = 2
Teleport(gHeroX, gHeroY, gMap)

function update()

    gRenderer:Translate(-gMap.mCamX, -gMap.mCamY)
    gMap:Render(gRenderer)
    gRenderer:DrawSprite(gHeroSprite)

    if Keyboard.JustPressed(KEY_LEFT) then
        gHeroX = gHeroX - 1
        Teleport(gHeroX, gHeroY, gMap)
    elseif Keyboard.JustPressed(KEY_RIGHT) then
        gHeroX = gHeroX + 1
        Teleport(gHeroX, gHeroY, gMap)
    end

    if Keyboard.JustPressed(KEY_UP) then
        gHeroY = gHeroY - 1
        Teleport(gHeroX, gHeroY, gMap)
    elseif Keyboard.JustPressed(KEY_DOWN) then
        gHeroY = gHeroY + 1
        Teleport(gHeroX, gHeroY, gMap)
    end

end