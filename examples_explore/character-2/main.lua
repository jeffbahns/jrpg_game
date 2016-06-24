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
-- 10, 2 is the tile in front of the door
gHeroTileX = 10
gHeroTileY = 2
local x, y = gMap:GetTileFoot(gHeroTileX, gHeroTileY)
gHeroSprite:SetPosition(x,
                        y + heroHeight / 2)

function update()

    gRenderer:Translate(-gMap.mCamX, -gMap.mCamY)
    gMap:Render(gRenderer)
    gRenderer:DrawSprite(gHeroSprite)

    if Keyboard.Held(KEY_LEFT) then
        gMap.mCamX = gMap.mCamX - 1

    elseif Keyboard.Held(KEY_RIGHT) then
        gMap.mCamX = gMap.mCamX + 1
    end

    if Keyboard.Held(KEY_UP) then
        gMap.mCamY = gMap.mCamY + 1
    elseif Keyboard.Held(KEY_DOWN) then
        gMap.mCamY = gMap.mCamY - 1
    end
end