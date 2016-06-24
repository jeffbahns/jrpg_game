
Selection = {}
Selection.__index = Selection
function Selection:Create(renderer, params)

    params = params or {}

    local this =
    {
        mX = params.x or 0,
        mY = params.y or 0,
        mOptions = params.options,
        mIndent = params.indent or 40,
        mSpacing = params.spacing or 10,
        mFocus = 1,
        mTextScale = params.textScale or 1,
        mScale = params.scale or 1,
        mCursor = Sprite.Create(),
        OnSelection = params.OnSelection or function() end
    }
    -- We should have some options!
    assert(next(this.mOptions))

    local cursorTex = Texture.Find(params.cursor or "cursor.png")
    this.mCursor:SetTexture(cursorTex)
    this.mHalfCursorWidth = cursorTex:GetWidth()/2

    renderer:ScaleText(self.mTextScale, self.mTextScale)
    this.mFaceHeight = renderer:MeasureText(this.mOptions[1]):Y()

    setmetatable(this, self)
    this.mWidth = this:CalcWidth(renderer)
    this.mHeight = this:CalcHeight()
    return this
end

function Selection:CalcWidth(renderer)
    renderer:ScaleText(self.mTextScale, self.mTextScale)
    local maxWidth = 0
    for k, v in ipairs(self.mOptions) do
        maxWidth = math.max(maxWidth, renderer:MeasureText(v):X())
    end
    return self.mIndent + maxWidth
end

function Selection:CalcHeight()
    local height =  #self.mOptions * (self.mFaceHeight + self.mSpacing)
    -- There's no spacing after the last element so subtract one.
    return height - self.mSpacing
end

function Selection:GetWidth()
    return self.mWidth * self.mScale
end

function Selection:GetHeight()
    return self.mHeight * self.mScale
end

function Selection:OnClick()
    self.OnSelection(self.mFocus)
end

function Selection:OnUp()
   self.mFocus = math.max(1, self.mFocus - 1)
end

function Selection:OnDown()
    self.mFocus = math.min(#self.mOptions, self.mFocus + 1)
end

function Selection:Render(renderer)

    local textScale = self.mTextScale * self.mScale
    local faceHeight = self.mFaceHeight * self.mScale
    local spacing = self.mSpacing * self.mScale
    local halfCursorWidth = self.mHalfCursorWidth * self.mScale
    local indent = self.mIndent * self.mScale

    renderer:ScaleText(textScale, textScale)
    renderer:AlignText("left", "top")

    local cursorX = self.mX + halfCursorWidth

    for k, v in ipairs(self.mOptions) do

        local x = self.mX + indent
        local y = self.mY - (k - 1) * (faceHeight + spacing)

        if k == self.mFocus then
            local cursorY = y - faceHeight / 2
            self.mCursor:SetScale(self.mScale, self.mScale)
            self.mCursor:SetPosition(cursorX, cursorY)
            gRenderer:DrawSprite(self.mCursor)
        end


        renderer:DrawText2d(x, y, v)
    end
end