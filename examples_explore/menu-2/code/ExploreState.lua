
ExploreState = {}
ExploreState.__index = ExploreState
function ExploreState:Create(state, mapDef, startPos)
    local this =
    {
        mState = state,
        mMapDef = mapDef,
    }

    this.mMap = Map:Create(this.mMapDef)
    this.mHero = Character:Create(gCharacters.hero, this.mMap)
    this.mHero.mEntity:SetTilePos(
        startPos:X(),
        startPos:Y(),
        startPos:Z(), this.mMap)
    this.mMap:GotoTile(startPos:X(), startPos:Y())

    setmetatable(this, self)
    return this
end

function ExploreState:Enter()
end

function ExploreState:Exit()
end

function ExploreState:Update(dt)

    local hero = self.mHero
    local map = self.mMap

    -- Update the camera according to player position
    local playerPos = hero.mEntity.mSprite:GetPosition()
    map.mCamX = math.floor(playerPos:X())
    map.mCamY = math.floor(playerPos:Y())

    hero.mController:Update(dt)
    for k, v in ipairs(map.mNPCs) do
        v.mController:Update(dt)
    end

end

function ExploreState:Render(renderer)

    local hero = self.mHero
    local map = self.mMap

    renderer:Translate(-map.mCamX, -map.mCamY)
    local layerCount = map:LayerCount()

    for i = 1, layerCount do

        local heroEntity = nil
        if i == hero.mEntity.mLayer then
            heroEntity = hero.mEntity
        end

        map:RenderLayer(gRenderer, i, heroEntity)

    end

    renderer:Translate(0, 0)
end

function ExploreState:HandleInput()

    if Keyboard.JustPressed(KEY_SPACE) then
        -- which way is the player facing?
        local x, y = self.mHero:GetFacedTileCoords()
        local layer = self.mHero.mEntity.mLayer
        local trigger = self.mMap:GetTrigger(layer, x, y)
        if trigger then
            trigger:OnUse(self.mHero)
        end
    end

end