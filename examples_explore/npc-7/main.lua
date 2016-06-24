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
Asset.Run("NPCStandState.lua")
Asset.Run("PlanStrollState.lua")
Asset.Run("Tween.lua")
Asset.Run("Actions.lua")
Asset.Run("Trigger.lua")
Asset.Run("EntityDefs.lua")
Asset.Run("Character.lua")
Asset.Run("small_room.lua")

local mapDef = CreateMap1()
mapDef.on_wake =
{
    {
        id = "AddNPC",
        params = {{ def = "strolling_npc", x = 11, y = 5 }}
    },
    {
        id = "AddNPC",
        params = {{ def = "standing_npc", x = 4, y = 5 }}
    },
}
mapDef.actions =
{
    tele_south = { id = "Teleport", params = {11, 3} },
    tele_north = { id = "Teleport", params = {10, 11} }
}
mapDef.trigger_types =
{
    north_door_trigger = { OnEnter = "tele_north" },
    south_door_trigger = { OnEnter = "tele_south" }
}
mapDef.triggers =
{
    { trigger = "north_door_trigger", x = 11, y = 2},
    { trigger = "south_door_trigger", x = 10, y = 12},
}
local gMap = Map:Create(mapDef)
gRenderer = Renderer:Create()
gMap:GotoTile(5, 5)
gHero = Character:Create(gCharacters.hero, gMap)
gHero.mEntity:SetTilePos(11, 3, 1, gMap)

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

        local heroEntity = nil
        if i == gHero.mEntity.mLayer then
            heroEntity = gHero.mEntity
        end

        gMap:RenderLayer(gRenderer, i, heroEntity)

    end

    gHero.mController:Update(dt)
    --gNPC.mController:Update(dt)
    for k, v in ipairs(gMap.mNPCs) do
        v.mController:Update(dt)
    end

    if Keyboard.JustPressed(KEY_SPACE) then
        -- which way is the player facing?
        local x, y = GetFacedTileCoords(gHero)
        local trigger gMap:GetTrigger(gHero.mEntity.mLayer, x, y)
        if trigger then
            trigger:OnUse(gHero)
        end
    end
end