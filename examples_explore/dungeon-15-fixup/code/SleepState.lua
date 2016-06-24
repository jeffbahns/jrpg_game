SleepState = {mName = "sleep"}
SleepState.__index = SleepState
function SleepState:Create(character, map)
    local this =
    {
        mCharacter = character,
        mMap = map,
        mEntity = character.mEntity,
        mController = character.mController,
        mAnim = Animation:Create({1,2,3,4}, true, 0.6),
    }

    this.mSleepEntity = Entity:Create(gEntities.sleep),
    -- set to default facing
    this.mEntity:SetFrame(character.mAnims[character.mFacing][1])

    setmetatable(this, self)
    return this
end

function SleepState:Enter(data)
    self.mEntity:AddChild("snore", self.mSleepEntity)
end

function SleepState:Render(renderer) end

function SleepState:Exit()
    self.mEntity:RemoveChild("snore")
end

function SleepState:Update(dt)
    self.mAnim:Update(dt)
    self.mSleepEntity:SetFrame(self.mAnim:Frame())
end