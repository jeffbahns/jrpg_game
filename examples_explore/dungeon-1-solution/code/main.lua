LoadLibrary('Asset')
Asset.Run('Dependencies.lua')

gRenderer = Renderer.Create()
local stack = StateStack:Create()

local intro =
{
   Wait(2),
   Wait(5)
}
local storyboard = Storyboard:Create(stack, intro)
stack:Push(storyboard)

function update()
    local dt = GetDeltaTime()
    stack:Update(dt)
    stack:Render(gRenderer)
end