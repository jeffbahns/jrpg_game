LoadLibrary('Asset')
Asset.Run('Dependencies.lua')

gRenderer = Renderer.Create()


local mapDef = CreateMap1()
mapDef.on_wake = {}
mapDef.actions = {}
mapDef.trigger_types = {}
mapDef.triggers = {}
local stack = StateStack:Create()
local explore = ExploreState:Create(stack, mapDef, Vector.Create(11, 3, 1))
local menu = InGameMenuState:Create(stack)

stack:Push(explore)
stack:Push(menu)

function update()
    local dt = GetDeltaTime()
    stack:Update(dt)
    stack:Render(gRenderer)
end