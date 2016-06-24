
StatusMenuState = {}
StatusMenuState.__index = StatusMenuState
function StatusMenuState:Create(parent, world)

    local layout = PanelLayout:Create()
    layout:Contract('screen', 118, 40)
    layout:SplitHorz('screen', "title", "bottom", 0.12, 2)

    local this =
    {
        mParent = parent,
        mStateMachine = parent.mStateMachine,
        mStack = parent.mStack,

        mLayout = layout,
        mPanels =
        {
            layout:CreatePanel("title"),
            layout:CreatePanel("bottom"),
        },

    }

    setmetatable(this, self)
    return this
end

function StatusMenuState:Enter(character)
    self.mCharacter = character
    self.mCharSummary = CharSummary:Create(character, { showXP = true})

    self.mSlotMenu = Selection:Create
    {
        data = {1, 2, 3},
        columns = 1,
        rows = 3,
        spacingY = 26,
        RenderItem = function(...) self.mCharacter:RenderSlot(...) end
    }
    self.mSlotMenu:HideCursor()

    self.mCommands = Selection:Create
    {
        data = self.mCharacter.mCommands,
        columns = 1,
        rows = #self.mCharacter.mCommands,
        spacingY = 18
    }
    self.mCommands:HideCursor()

end

function StatusMenuState:Exit()
end

function StatusMenuState:Update(dt)
    if  Keyboard.JustReleased(KEY_BACKSPACE) or
        Keyboard.JustReleased(KEY_ESCAPE) then
        self.mStateMachine:Change("frontmenu")
    end
end

function StatusMenuState:DrawStat(renderer, x, y, label, value)
    renderer:AlignText("right", "center")
    renderer:DrawText2d(x -5, y, label)
    renderer:AlignText("left", "center")
    renderer:DrawText2d(x + 5, y, tostring(value))
end

function StatusMenuState:Render(renderer)
    for k,v in ipairs(self.mPanels) do
        v:Render(renderer)
    end

    local titleX = self.mLayout:MidX("title")
    local titleY = self.mLayout:MidY("title")
    renderer:ScaleText(1.5, 1.5)
    renderer:AlignText("center", "center")
    renderer:DrawText2d(titleX, titleY, "Status")

    local left = self.mLayout:Left("bottom") + 10
    local top = self.mLayout:Top("bottom") - 10
    self.mCharSummary:SetPosition(left , top)
    self.mCharSummary:Render(renderer)

    renderer:AlignText("left", "top")
    local xpStr = string.format("XP: %d/%d",
                                self.mCharacter.mXP,
                                 self.mCharacter:NextLevel())
    renderer:DrawText2d(left + 240, top - 58, xpStr)

    self.mSlotMenu:SetPosition(-10, -64)
    self.mSlotMenu:Render(renderer)

    local stats = self.mCharacter:CalcStats()

    local x = left + 84
    local y = 0
    for k, v in ipairs(PartyMember.BaseStatLabels) do
        self:DrawStat(renderer, x, y, v, stats[k])
        y = y - 16
    end
    y = y - 16
    for k, v in ipairs(PartyMember.ItemStatLabels) do
        local index = #PartyMember.ItemStatLabels + k - 1
        self:DrawStat(renderer, x, y, v, stats[index])
        y = y - 16
    end

    renderer:AlignText("left", "top")
    local x = 75
    local y = 25
    local w = 100
    local h = 56
    -- this should be a panel - duh!
    local box = Textbox:Create
    {
        text = {""},
        textScale = 1.5,
        size =
        {
            left = x,
            right = x + w,
            top = y,
            bottom = y - h,
        },
        textbounds =
        {
            left = 10,
            right = -10,
            top = -10,
            bottom = 10
        },
        panelArgs =
        {
            texture = Texture.Find("gradient_panel.png"),
            size = 3,
        },
    }
    box.mAppearTween = Tween:Create(1,1,0)
    box:Render(renderer)
    self.mCommands:SetPosition(x - 14, y - 10)
    self.mCommands:Render(renderer)
end
