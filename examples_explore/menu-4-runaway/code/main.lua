LoadLibrary('Asset')
Asset.Run('Dependencies.lua')

gRenderer = Renderer.Create()

local mapDef = CreateMap1()
mapDef.on_wake = {}
mapDef.actions = {}
mapDef.trigger_types = {}
mapDef.triggers = {}

gIcons =
{
    mTexture = Texture.Find("inventory_icons.png"),
    mUVs = nil,
    mSprites = {},
    Init = function(self)
        self.mUVs = GenerateUVs(18, 18, self.mTexture)

        -- id -> texture index
        local iconDefs =
        {
            useable = 1,
            accessory = 2,
            weapon = 3,
            armor = 4,
            uparrow = 5,
            downarrow = 6,
        }

        -- Create sprite for each icon
        for k, v in pairs(iconDefs) do
            local sprite = Sprite.Create()
            sprite:SetTexture(self.mTexture)
            sprite:SetUVs(unpack(self.mUVs[v]))
            self.mSprites[k] = sprite
        end
    end
}
gIcons:Init()

-- Party member create should take in a def.
-- I'm passing in a number as a hack to get slightly nicer screen shots for the
-- book
bob0 = PartyMember:Create(0)
bob1 = PartyMember:Create(1)
bob2 = PartyMember:Create(2)

-- cp = CharacterPanel:Create(bob)
-- local posMarker = Vector.Create(-104, 114)
-- cp:SetPosition(posMarker:X(), posMarker:Y())

gWorld = World:Create()
-- Add bob to the party members
table.insert(gWorld.mPartyMembers, bob0)
table.insert(gWorld.mPartyMembers, bob1)
table.insert(gWorld.mPartyMembers, bob2)
-- Reference bob as a member of the active party
table.insert(gWorld.mActiveParty, 1)
table.insert(gWorld.mActiveParty, 2)
table.insert(gWorld.mActiveParty, 3)


local stack = StateStack:Create()
-- 11, 3, 1 == x, y, layer
local state = ExploreState:Create(stack, mapDef, Vector.Create(11, 3, 1))
stack:Push(state)
local ingamemenu = InGameMenuState:Create(stack)
stack:Push(ingamemenu)
stack:PushFit(gRenderer, 0,0,"Pick up kitten?", -1,
{
    choices =
    {
        options = {"Yes", "No"}
    }
})

    testm = Selection:Create
    {
        data =
        {
            "Yes",
            "No",
            "Hellooooo"
        },
        OnSelection = function(...) print(...)  end,
        columns = 1,
        rows = 20,
        displayRows = 2,
        spacingY = 26,
    }

    testm.mScale = 1.3

gRenderer:ScaleText(1, 1)
gRenderer:AlignText("left", "center")

function update()
    local dt = GetDeltaTime()
    stack:Update(dt)
    stack:Render(gRenderer)
    gWorld:Update(dt)
    -- gRenderer:ScaleText(testm.mScale, testm.mScale)
    -- testm:Render(gRenderer)
    -- testm:HandleInput()
    -- local y = 0
    -- gRenderer:DrawLine2d(0,y,testm:GetWidth(), y, Vector.Create(1,0,0,1))
    -- gRenderer:DrawLine2d(0,y,0, y-testm:GetHeight(), Vector.Create(1,0,0,1))
end
