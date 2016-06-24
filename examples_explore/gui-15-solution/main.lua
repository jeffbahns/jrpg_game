LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")
LoadLibrary("Vector")
LoadLibrary("Asset")
LoadLibrary("Keyboard")

Asset.Run("Util.lua")
Asset.Run("Tween.lua")
Asset.Run("Panel.lua")
Asset.Run("Textbox.lua")
Asset.Run("Selection.lua")
Asset.Run("ProgressBar.lua")
Asset.Run("StateStack.lua")

gRenderer = Renderer.Create()

stack = StateStack:Create()

stack:AddFitted(gRenderer, 0, 0, "Hello!")
stack:AddFitted(gRenderer, -25, -25, "World!")
stack:AddFitted(gRenderer, -50, -50, "Lots")
stack:AddFitted(gRenderer, -75, -75, "of")
stack:AddFitted(gRenderer, -100, -100, "boxes!")


function update()
    stack:Update(GetDeltaTime())
    stack:Render(gRenderer)
end

