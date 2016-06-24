LoadLibrary('Asset')
Asset.Run('Dependencies.lua')

gRenderer = Renderer.Create()
local stack = StateStack:Create()

local intro =
{
    BlackScreen(),
    Caption("place", "title", "Village of Sontos"),
    Caption("time", "subtitle", "MIDNIGHT"),
    Wait(2),
    NoBlock(
        FadeOutCaption("place", 3)
    ),
    FadeOutCaption("time", 3),
    KillState("place"),
    KillState("time"),
    FadeOutScreen(),
}
local storyboard = Storyboard:Create(stack, intro)
stack:Push(storyboard)

function update()
    local dt = GetDeltaTime()

    stack:Update(dt)
    stack:Render(gRenderer)
end