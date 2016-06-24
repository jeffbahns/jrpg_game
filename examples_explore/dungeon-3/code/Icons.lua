
Icons = {}
Icons.__index = Icons
function Icons:Create(texture)
    local this =
    {
        mTexture = texture,
        mUVs = {},
        mSprites = {},
        mIconDefs =
        {
            useable = 1,
            accessory = 2,
            weapon = 3,
            armor = 4,
            uparrow = 5,
            downarrow = 6
        }
    }
    this.mUVs = GenerateUVs(18, 18, this.mTexture)

    for k, v in pairs(this.mIconDefs) do
        local sprite = Sprite.Create()
        sprite:SetTexture(this.mTexture)
        sprite:SetUVs(unpack(this.mUVs[v]))
        this.mSprites[k] = sprite
    end

    setmetatable(this, self)
    return this
end

function Icons:Get(id)
    return self.mSprites[id]
end

