
Textbox = {}
Textbox.__index = Textbox
function Textbox:Create(params)

    params = params or {}

    local this =
    {
        mText = params.text,
        mTextScale = params.textScale or 1,
        mPanel = Panel:Create(params.panelArgs),
        mSize = params.size,
        mBounds = params.textbounds,
        mAppearTween = Tween:Create(0, 1, 0.4, Tween.EaseOutCirc),
        mWrap = params.wrap or -1
    }

    -- Calculate center point from mSize
    -- We can use this to scale.
    this.mX = (this.mSize.right + this.mSize.left) / 2
    this.mY = (this.mSize.top + this.mSize.bottom) / 2
    this.mWidth = this.mSize.right - this.mSize.left
    this.mHeight = this.mSize.top - this.mSize.bottom

    setmetatable(this, self)
    return this
end

function Textbox:Update(dt)
    self.mAppearTween:Update(dt)
end

function Textbox:OnClick()
    print("In OnClick")
    --
    -- If the dialog is appearing or dissapearing
    -- ignore interaction
    --
    if not (self.mAppearTween:IsFinished()
       and self.mAppearTween:Value() == 1) then
        return
    end
    self.mAppearTween = Tween:Create(1, 0, 0.2, Tween.EaseInCirc)
end

function Textbox:IsDead()
    return self.mAppearTween:IsFinished()
            and self.mAppearTween:Value() == 0
end

function Textbox:Render(renderer)
    local scale = self.mAppearTween:Value()

    renderer:ScaleText(self.mTextScale * scale)
    renderer:AlignText("left", "top")
    -- Draw the scale panel
    self.mPanel:CenterPosition(
        self.mX,
        self.mY,
        self.mWidth * scale,
        self.mHeight * scale)

    self.mPanel:Render(renderer)

    local left = self.mX - (self.mWidth/2 * scale)
    local textLeft = left + (self.mBounds.left * scale)
    local top = self.mY + (self.mHeight/2 * scale)
    local textTop = top + (self.mBounds.top * scale)

    renderer:DrawText2d(
        textLeft,
        textTop,
        self.mText,
        Vector.Create(1,1,1,1),
        self.mWrap * scale)
end
