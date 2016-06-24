
-- WaitState, MoveState must already be loaded.
assert(WaitState)
assert(MoveState)
assert(SleepState)

gCharacterStates =
{
    wait = WaitState,
    move = MoveState,
    npc_stand = NPCStandState,
    plan_stroll = PlanStrollState,
    sleep = SleepState,
    follow_path = FollowPathState
}

gEntities =
{
    hero =
    {
        texture = "walk_cycle.png",
        width = 16,
        height = 24,
        startFrame = 9,
        tileX = 11,
        tileY = 3,
        layer = 1
    },
    guard =
    {
        texture = "walk_cycle.png",
        width = 16,
        height = 24,
        startFrame = 89,
        tileX = 1,
        tileY = 1,
        layer = 1
    },
    sleep =
    {
        texture = "sleeping.png",
        width = 32,
        height = 32,
        startFrame = 3,
        x = 18,
        y = 32
    },
    prisoner =
    {
        texture = "walk_cycle.png",
        width = 16,
        height = 24,
        startFrame = 58,
        tileX = 1,
        tileY = 1,
        layer = 1
    },
}

gCharacters =
{
    guard =
    {
        entity = "guard",
        anims =
        {
            up =    {81, 82, 83, 84},
            right = {85, 86, 87, 88},
            down =  {89, 90, 91, 92},
            left =  {93, 94, 95, 96},
        },
        facing = "up",
        controller = {"npc_stand", "follow_path", "move"},
        state = "npc_stand"
    },
    prisoner =
    {
        entity = "prisoner",
        anims =
        {
            up =    {49, 50, 51, 52},
            right = {53, 54, 55, 56},
            down =  {57, 58, 59, 60},
            left =  {61, 62, 63, 64},
        },
        facing = "down",
        controller = {"npc_stand", "follow_path", "move"},
        state = "npc_stand"
    },
    hero =
    {
        entity = "hero",
        anims =
        {
            up = {1, 2, 3, 4},
            right = {5, 6, 7, 8},
            down = {9, 10, 11, 12},
            left = {13, 14, 15, 16},
        },
        facing = "down",
        controller = { "wait", "move" },
        state = "wait"
    },
    -- New
    sleeper =
    {
        entity = "hero",
        anims =
        {
            left = {13},
        },
        facing = "left",
        controller  = {"sleep"},
        state = "sleep"
    }
}