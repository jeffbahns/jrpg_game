LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")
LoadLibrary("Vector")
LoadLibrary("Asset")
LoadLibrary("Keyboard")


Asset.Run("Animation.lua")
Asset.Run("Map.lua")
Asset.Run("Util.lua")
Asset.Run("Entity.lua")
Asset.Run("StateMachine.lua")
Asset.Run("MoveState.lua")
Asset.Run("WaitState.lua")
Asset.Run("Tween.lua")
Asset.Run("Actions.lua")
Asset.Run("Trigger.lua")
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
    tileX = 11,
    tileY = 3,
    layer = 1
}

gHero =
{
    mAnimUp = {1, 2, 3, 4},
    mAnimRight = {5, 6, 7, 8},
    mAnimDown = {9, 10, 11, 12},
    mAnimLeft = {13, 14, 15, 16},
    mEntity = Entity:Create(heroDef),
    Init =
    function(self)
        self.mController = StateMachine:Create
        {
            ['wait'] = function() return self.mWaitState end,
            ['move'] = function() return self.mMoveState end,
        }
        self.mWaitState = WaitState:Create(self, gMap)
        self.mMoveState = MoveState:Create(self, gMap)
        self.mController:Change("wait")
    end
}
gHero:Init()

gUpDoorTeleport = Actions.Teleport(gMap, 11, 3)
gDownDoorTeleport = Actions.Teleport(gMap, 10, 11)
gUpDoorTeleport(nil, gHero.mEntity)


gTriggerTop =   Trigger:Create
                {
                    OnEnter = gDownDoorTeleport
                }

gTriggerBot =   Trigger:Create
                {
                    OnEnter = gUpDoorTeleport,
                }

gMap.mTriggers =
{
    -- Layer 1
    {
        [gMap:CoordToIndex(10, 12)] = gTriggerBot,
        [gMap:CoordToIndex(11, 2)] = gTriggerTop,
    }
}

function GetFacedTileCoords(character)

    -- Change the facing information into a tile offset
    local xInc = 0
    local yInc = 0

    if character.mFacing == "left" then
        xInc = 1
    elseif character.mFacing == "right" then
        xInc = -1
    elseif character.mFacing == "up" then
        yInc = -1
    elseif character.mFacing == "down" then
        yInc = 1
    end

    local x = character.mEntity.mTileX + xInc
    local y = character.mEntity.mTileY + yInc

    return x, y
end

function update()

    local dt = GetDeltaTime()

    local playerPos = gHero.mEntity.mSprite:GetPosition()
    gMap.mCamX = math.floor(playerPos:X())
    gMap.mCamY = math.floor(playerPos:Y())

    gRenderer:Translate(-gMap.mCamX, -gMap.mCamY)

    local layerCount = gMap:LayerCount()

    for i = 1, layerCount do
        gMap:RenderLayer(gRenderer, i)
        if i == gHero.mEntity.mLayer then
            gRenderer:DrawSprite(gHero.mEntity.mSprite)
        end
    end

    gHero.mController:Update(dt)

    if Keyboard.JustPressed(KEY_SPACE) then
        -- which way is the player facing?
        local x, y = GetFacedTileCoords(gHero)
        local trigger gMap:GetTrigger(gHero.mEntity.mLayer, x, y)
        if trigger then
            trigger:OnUse(gHero)
        end
    end
end