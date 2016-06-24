LoadLibrary('Asset')
Asset.Run('Dependencies.lua')

gRenderer = Renderer.Create()

local mapDef = CreateMap1()
mapDef.on_wake = {}
mapDef.actions = {}
mapDef.trigger_types = {}
mapDef.triggers = {}

-- 11, 3, 1 == x, y, layer


local stack = StateStack:Create()
local state = ExploreState:Create(stack, mapDef, Vector.Create(11, 3, 1))
stack:Push(state)
stack:PushFit(gRenderer, 0,0,"You're trapped in a small room.")

-- stack:Push
-- {
--     OnEnter = function() end,
--     OnExit = function() end,
--     HandleInput = function() end,
--     Render = function(self, renderer)

--         local halfWidth = 100
--         local halfHeight = 100
--         renderer:DrawRect2d(
--             -halfWidth,
--             halfHeight,
--             halfWidth,
--             -halfHeight,
--             Vector.Create(0,0,0,1)
--         )
--         renderer:DrawText2d(0,0,"HELLO")
--         return false
--     end,
--     Update = function()
--         return false
--     end
-- }

function update()
    local dt = GetDeltaTime()
    stack:Update(dt)
    stack:Render(gRenderer)
end