LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")
LoadLibrary("Vector")
LoadLibrary("Asset")
LoadLibrary("Keyboard")


Asset.Run("Map.lua")
Asset.Run("Util.lua")
Asset.Run("small_room.lua")

local gMap = Map:Create(CreateMap1())
gRenderer = Renderer:Create()


gMap:GotoTile(5, 5)

--
-- Hero code has been removed as we'll replace it with the Entity class
--

function update()

    gRenderer:Translate(-gMap.mCamX, -gMap.mCamY)
    gMap:Render(gRenderer)
    -- Remember to render the hero!

    -- Add the hero movement code here
    if Keyboard.JustPressed(KEY_LEFT) then

    elseif Keyboard.JustPressed(KEY_RIGHT) then

    end

    if Keyboard.JustPressed(KEY_UP) then

    elseif Keyboard.JustPressed(KEY_DOWN) then

    end

end