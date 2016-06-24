LoadLibrary('Asset')
Asset.Run('Dependencies.lua')

gRenderer = Renderer.Create()


--
-- We're going to create a layout!
--

local layout = Layout:Create()

layout:Contract('screen', 118, 40)
layout:SplitHorz('screen', "top", "bottom", 0.12, 2)
layout:SplitVert('bottom', "left", "party", 0.726, 2)
layout:SplitHorz('left', "menu", "gold", 0.7, 2)

function update()
    local dt = GetDeltaTime()
    layout:DebugRender(gRenderer)
end