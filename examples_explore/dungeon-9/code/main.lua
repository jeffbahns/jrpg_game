LoadLibrary('Asset')
Asset.Run('Dependencies.lua')

gRenderer = Renderer.Create()
local stack = StateStack:Create()

local intro =
{
    SOP.Scene
    {
        map = "player_house",
        focusX = 14,
        focusY = 19,
        hideHero = true,
    },
    SOP.BlackScreen(),
    SOP.RunAction("AddNPC",
              {"player_house", { def = "sleeper", id="sleeper", x = 14, y = 19}},
              {GetMapRef}),
    SOP.Play("rain"),
    SOP.NoBlock(
        SOP.FadeSound("rain", 0, 1, 3)
    ),
    SOP.Caption("place", "title", "Village of Sontos"),
    SOP.Caption("time", "subtitle", "MIDNIGHT"),
    SOP.Wait(2),
    SOP.NoBlock(
            SOP.FadeOutCaption("place", 3)
    ),
    SOP.FadeOutCaption("time", 3),

    SOP.KillState("place"),
    SOP.KillState("time"),
    SOP.FadeOutScreen(),
    SOP.Wait(2),
    SOP.FadeInScreen(),
    SOP.RunAction("AddNPC",
         {"player_house", { def = "guard", id = "guard1", x = 16, y = 22}},
         {GetMapRef}),
    SOP.Wait(1),
    SOP.Play("door_break"),
    SOP.NoBlock(SOP.FadeOutScreen()),
    SOP.MoveNPC("guard1", "player_house",
        {
            "up", "up",
            "left", "left", "left",
        }),
    SOP.Wait(1),
    SOP.Say("player_house", "guard1", "Found you!", 2.5),
    SOP.Wait(1),
    SOP.Say("player_house", "guard1", "You're coming with me.", 3),
    SOP.FadeInScreen(),

    -- Kidnap
    SOP.NoBlock(SOP.Play("bell")),
    SOP.Wait(2.5),
    SOP.NoBlock(SOP.Play("bell", "bell2")),
    SOP.FadeSound("bell", 1, 0, 0.2),
    SOP.FadeSound("rain", 1, 0, 1),
    SOP.Play("wagon"),
    SOP.NoBlock(
            SOP.FadeSound("wagon", 0, 1, 2)
    ),
    SOP.Play("wind"),
    SOP.NoBlock(
        SOP.FadeSound("wind", 0, 1, 2)
    ),
    SOP.Wait(3),
    SOP.Caption("time_passes", "title", "Two days later..."),
    SOP.Wait(1),
    SOP.FadeOutCaption("time_passes", 3),
    SOP.KillState("time_passes"),
    SOP.NoBlock(
        SOP.FadeSound("wind", 1, 0, 1)
    ),
    SOP.NoBlock(
        SOP.FadeSound("wagon", 1, 0, 1)
    ),
    SOP.Wait(2),
    SOP.Caption("place", "title", "Unknown Dungeon"),
    SOP.Wait(2),
    SOP.FadeOutCaption("place", 3),
    SOP.KillState("place"),

    SOP.ReplaceScene(
        "player_house",
        {
            map = "jail",
            focusX = 56,
            focusY = 11,
            hideHero = false
        }),
    SOP.FadeOutScreen(),
    SOP.Wait(0.5),
    SOP.Say("jail", "hero", "Where am I?", 3),
    SOP.Wait(1),
    SOP.HandOff("jail")
}
local storyboard = Storyboard:Create(stack, intro)
stack:Push(storyboard)

function update()
    local dt = GetDeltaTime()
    stack:Update(dt)
    stack:Render(gRenderer)
end