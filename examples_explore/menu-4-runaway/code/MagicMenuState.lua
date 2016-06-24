
MagicMenuState = {}
MagicMenuState.__index = MagicMenuState
function MagicMenuState:Create(parent)

    local this =
    {
        mParent = parent,
        mStack = parent.mStack,
        mStateMachine = parent.mStateMachine,
        mScrollbar = Scrollbar:Create(Texture.Find("scrollbar.png"), 184),
        mInCategoryMenu = false
    }
    setmetatable(this, self)
    return this
end

function MagicMenuState:Enter(character)

    -- Magic shown depends on the character.
    self.mCharacter = character

    local layout = PanelLayout:Create()
    layout:Contract('screen', 118, 40)
    layout:SplitHorz('screen', "top", "bottom", 0.12, 2)
    layout:SplitVert('top', "title", "category", 0.7, 2)
    layout:SplitHorz('bottom', "detail", "spells", 0.3, 2)
    layout:SplitHorz('detail', "detail", "desc", 0.5, 2)
    layout:SplitVert('detail', "char", "cost", 0.5, 2)

    self.mPanels =
    {
        layout:CreatePanel("title"),
        layout:CreatePanel("category"),
        layout:CreatePanel("char"),
        layout:CreatePanel("desc"),
        layout:CreatePanel("spells"),
        layout:CreatePanel("cost"),
    }

    self.mCategoryMenu = Selection:Create
    {
        data = character.mMagicTypesStr,
        OnSelection = function(...) self:OnCategorySelect(...) end,
        spacingX = 150,
        columns = 2,
        rows = 1,
    }
    self.mCategoryMenu:HideCursor()

    self.mSpellMenus = {}
    for k, v in pairs(character.mMagicTypesId) do
        -- Create a menu for each spell
        local menu = Selection:Create
        {
            data = character.mSpells[v],
            OnSelection = function() end,
            spacingX = 256,
            displayRows = 6,
            spacingY = 28,
            columns = 2,
            rows = 20,
            RenderItem = function(...) self:RenderSpell(...) end
        }
        if k > 1 then
            menu:HideCursor()
        end
        table.insert(self.mSpellMenus, menu)
    end

    self.mLayout = layout
end

function MagicMenuState:Exit()
end

function MagicMenuState:RenderSpell(menu, renderer, x, y, item)

    if item == nil then
       renderer:DrawText2d(x,y, "--")
    else
        local spell = gWorld.mSpellDatabase[item]
        renderer:DrawText2d(x,y, spell.name)
    end
end

function MagicMenuState:OnCategorySelect(index, name)
    self.mCategoryMenu:HideCursor()
    self.mInCategoryMenu = false
    local menu = self.mSpellMenus[self.mCategoryMenu:GetIndex()]
    self.mScrollbar:SetScrollCaretScale(menu:PercentageShown())
    menu:ShowCursor()
end

function MagicMenuState:FocusOnCategoryMenu()
    local menu = self.mSpellMenus[self.mCategoryMenu:GetIndex()]
    menu:HideCursor()
    self.mInCategoryMenu = true
    self.mCategoryMenu:ShowCursor()
end

function MagicMenuState:Update(dt)

    local menu = self.mSpellMenus[self.mCategoryMenu:GetIndex()]

    if self.mInCategoryMenu then

        self.mCategoryMenu:HandleInput()

        if  Keyboard.JustReleased(KEY_BACKSPACE) or
            Keyboard.JustReleased(KEY_ESCAPE) then
            self.mStateMachine:Change("frontmenu")
        end
    else

        menu:HandleInput()

        if  Keyboard.JustReleased(KEY_BACKSPACE) or
            Keyboard.JustReleased(KEY_ESCAPE) then
            self:FocusOnCategoryMenu()
        end
    end

    local scrolled = menu:PercentageScrolled()
    self.mScrollbar:SetScrollCaretScale(menu:PercentageShown())
    self.mScrollbar:SetNormalValue(scrolled)
end

function MagicMenuState:GetSelectedManaCost()
    local spellMenu = self.mSpellMenus[self.mCategoryMenu:GetIndex()]
    local item = spellMenu:SelectedItem()

    if item then
        local spell = gWorld.mSpellDatabase[item]
        return spell.cost
    end

    return 0
end

function MagicMenuState:GetSelectedDescription()
    local spellMenu = self.mSpellMenus[self.mCategoryMenu:GetIndex()]
    local item = spellMenu:SelectedItem()

    if item then
        local spell = gWorld.mSpellDatabase[item]
        return spell.description
    end

    return ""
end

function MagicMenuState:Render(renderer)

    for k,v in ipairs(self.mPanels) do
        v:Render(renderer)
    end

    renderer:ScaleText(1.5, 1.5)
    renderer:AlignText("center", "center")
    local titleX = self.mLayout:MidX("title")
    local titleY = self.mLayout:MidY("title")
    renderer:DrawText2d(titleX, titleY, "Magic")

    renderer:AlignText("left", "center")
    local categoryX = self.mLayout:Left("category") + 10
    local categoryY = self.mLayout:MidY("category")
    self.mCategoryMenu:SetPosition(categoryX, categoryY)
    self.mCategoryMenu:Render(renderer)

    local charX = self.mLayout:MidX("char")
    local charY = self.mLayout:MidY("char")
    renderer:DrawText2d(charX, charY, self.mCharacter.mName)

    local manaCostLabel = "Mana Cost:"
    renderer:AlignText("right", "center")
    local charX =  self.mLayout:MidX("cost") - 5
    local charY =  self.mLayout:MidY("char")
    renderer:DrawText2d(charX, charY, manaCostLabel)

    if not self.mInCategoryMenu then
        local manaCostStr = "%03d"
        local manaCost = self:GetSelectedManaCost()
        manaCostStr = string.format(manaCostStr, manaCost)
        renderer:AlignText("left", "center")
        renderer:DrawText2d(charX + 10, charY, manaCostStr)
    end

    renderer:AlignText("left", "center")
    renderer:ScaleText(1,1)
    local descX = self.mLayout:Left("desc")
    local descY = self.mLayout:MidY("desc")
    local desc = self:GetSelectedDescription()
    renderer:DrawText2d(descX + 10, descY, desc)

    renderer:AlignText("left", "center")
    local spellX = self.mLayout:Left("spells") + 6
    local spellY = self.mLayout:Top("spells") - 30
    local menu = self.mSpellMenus[self.mCategoryMenu:GetIndex()]
    menu:SetPosition(spellX, spellY)
    menu:Render(renderer)

    local scrollX = self.mLayout:Right("spells") - 14
    local scrollY = self.mLayout:MidY("spells")
    self.mScrollbar:SetPosition(scrollX, scrollY)
    self.mScrollbar:Render(renderer)
end
