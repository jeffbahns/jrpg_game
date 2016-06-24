LoadLibrary('Asset')
Asset.Run('Dependencies.lua')

gRenderer = Renderer.Create()

local mapDef = CreateMap1()
mapDef.on_wake = {}
mapDef.actions = {}
mapDef.trigger_types = {}
mapDef.triggers = {}


local stack = StateStack:Create()
local state = ExploreState:Create(stack, mapDef, Vector.Create(11, 3, 1))
stack:Push(state)

--stack:PushFit(gRenderer, 0,0,"You're trapped in a small room.")


function update()
    local dt = GetDeltaTime()
    stack:Update(dt)
    stack:Render(gRenderer)

    if Keyboard.JustPressed(KEY_F) then
        local fade = FadeState:Create(stack, {start = 1, finish = 0})
        stack:Push(fade)
    end
end