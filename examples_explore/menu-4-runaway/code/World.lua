
World = {}
World.__index = World
function World:Create()
    local this =
    {
        mTime = 0,
        mGold = 0,
        mEmptyItem =
        {
            name = "",
            description = "",
            powercomment = "",
            stats =
            {
                strength = 0,
                speed = 0,
                intelligence = 0,
                attack = 0,
                defense = 0,
                magic = 0,
                resist = 0
            }
        },
        mPartyMembers =
        {

        },
        mActiveParty =
        {

        },
        -- also including special skills and so on
        mSpellDatabase =
        {
            {name="Fire", description="Fire damage on 1 enemy.", cost=10},
            {name="Overhead Strike", description="A powerful sword strike.", cost=5},
            {name="Fire II", description="Fire damage on 1 enemy.", cost=10},
            {name="Blades", description="Fire damage on 1 enemy.", cost=10},
            {name="Ice Cut", description="Fire damage on 1 enemy.", cost=10},
        },
        mItemDatabase =
        {
            {
                name="Mysterious Torque",
                icon="accessory",
                description = "A golden torque that glitters.",
                powercomment = "Immune to poision.",
                stats =
                {
                    strength = 10,
                    speed = 10
                }
            },
            {
                name="Heal Potion",
                icon="useable",
                description = "Heals a little HP."
            },
            {
                name="Bronze Sword",
                icon="weapon",
                description = "A short sword with dull blade.",
                stats =
                {
                    attack = 10
                }
            },
            {
                name = "Old bone",
                description = "A calcified human femur"
            },
        },
        mItems =
        {
            { id=1, count=1 },
            { id=2, count=12 },
            { id=3, count=1 },
        },
        mKeyItems =
        {
            {id=4}
        }
    }

    -- Add the null item at -1
    this.mItemDatabase[-1] = this.mEmptyItem

    -- Add any missing stats
    for k, v in ipairs(this.mItemDatabase) do
        if v.icon == "weapon" or v.icon == "accessory" or v.icon == "armor" then
            v.powercomment = v.powercomment or ""
            v.stats = v.stats or {}
            local stats = v.stats
            stats.strength = stats.strength or 0
            stats.speed = stats.speed or 0
            stats.intelligence = stats.intelligence or 0
            stats.attack = stats.attack or 0
            stats.defense = stats.defense or 0
            stats.magic = stats.magic or 0
            stats.resist = stats.resist or 0

        end
    end

    setmetatable(this, self)
    return this
end

function World:DrawItem(menu, renderer, x, y, item)
    if not item then
        renderer:AlignText("center", "center")
        renderer:DrawText2d(x + menu.mSpacingX/2, y, " - ")
    else
        local itemDef = gWorld.mItemDatabase[item.id]
        local iconSprite = gIcons.mSprites[itemDef.icon]
        if iconSprite then
            iconSprite:SetPosition(x + 6, y)
            renderer:DrawSprite(iconSprite)
        end
        renderer:AlignText("left", "center")
        renderer:DrawText2d(x + 18, y, itemDef.name)
        local right = x + menu.mSpacingX - 64
        renderer:AlignText("right", "center")
        renderer:DrawText2d(right, y, string.format(":%02d", item.count))
    end
end

function World:AddToInventory(itemId)

    -- 1. Does it already exist?
    for k, v in ipairs(self.mItems) do
        if v.id == itemId then
            -- 2. Yes, it does. Increment and exit.
            v.count = v.count + 1
            return
        end
    end

    -- 3. No it does not exist.
    --    Add it as a new item.
    table.insert(self.mItems,
    {
        id = itemId,
        count = 1
    })
end

function World:RemoveFromInventory(itemId, amount)
    amount = amount or 1
    for i = #self.mItems, 1, -1 do
        local v = self.mItems[i]
        if v.id == itemId then
            v.count = v.count - amount
            assert(v.count >= 0) -- this should never happen
            if v.count == 0 then
                table.remove(self.mItems, i)
                --Apply(self.mItems, print)
                return
            end
        end
    end
end

function World:HasKey(itemId)
    for k, v in ipairs(self.mKeyItems) do
        if v == itemId then
            return true
        end
    end
    return false
end

function World:AddKey(itemId)
    assert(not self:HasKey(itemId))
    table.insert(self.mKeyItems, itemId)
end

function World:RemoveKey(itemId)
    for i = #self.mKeyItems, 1, -1 do
        local v = self.mKeyItems[i]

        if v == itemId then
            table.remove(self.mKeyItems, i)
            return
        end
    end
end



function World:TimeAsString()

    local time = self.mTime
    local hours = math.floor(time / 3600)
    local minutes = math.floor((time % 3600) / 60)
    local seconds = time % 60

    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function World:GoldAsString()
    return string.format("%d", self.mGold)
end

function World:Update(dt)
    self.mTime = self.mTime + dt
end