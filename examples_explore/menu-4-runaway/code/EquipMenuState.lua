
EquipMenuState = {}
EquipMenuState.__index = EquipMenuState
function EquipMenuState:Create(parent)

    local this =
    {
        mParent = parent,
        mStack = parent.mStack,
        mStateMachine = parent.mStateMachine,
        mScrollbar = Scrollbar:Create(Texture.Find("scrollbar.png"), 135),
        mBetterSprite = gIcons.mSprites['uparrow'],
        mWorseSprite = gIcons.mSprites['downarrow'],
        mInList = false
    }
    this.mBetterSprite:SetColor(Vector.Create(0,1,0,1))
    this.mWorseSprite:SetColor(Vector.Create(1,0,0,1))

    setmetatable(this, self)
    return this
end

function EquipMenuState:Enter(character)

    self.mCharacter = character
    self.mCharSummary = CharSummary:Create(character)
    self.mEquipSlots = character.mEquipSlots

    local layout = PanelLayout:Create()
    layout:Contract('screen', 118, 40)
    layout:SplitHorz('screen', "top", "bottom", 0.12, 2)
    layout:SplitVert('top', "title", "category", 0.75, 2)
    local titlePanel = layout.mPanels["title"]

    layout = PanelLayout:Create()
    layout:Contract('screen', 118, 40)
    layout:SplitHorz("screen", "top", "bottom", 0.42, 2)
    layout:SplitHorz("bottom", "desc", "bottom", 0.2, 2)
    layout:SplitVert("bottom", "stats", "list", 0.6, 2)
    layout.mPanels['title'] = titlePanel

    self.mPanels =
    {
        layout:CreatePanel("top"),
        layout:CreatePanel("desc"),
        layout:CreatePanel("stats"),
        layout:CreatePanel("list"),
        layout:CreatePanel("title"),
    }

    self:RefreshFilteredMenus()
    self.mMenuIndex = 1
    self.mFilterMenus[self.mMenuIndex]:HideCursor()

    self.mSlotMenu = Selection:Create
    {
        data = {1, 2, 3},
        OnSelection = function(...) self:OnSelectMenu(...)  end,
        columns = 1,
        rows = 3,
        spacingY = 26,
        RenderItem = function(...) self.mCharacter:RenderSlot(...) end
    }

    self.mLayout = layout
end

function EquipMenuState:RefreshFilteredMenus()
    local WEAPONS = 1
    local ARMOUR = 2
    local ACCESSORY = 3
    local filters =
    {
        [WEAPONS] = {},
        [ARMOUR] = {},
        [ACCESSORY] = {}
    }

    for k, v in ipairs(gWorld.mItems) do
        local item = gWorld.mItemDatabase[v.id]
        if item.icon == "weapon" then
            table.insert(filters[WEAPONS], v)
        elseif item.icon == "accessory" then
            table.insert(filters[ACCESSORY], v)
        elseif item.icon == "armor" then
            table.insert(filters[ARMOUR], v)
        end
    end

    self.mFilterMenus = {}
    for k, v in ipairs(filters) do
        local menu = Selection:Create
        {
            data = v,
            columns = 1,
            spacingX = 256,
            displayRows = 5,
            spacingY = 26,
            rows = 20,
            RenderItem = function(self, renderer, x, y, item)
                gWorld:DrawItem(self, renderer, x, y, item)
            end,
            OnSelection = function(...) self:OnDoEquip(...) end
        }
        table.insert(self.mFilterMenus, menu)
    end
end

function EquipMenuState:OnSelectMenu(index, item)
    self.mInList = true
    self.mSlotMenu:HideCursor()
    self.mMenuIndex = self.mSlotMenu:GetIndex()
    self.mFilterMenus[self.mMenuIndex]:ShowCursor()
end

function EquipMenuState:OnDoEquip(index, item)
    -- Let the character handle this.
    self.mCharacter:Equip(self:GetSelectedSlot(), item)
    self:RefreshFilteredMenus()
    self:FocusSlotMenu()
end

function EquipMenuState:Exit()
end

function EquipMenuState:OnEquipMenuChanged()
    self.mMenuIndex = self.mSlotMenu:GetIndex()

    -- Equip menu only changes, when list isn't in focus
    self.mFilterMenus[self.mMenuIndex]:HideCursor()
end

function EquipMenuState:FocusSlotMenu()
    self.mInList = false
    self.mSlotMenu:ShowCursor()
    self.mMenuIndex = self.mSlotMenu:GetIndex()
    self.mFilterMenus[self.mMenuIndex]:HideCursor()
end

