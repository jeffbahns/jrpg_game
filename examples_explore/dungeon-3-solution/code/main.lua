LoadLibrary('Asset')
Asset.Run('Dependencies.lua')

gRenderer = Renderer.Create()
local stack = StateStack:Create()


local stack = StateStack:Create()


local intro =
{
    Scene
    {
        map = "player_house",
        focusX = 14,
        focusY = 20,
        hideHero = true,
    },
    BlackScreen(),
    Play("rain"),
    NoBlock(
        FadeSound("rain", 0, 1, 3)
    ),
    Caption("place", "title", "Village of Sontos"),
    Caption("time", "subtitle", "MIDNIGHT"),
    Wait(2),
    NoBlock(
        FadeOutCaption("place", 3)
    ),
    FadeOutCaption("time", 3),
    FadeSound("rain", 1, 0, 1),
    KillState("place"),
    KillState("time"),
    FadeOutScreen(),
    Wait(2),
    Stop("rain")
}
local storyboard = Storyboard:Create(stack, intro)
stack:Push(storyboard)
function update()
    local dt = GetDeltaTime()
    stack:Update(dt)
    stack:Render(gRenderer)
end