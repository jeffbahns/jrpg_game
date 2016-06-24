function Apply(list, f, iter)
    iter = iter or ipairs
    for k, v in iter(list) do
        f(v, k)
    end
end

Apply({
        "Renderer",
        "Sprite",
        "System",
        "Texture",
        "Vector",
        "Keyboard",
        "Sound",
    },
    function(v) LoadLibrary(v) end)

Apply({
        "Animation.lua",
        "Map.lua",
        "Util.lua",
        "Entity.lua",
        "StateMachine.lua",
        "FollowPathState.lua",
        "MoveState.lua",
        "WaitState.lua",
        "SleepState.lua",
        "NPCStandState.lua",
        "PlanStrollState.lua",
        "Tween.lua",
        "Actions.lua",
        "Trigger.lua",
        "EntityDefs.lua",
        "Character.lua",
        "Panel.lua",
        "ProgressBar.lua",
        "Selection.lua",
        "StateStack.lua",
        "Textbox.lua",
        "Scrollbar.lua",
        "ExploreState.lua",
        "Layout.lua",
        "InGameMenuState.lua",
        "FrontMenuState.lua",
        "World.lua",
        "ItemDB.lua",
        "ItemMenuState.lua",
        "Icons.lua",
        "Storyboard.lua",
        "StoryboardEvents.lua",
        "ScreenState.lua",
        "CaptionStyles.lua",
        "CaptionState.lua",
        "map_sontos_house.lua",
        "MapDB.lua",
    },
    function(v) Asset.Run(v) end)