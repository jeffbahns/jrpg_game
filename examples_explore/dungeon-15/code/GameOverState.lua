
GameOverState = {}
GameOverState.__index = GameOverState
function GameOverState:Create(stack)
    local this =
    {
        mStack = stack
    }

    setmetatable(this, self)
    return this
end

function GameOverState:Enter() end
function GameOverState:Exit() end
function GameOverState:Update(dt) end
function GameOverState:HandleInput() end

function GameOverState:Render(renderer)
    CaptionStyles["title"]:Render(renderer,
        "Game Over")

    CaptionStyles["subtitle"]:Render(renderer,
        "Want to find out what happens next? Write it!")
end