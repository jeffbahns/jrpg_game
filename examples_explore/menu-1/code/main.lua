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
Asset.Run("Panel.lua")
Asset.Run("ProgressBar.lua")
Asset.Run("Selection.lua")
Asset.Run("Textbox.lua")
Asset.Run("StateStack.lua")

local mapDef = CreateMap1()
mapDef.on_wake = {}
mapDef.actions = {}
mapDef.trigger_types = {}
mapDef.triggers = {}
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