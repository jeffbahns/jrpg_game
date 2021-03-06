LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")
LoadLibrary("Vector")
LoadLibrary("Asset")
LoadLibrary("Keyboard")

Asset.Run("Map.lua")
Asset.Run("Util.lua")
Asset.Run("Entity.lua")
Asset.Run("StateMachine.lua")
Asset.Run("MoveState.lua")
Asset.Run("WaitState.lua")
Asset.Run("Tween.lua")
Asset.Run("small_room.lua")


local gMap = Map:Create(CreateMap1())
gRenderer = Renderer:Create()

gMap:GotoTile(5, 5)

local heroDef =
{
    texture = "walk_cycle.png",
    width = 16,
    height = 24,
    startFrame = 9,
    tileX = 10,
    tileY = 2
}

local gHero
gHero =
{
    mController = StateMachine:Create
    {
        ['wait'] = function() return WaitState:Create(gHero, gMap) end,
        ['move'] = function() return MoveState:Create(gHero, gMap) end,
    },
    mEntity = Entity:Create(heroDef)
}
gHero.mController:Change("wait")

function Teleport(entity, map)
    local x, y = map:GetTileFoot(entity.mTileX, entity.mTileY)
    entity.mSprite:SetPosition(x, y + entity.mHeight / 2)
end
Teleport(gHero.mEntity, gMap)

function update()

    local dt = GetDeltaTime()

    local playerPos = gHero.mEntity.mSprite:GetPosition()
    gMap.mCamX = math.floor(playerPos:X())
    gMap.mCamY = math.floor(playerPos:Y())

    gRenderer:Translate(-gMap.mCamX, -gMap.mCamY)
    gMap:Render(gRenderer)
    gRenderer:DrawSprite(gHero.mEntity.mSprite)

    gHero.mController:Update(dt)
end