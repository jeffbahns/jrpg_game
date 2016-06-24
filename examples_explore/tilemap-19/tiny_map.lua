function CreateMap1()
return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 5,
  height = 5,
  tilewidth = 16,
  tileheight = 16,
  properties = {},
  tilesets = {
    {
      name = "cave16x16",
      firstgid = 1,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "cave16x16.png",
      imagewidth = 256,
      imageheight = 336,
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 5,
      height = 5,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        158, 255, 158, 158, 255,
        174, 174, 174, 174, 174,
        51, 51, 51, 51, 1,
        51, 51, 51, 51, 17,
        1, 2, 3, 51, 17
      }
    }
  }
}
end