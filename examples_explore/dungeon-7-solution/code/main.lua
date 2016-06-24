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
    Wait(2),
    FadeInScreen(),
    RunAction("AddNPC",
        {"player_house", { def = "guard", id = "guard1", x = 16, y = 22}},
        {GetMapRef}),
    Wait(1),
    Play("door_break"),
    NoBlock(FadeOutScreen()),
    MoveNPC("guard1", "player_house",
        {
            "up", "up",
            "left", "left", "left",
        }),
    Wait(1),
    Say("player_house", "guard1", "Found you!", 2.5),
    Wait(1),
    Say("player_house", "guard1", "You're coming with me.", 3),
    FadeInScreen(),

    -- Kidnap
    NoBlock(Play("bell")),
    Wait(2.5),
    NoBlock(Play("bell", "bell2")),
    FadeSound("bell", 1, 0, 0.2),
    FadeSound("rain", 1, 0, 1),
    Play("wagon"),
    NoBlock(
        FadeSound("wagon", 0, 1, 2)
    ),
    Play("wind"),
    NoBlock(
        FadeSound("wind", 0, 1, 2)
    ),
    Wait(3),
    Caption("time_passes", "title", "Two days later..."),
    Wait(1),
    FadeOutCaption("time_passes", 3),
    KillState("time_passes"),
    NoBlock(
        FadeSound("wind", 1, 0, 1)
    ),
    NoBlock(
        FadeSound("wagon", 1, 0, 1)
    ),
    Wait(2),
    Caption("place", "title", "Unknown Dungeon"),
    Wait(2),
    FadeOutCaption("place", 3),
    KillState("place"),

    ReplaceScene(
        "player_house",
        {
            map = "jail",
            focusX = 56,
            focusY = 11,
            hideHero = false
        }),
    FadeOutScreen(),
    Wait(0.5),
    Say("jail", "hero", "Where am I?", 3),
    Wait(1),
    HandOff("jail")
}
local storyboard = Storyboard:Create(stack, intro)
stack:Push(storyboard)

function update()
    local dt = GetDeltaTime()
    stack:Update(dt)
    stack:Render(gRenderer)
end