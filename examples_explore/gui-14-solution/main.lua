LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")
LoadLibrary("Vector")
LoadLibrary("Asset")
LoadLibrary("Keyboard")

Asset.Run("Util.lua")
Asset.Run("Scrollbar.lua")

gRenderer = Renderer.Create()

--
-- Adding a scrollbar
--
local bar1 = Scrollbar:Create(Texture.Find("scrollbar.png"), 100)
local bar2 = Scrollbar:Create(Texture.Find("scrollbar.png"), 200)
local bar3 = Scrollbar:Create(Texture.Find("scrollbar.png"), 75)

bar1:SetScrollCaretScale(0.5)
bar1:SetNormalValue(0.5)
bar1:SetPosition(-50, 10)

bar2:SetScrollCaretScale(0.3)
bar2:SetNormalValue(0)
bar2:SetPosition(0, 0)

bar3:SetScrollCaretScale(0.1)
bar3:SetNormalValue(1)
bar3:SetPosition(50, -10)

function update()
    bar1:Render(gRenderer)
    bar2:Render(gRenderer)
    bar3:Render(gRenderer)
end

