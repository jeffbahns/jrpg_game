LoadLibrary("Renderer")
LoadLibrary("System")
LoadLibrary("Vector")

gRenderer = Renderer.Create()
gLeft = -System.ScreenWidth() / 2
gTop = System.ScreenHeight() / 2

-- Creates a vector that represents the color red R,G,B,A
-- Red, Green, Blue and Alpha
-- Alpha controls the transparency of the color.
gRed = Vector.Create(1, 0, 0, 1)

function update()

    -- Draws a rectangle 1 pixel in width and height
    -- 0.5 is half a pixel, if we draw from -0.5 to 0.5 we get a full pixel!
    -- left, bottom, right, top
    gRenderer:DrawRect2d(gLeft, gTop - 1, gLeft + 1, gTop,
                         gRed)
end