LoadLibrary('Asset')
Asset.Run('Dependencies.lua')

gRenderer = Renderer.Create()

local mapDef = CreateMap1()
mapDef.on_wake = {}
mapDef.actions = {}
mapDef.trigger_types = {}
mapDef.triggers = {}

-- 11, 3, 1 == x, y, layer


local CreateBlock = function(stack)
    return
    {
        Enter = function() end,
        Exit = function() end,
        HandleInput = function(self)
            stack:Pop()
        end,
        Render = function() end,
        Update = function(self)
            return false
        end
    }
end

local stack = StateStack:Create()
local state = ExploreState:Create(stack, mapDef, Vector.Create(11, 3, 1))
stack:Push(state)


stack:Push(FadeState:Create(stack))
stack:Push(CreateBlock(stack))
stack:PushFit(gRenderer, 0, 0, "Where am I?")
stack:Push(CreateBlock(stack))
stack:PushFit(gRenderer, -50, 50, "My head hurts!")
stack:Push(CreateBlock(stack))
stack:PushFit(gRenderer, -100, 100, "Uh...")


function update()
    local dt = GetDeltaTime()
    stack:Update(dt)
    stack:Render(gRenderer)
end