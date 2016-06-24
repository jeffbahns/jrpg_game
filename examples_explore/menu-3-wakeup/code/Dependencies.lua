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
    },
    function(v) LoadLibrary(v) end)

Apply({
        "Animation.lua",
        "Map.lua",
        "Util.lua",
        "Entity.lua",
        "StateMachine.lua",
        "MoveState.lua",
        "WaitState.lua",
        "NPCStandState.lua",
        "PlanStrollState.lua",
        "Tween.lua",
        "Actions.lua",
        "Trigger.lua",
        "EntityDefs.lua",
        "Character.lua",
        "small_room.lua",
        "Panel.lua",
        "ProgressBar.lua",
        "Selection.lua",
        "StateStack.lua",
        "Textbox.lua",
        "ExploreState.lua",
        "FadeState.lua"
    },
    function(v) Asset.Run(v) end)