SleepState = {mName = "sleep"}
SleepState.__index = SleepState
function SleepState:Create(character, map)
    local this =
    {
        mCharacter = character,
        mMap = map,
        mEntity = character.mEntity,
        mController = character.mController,


        mAnimTime = 0,
        mAnimSpeed = 0.6,
        mAnimSet = {1, 2, 3, 4},
        mAnimIndex = 1,
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

function SleepState:Render(renderer)

end

function SleepState:Exit()
    self.mEntity:RemoveChild("snore")
end

function SleepState:Update(dt)
    self.mAnimTime = self.mAnimTime + dt
    if self.mAnimTime >= self.mAnimSpeed then
        self.mAnimIndex = self.mAnimIndex + 1
        self.mAnimTime = 0
        if self.mAnimIndex > #self.mAnimSet then
            self.mAnimIndex = 1
        end
        self.mSleepEntity:SetFrame(self.mAnimSet[self.mAnimIndex])
    end
end
