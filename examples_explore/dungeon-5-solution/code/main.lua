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
              {"player_house", { def = "sleeper", id="sleeper", x = 14, y = 19}},
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

    KillState("place"),
    KillState("time"),
    FadeOutScreen(),
    Wait(3),
    FadeInScreen(),
    RunAction("AddNPC",
        {"player_house", { def = "guard", id = "guard1", x = 19, y = 22}},
        {GetMapRef}),
    NoBlock(FadeOutScreen()),
    MoveNPC("guard1", "player_house",
        {
            "up", "up", "up",
            "left", "left", "left",
        }),
    Wait(0.3),
    Say("player_house", "guard1", "Take Him!"),
    FadeInScreen(),
    FadeSound("rain", 1, 0, 1),
    Stop("rain")
}
local storyboard = Storyboard:Create(stack, intro)
stack:Push(storyboard)

function update()
    local dt = GetDeltaTime()
    stack:Update(dt)
    stack:Render(gRenderer)
end