

PartyMember =
{
    SlotIds = {"weapon", "armor", "acces1", "acces2"},
    BaseStatLabels =
    {
            "STR",
            "SPEED",
            "INT"
    },
    ItemStatLabels =
    {
            "ATTACK",
            "DEFENSE",
            "MAGIC",
            "RESIST"
    },
}


PartyMember.__index = PartyMember
function PartyMember:Create(screen_shot_hack)
    local this =
    {
        mName = "Bob",
        mLevel = 1,
        mHP = 100,
        mMaxHP = 347,
        mMP = 60,
        mMaxMP = 60,
        mXP = 50,
        mAvatarTextureId = string.format("avatar_%d.png", screen_shot_hack),
        mAvatar = Sprite.Create(),
        mMagicTypesStr = {"Spell", "Sword Magic"},
        mMagicTypesId = {"spell", "sword"},
        mSpells =
        {
            ["spell"] =
            {
                1, 3, 4, 5
            },
            ["sword"] =
            {
                2
            }
        },
        mCommands =
        {
            "Attack",
            "Item",
        },
        mEquipSlots =
        {
            "Weapon:",
            "Armor:",
            "Accessory:"
        },
        mEquipment =
        {
            weapon = nil,
            armor = nil,
            acces1 = nil,
            acces2 = nil
        },
        mBaseStats =
        {
            strength = 1,
            speed = 2,
            intelligence = 3,
            attack = 4,
            defense = 5,
            magic = 6,
            resist = 7
        }
    }

    this.mTexture = Texture.Find(this.mAvatarTextureId)
    this.mAvatar:SetTexture(this.mTexture)

    setmetatable(this, self)
    return this
end

function PartyMember:Equip(slot, item)
    print(slot, tostring(item))

    -- 1. Remove item currently in that slot and place it in the inventory
    local prevItem = self.mEquipment[slot]
    self.mEquipment[slot] = nil
    if prevItem then
        gWorld:AddToInventory(prevItem)
    end

    -- 2. If there's a replacement item move it to the slot
    if not item then
        return
    end
    assert(item.count > 0) -- This should never be allowed to happen!
    gWorld:RemoveFromInventory(item.id)
    self.mEquipment[slot] = item.id
end

function PartyMember:RenderSlot(menu, renderer, x, y, slotIndex)

    x = x + 100
    local label = self.mEquipSlots[slotIndex]
    renderer:AlignText("right", "center")
    renderer:DrawText2d(x, y, label)
    renderer:AlignText("left", "center")
    local slotId = PartyMember.SlotIds[slotIndex]

    local text = "none"
    if self.mEquipment[slotId] then
        local itemId = self.mEquipment[slotId]
        local item = gWorld.mItemDatabase[itemId]
        text = item.name
    end
    renderer:DrawText2d(x + 10, y, text)
end

function PartyMember:CalcStats(compare)

    compare = compare or {}
    local weapon = compare.weapon or self.mEquipment.weapon
    local armor = compare.armor or self.mEquipment.armor
    local acces1 = compare.acces1 or self.mEquipment.acces1
    local acces2 = compare.acces2 or self.mEquipment.acces2

    -- Need to look up the weapon and get the stats
    weapon = gWorld.mItemDatabase[weapon] or gWorld.mEmptyItem
    armor = gWorld.mItemDatabase[armor] or gWorld.mEmptyItem
    acces1 = gWorld.mItemDatabase[acces1] or gWorld.mEmptyItem
    acces2 = gWorld.mItemDatabase[acces2] or gWorld.mEmptyItem

    local combinedStats = AddStats(self.mBaseStats, weapon.stats)
    combinedStats = AddStats(combinedStats, armor.stats)
    combinedStats = AddStats(combinedStats, acces1.stats)
    combinedStats = AddStats(combinedStats, acces2.stats)

    return
    {
        combinedStats.strength,
        combinedStats.speed,
        combinedStats.intelligence,
        combinedStats.attack,
        combinedStats.defense,
        combinedStats.magic,
        combinedStats.resist,
    }
end


function PartyMember:GetLevel()
    return self.mLevel
end

function PartyMember:GetHP()
    return self.mHP
end

function PartyMember:GetMaxHP()
    return self.mMaxHP
end

function PartyMember:GetMP()
    return self.mMP
end

function PartyMember:GetMaxMP()
    return self.mMaxMP
end

function PartyMember:NextLevel()
    return 100
end

function PartyMember:GetAvatarWidth()
    return self.mTexture:GetWidth()
end

function PartyMember:GetAvatarHeight()
    return self.mTexture:GetHeight()
end
