
ChooserState = {}
ChooserState.__index = ChooserState
function ChooserState:Create(stack, positions, OnChoose, OnCancel)
    local this =
    {
        mStack = stack,
        mPositions = positions,
        mPositionIndex = 1,
        OnChoose = OnChoose or function() end,
        OnCancel = OnCancel or function() end,
        mCursor = Sprite.Create(),
        OnExitCallback = nil
    }

    local cursorTex = Texture.Find("cursor.png")
    this.mCursor:SetTexture(cursorTex)
    this.mHalfCursorWidth = cursorTex:GetWidth()/2

    setmetatable(this, self)
    return this
end

function ChooserState:Enter()
end

function ChooserState:Exit()
    if self.OnExitCallback then
        self.OnExitCallback(self.mPositionIndex)
    end
end

function ChooserState:Update(dt)
    return false
end

function ChooserState:Render(renderer)
    local pos = self.mPositions[self.mPositionIndex]

    -- the cursors right side, should be left aligned to the position
    pos = pos + Vector.Create(-self.mHalfCursorWidth, 0)
    self.mCursor:SetPosition(math.floor(pos:X()), math.floor(pos:Y()))
    renderer:DrawSprite(self.mCursor)
end

function ChooserState:HandleInput()
    if Keyboard.JustReleased(KEY_DOWN) then
        local newIndex = math.min(self.mPositionIndex + 1, #self.mPositions)
        self.mPositionIndex =  newIndex
    elseif Keyboard.JustReleased(KEY_UP) then
        local newIndex = math.max(self.mPositionIndex - 1, 1)
        self.mPositionIndex =  newIndex
    elseif Keyboard.JustReleased(KEY_SPACE) then
        self.OnExitCallback = self.OnChoose
        self.mStack:Pop()
    elseif Keyboard.JustReleased(KEY_BACKSPACE) or
           Keyboard.JustReleased(KEY_ESCAPE) then
       self.OnExitCallback = self.OnCancel
       self.mStack:Pop()
    end
end