function EquipMenuState:Update(dt)

    local menu = self.mFilterMenus[self.mMenuIndex]

    if self.mInList then
        menu:HandleInput()
        if  Keyboard.JustReleased(KEY_BACKSPACE) or
            Keyboard.JustReleased(KEY_ESCAPE) then
            self:FocusSlotMenu()
        end
    else
        local prevEquipIndex = self.mSlotMenu:GetIndex()
        self.mSlotMenu:HandleInput()
        if prevEquipIndex ~= self.mSlotMenu:GetIndex() then
            self:OnEquipMenuChanged()
        end
        if  Keyboard.JustReleased(KEY_BACKSPACE) or
            Keyboard.JustReleased(KEY_ESCAPE) then
            self.mStateMachine:Change("frontmenu")
        end
    end

    local scrolled = menu:PercentageScrolled()
    self.mScrollbar:SetNormalValue(scrolled)
end

function EquipMenuState:GetSelectedSlot()
    local i = self.mSlotMenu:GetIndex()
    return PartyMember.SlotIds[i]
end

function EquipMenuState:GetSelectedItem()

    if self.mInList then
        local menu = self.mFilterMenus[self.mMenuIndex]
        local item = menu:SelectedItem() or {id=nil}
        return item.id
    else
        local slot = self:GetSelectedSlot()
        return self.mCharacter.mEquipment[slot]
    end
end


function EquipMenuState:DrawStat(renderer, x, y, label, statsA, statsB)
    renderer:AlignText("right", "center")
    renderer:DrawText2d(x, y, label)
    renderer:AlignText("left", "center")
    renderer:DrawText2d(x + 15, y, string.format("%d", statsA))

    local statDiff =  statsB - statsA

    if statDiff > 0 then
        renderer:DrawText2d(x + 60, y, string.format("%d", statsB),
                            Vector.Create(0,1,0,1))
        self.mBetterSprite:SetPosition(x + 80, y)
        renderer:DrawSprite(self.mBetterSprite)
    elseif statDiff < 0 then
        renderer:DrawText2d(x + 60, y, string.format("%d", statsB),
                            Vector.Create(1,0,0,1))
        self.mWorseSprite:SetPosition(x + 80, y)
        renderer:DrawSprite(self.mWorseSprite)
    end

end

function EquipMenuState:Render(renderer)
    for k,v in ipairs(self.mPanels) do
        v:Render(renderer)
    end

    -- Title
    renderer:ScaleText(1.5, 1.5)
    renderer:AlignText("center", "center")
    local titleX = self.mLayout:MidX("title")
    local titleY = self.mLayout:MidY("title")
    renderer:DrawText2d(titleX, titleY, "Equip")

    -- Char summary
    local titleHeight = self.mLayout.mPanels["title"].height
    local avatarX = self.mLayout:Left("top")
    local avatarY = self.mLayout:Top("top")
    avatarX = avatarX + 10
    avatarY = avatarY - titleHeight - 10
    self.mCharSummary:SetPosition(avatarX, avatarY)
    self.mCharSummary:Render(renderer)

    -- Slots selection
    local equipX = self.mLayout:MidX("top") - 5
    local equipY = self.mLayout:Top("top") - titleHeight - 10
    self.mSlotMenu:SetPosition(equipX, equipY)
    renderer:ScaleText(1.25,1.25)
    self.mSlotMenu:Render(renderer)

    -- Char stat panel
    local stats = self.mCharacter:CalcStats()
    local selectedItem = self:GetSelectedItem() or -1
    local selectedSlot = self:GetSelectedSlot()
    local compareStats = self.mCharacter:CalcStats
    {
        [selectedSlot] = selectedItem
    }
    local x = self.mLayout:MidX("stats") - 10
    local y = self.mLayout:Top("stats") - 18
    renderer:ScaleText(1,1)

    for k, v in ipairs(PartyMember.BaseStatLabels) do
        self:DrawStat(renderer, x, y, v, stats[k], compareStats[k])
        y = y - 16
    end
    y = y - 16
    for k, v in ipairs(PartyMember.ItemStatLabels) do
        local index = #PartyMember.ItemStatLabels + k - 1
        self:DrawStat(renderer, x, y, v, stats[index], compareStats[index])
        y = y - 16
    end

    -- Description panel
    local descX = self.mLayout:Left("desc") + 10
    local descY = self.mLayout:MidY("desc")
    renderer:ScaleText(1, 1)
    local item = gWorld.mItemDatabase[selectedItem]
    renderer:DrawText2d(descX, descY, item.powercomment)

    -- Inventory list
    local listX = self.mLayout:Left("list") + 6
    local listY = self.mLayout:Top("list") - 20
    local menu = self.mFilterMenus[self.mMenuIndex]
    menu:SetPosition(listX, listY)
    menu:Render(renderer)

    -- Scroll bar
    local scrollX = self.mLayout:Right("list") - 14
    local scrollY = self.mLayout:MidY("list")
    self.mScrollbar:SetPosition(scrollX, scrollY)
    self.mScrollbar:Render(renderer)
end