
-- Display the character information
CharSummary = {}
CharSummary.__index = CharSummary
function CharSummary:Create(char, params)
    params = params or {}

    local this =
    {
        mX = 0,
        mY = 0,
        mWidth = 340, -- width of entire 'box'
        mChar = char,
        mHPBar = ProgressBar:Create
        {
            value = char:GetHP(),
            maximum = char:GetMaxHP(),
            background = Texture.Find("hpbackground.png"),
            foreground = Texture.Find("hpforeground.png"),
        },
        mMPBar = ProgressBar:Create
        {
            value = char:GetMP(),
            maximum = char:GetMaxMP(),
            background = Texture.Find("mpbackground.png"),
            foreground = Texture.Find("mpforeground.png"),
        },
        mAvatarTextPad = 14,
        mLabelRightPad = 15,
        mLabelValuePad = 8,
        mVerticalPad = 18,
        mShowXP = params.showXP
    }

    if this.mShowXP then
        this.mXPBar = ProgressBar:Create
        {
            value = char.mXP,
            maximum = char:NextLevel(),
            background = Texture.Find("xpbackground.png"),
            foreground = Texture.Find("xpforeground.png"),
        }
    end

    setmetatable(this, self)
    this:SetPosition(this.mX, this.mY)
    return this
end

function CharSummary:SetPosition(x, y)
    self.mX = x
    self.mY = y

    if self.mShowXP then
        local boxRight = self.mX + self.mWidth
        local barX = boxRight - self.mXPBar.mHalfWidth
        local barY = self.mY - 44
        self.mXPBar:SetPosition(barX, barY)
    end

    -- HP & MP
    local avatarW = self.mChar:GetAvatarWidth()
    local barX = self.mX + avatarW + self.mAvatarTextPad
    barX = barX + self.mLabelRightPad + self.mLabelValuePad
    barX = barX + self.mMPBar.mHalfWidth

    self.mMPBar:SetPosition(barX, self.mY - 72)
    self.mHPBar:SetPosition(barX, self.mY - 54)
end

function CharSummary:GetCursorPosition()
    return Vector.Create(self.mX, self.mY - 40)
end

function CharSummary:Render(renderer)

    local char = self.mChar

    --
    -- Position avatar image from top left
    --
    local avatar = char.mAvatar
    local avatarW = char:GetAvatarWidth()
    local avatarH = char:GetAvatarHeight()
    local avatarX = self.mX + avatarW / 2
    local avatarY = self.mY - avatarH / 2

    avatar:SetPosition(avatarX, avatarY)
    renderer:DrawSprite(avatar)

    --
    -- Position basic stats to the left of the
    -- avatar
    --
    renderer:AlignText("left", "top")


    local textPadY = 2
    local textX = avatarX + avatarW / 2 + self.mAvatarTextPad
    local textY = self.mY - textPadY
    renderer:ScaleText(1.6, 1.6)
    renderer:DrawText2d(textX, textY, char.mName)

    --
    -- Draw LVL, HP and MP labels
    --
    renderer:AlignText("right", "top")
    renderer:ScaleText(1.22, 1.22)
    textX = textX + self.mLabelRightPad
    textY = textY - 20
    local statsStartY = textY
    --renderer:DrawLine2d(textX, self.mY, textX, self.mY - 100, Vector.Create(1,0,0,1))
    renderer:DrawText2d(textX, textY, "LV")
    textY = textY - self.mVerticalPad
    renderer:DrawText2d(textX, textY, "HP")
    textY = textY - self.mVerticalPad
    renderer:DrawText2d(textX, textY, "MP")
    --
    -- Fill in the values
    --
    local textY = statsStartY
    local textX = textX + self.mLabelValuePad
    renderer:AlignText("left", "top")
    local level = char:GetLevel()
    local hp = char:GetHP()
    local maxHP = char:GetMaxHP()
    local mp = char:GetMP()
    local maxMP = char:GetMP()

    local counter = "%d/%d"
    local hp = string.format(counter,
                             hp,
                             maxHP)
    local mp = string.format(counter,
                             mp,
                             maxMP)

    renderer:DrawText2d(textX, textY, level)
    textY = textY - self.mVerticalPad
    renderer:DrawText2d(textX, textY, hp)
    textY = textY - self.mVerticalPad
    renderer:DrawText2d(textX, textY, mp)

    --
    -- Next Level area
    --
    if self.mShowXP then
        renderer:AlignText("right", "top")
        local boxRight = self.mX + self.mWidth
        local textY = statsStartY
        renderer:DrawText2d(boxRight, textY, "Next Level")
        self.mXPBar:Render(renderer)
    end

    --
    -- MP & HP bars
    --
    self.mHPBar:Render(renderer)
    self.mMPBar:Render(renderer)
end