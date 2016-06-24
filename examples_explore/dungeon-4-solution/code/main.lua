LoadLibrary('Asset')
Asset.Run('Dependencies.lua')

gRenderer = Renderer.Create()
local stack = StateStack:Create()


local intro =
{
    Scene
    {
        map = "player_house",
        focusX = 14,
        focusY = 19,
        hideHero = true,
    },
    BlackScreen(),
    RunAction("AddNPC",
              {"player_house", { def = "sleeper", x = 14, y = 19}},
              {GetMapRef}),
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
    FadeInScreen(),
    Wait(0.3),
    FadeOutScreen(),
    Stop("rain")
}
local storyboard = Storyboard:Create(stack, intro)
stack:Push(storyboard)
function update()
    local dt = GetDeltaTime()
    stack:Update(dt)
    stack:Render(gRenderer)
end