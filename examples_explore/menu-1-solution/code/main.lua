LoadLibrary('Asset')
Asset.Run('Dependencies.lua')

gRenderer = Renderer.Create()

local mapDef = CreateMap1()
mapDef.on_wake = {}
mapDef.actions = {}
mapDef.trigger_types = {}
mapDef.triggers = {}

-- 11, 3, 1 == x, y, layer
local state = ExploreState:Create(nil, mapDef, Vector.Create(11, 3, 1))

function update()
    local dt = GetDeltaTime()
    state:Update(dt)
    state:HandleInput()
    state:Render(gRenderer)
end