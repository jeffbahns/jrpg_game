LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")
LoadLibrary("Asset")
LoadLibrary("Keyboard")


Asset.Run("Map.lua")
Asset.Run("Util.lua")
Asset.Run("small_room.lua")

local gMap = Map:Create(CreateMap1())
gRenderer = Renderer:Create()

gMap:GotoTile(5, 5)

gHeroTexture = Texture.Find("walk_cycle.png")
local heroWidth = 16 -- pixels
local heroHeight = 24
gHeroUVs = GenerateUVs(heroWidth,
                       heroHeight,
                       gHeroTexture)
gHeroSprite = Sprite:Create()
gHeroSprite:SetTexture(gHeroTexture)
gHeroSprite:SetUVs(unpack(gHeroUVs[9]))

function update()
    gRenderer:Translate(-gMap.mCamX, -gMap.mCamY)
    gMap:Render(gRenderer)
    gRenderer:DrawSprite(gHeroSprite)
end