WaitState = { mName = "wait" }
WaitState.__index = WaitState
function WaitState:Create(character, map)
    local this =
    {
        mCharacter = character,
        mMap = map,
        mEntity = character.mEntity,
        mController = character.mController
    }

    setmetatable(this, self)
    return this
end

function WaitState:Enter(data)
    -- Reset to default frame
    self.mEntity:SetFrame(self.mEntity.mStartFrame)
end

function WaitState:Render(renderer) end
function WaitState:Exit() end

function WaitState:Update(dt)
    if Keyboard.Held(KEY_LEFT) then
        self.mController:Change("move", {x = -1, y = 0})
    elseif Keyboard.Held(KEY_RIGHT) then
        self.mController:Change("move", {x = 1, y = 0})
    elseif Keyboard.Held(KEY_UP) then
        self.mController:Change("move", {x = 0, y = -1})
    elseif Keyboard.Held(KEY_DOWN) then
        self.mController:Change("move", {x = 0, y = 1})
    end
end


