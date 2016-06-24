
InGameMenuState = {}
InGameMenuState.__index = InGameMenuState
function InGameMenuState:Create()
    local this = {}

    setmetatable(this, self)
    return this
end

function InGameMenuState:Enter()
end

function InGameMenuState:Exit()
end

function InGameMenuState:Update(dt)
end

function InGameMenuState:Render(renderer)
end

function InGameMenuState:HandleInput()

end