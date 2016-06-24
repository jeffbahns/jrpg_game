MoveState = { mName = "move" }
MoveState.__index = MoveState
function MoveState:Create(character, map)
    local this =
    {
        mCharacter = character,
        mMap = map,
        mTileWidth = map.mTileWidth,
        mEntity = character.mEntity,
        mController = character.mController,
        mMoveX = 0,
        mMoveY = 0,
        mTween = Tween:Create(0, 0, 1),
        mMoveSpeed = 0.3,

        mAnimSpeed = 0.09,
        mAnimIndex = 1,
        mAnimTime = 0,
    }
    this.mAnimSet = { this.mEntity.mStartFrame }

    setmetatable(this, self)
    return this
end

function MoveState:Enter(data)

    if data.x == -1 then
        self.mAnimSet = self.mCharacter.mAnims.right
        self.mCharacter.mFacing = "right"
    elseif data.x == 1 then
        self.mAnimSet = self.mCharacter.mAnims.left
        self.mCharacter.mFacing = "left"
    elseif data.y == -1 then
        self.mAnimSet = self.mCharacter.mAnims.up
        self.mCharacter.mFacing = "up"
    elseif data.y == 1 then
        self.mAnimSet = self.mCharacter.mAnims.down
        self.mCharacter.mFacing = "down"
    end

    self.mMoveX = data.x
    self.mMoveY = data.y
    local pixelPos = self.mEntity.mSprite:GetPosition()
    self.mPixelX = pixelPos:X()
    self.mPixelY = pixelPos:Y()
    self.mTween = Tween:Create(0, self.mTileWidth, self.mMoveSpeed)

    local targetX = self.mEntity.mTileX + data.x
    local targetY = self.mEntity.mTileY + data.y
    if self.mMap:IsBlocked(1, targetX, targetY) then
        self.mMoveX = 0
        self.mMoveY = 0
        self.mEntity:SetFrame(self.mAnimSet[self.mAnimIndex])
        self.mController:Change(self.mCharacter.mDefaultState)
        return
    end

    if self.mMoveX ~= 0 or self.mMoveY ~= 0 then
        local trigger = self.mMap:GetTrigger(self.mEntity.mLayer,
                                            self.mEntity.mTileX,
                                            self.mEntity.mTileY)
        if trigger then
            trigger:OnExit(self.mEntity)
        end
    end

    self.mEntity:SetTilePos(self.mEntity.mTileX + self.mMoveX,
                            self.mEntity.mTileY + self.mMoveY,
                            self.mEntity.mLayer,
                            self.mMap)
    self.mEntity.mSprite:SetPosition(pixelPos)
end


function MoveState:Exit()

    local trigger = self.mMap:GetTrigger(self.mEntity.mLayer,
                                         self.mEntity.mTileX,
                                         self.mEntity.mTileY)
    if trigger then
        trigger:OnEnter(self.mEntity)
    end

end

function MoveState:Render(renderer) end

function MoveState:Update(dt)

    self.mAnimTime = self.mAnimTime + dt
    if self.mAnimTime >= self.mAnimSpeed then
        self.mAnimIndex = self.mAnimIndex + 1
        self.mAnimTime = 0
        if self.mAnimIndex > #self.mAnimSet then
            self.mAnimIndex = 1
        end
        self.mEntity:SetFrame(self.mAnimSet[self.mAnimIndex])
    end

    self.mTween:Update(dt)

    local value = self.mTween:Value()
    local x = self.mPixelX + (value * self.mMoveX)
    local y = self.mPixelY - (value * self.mMoveY)
    self.mEntity.mSprite:SetPosition(math.floor(x), math.floor(y))

    if self.mTween:IsFinished() then
        self.mController:Change(self.mCharacter.mDefaultState)
    end
end

