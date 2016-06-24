
PanelLayout = {}
PanelLayout.__index = PanelLayout
function PanelLayout:Create()
    local this =
    {
        mPanels = {},
        mPanelDef =
        {
            texture = Texture.Find("gradient_panel.png"),
            size = 3,
        }
    }

    -- First panel is the full screen
    this.mPanels['screen'] =
    {
        x = 0,
        y = 0,
        width = System.ScreenWidth(),
        height = System.ScreenHeight(),
    }

    setmetatable(this, self)
    return this
end

function PanelLayout:Contract(name, horz, vert)
    horz = horz or 0
    vert = vert or 0
    local panel = self.mPanels[name]
    assert(panel)

    panel.width = panel.width - horz
    panel.height = panel.height - vert
end

function PanelLayout:SplitHorz(name, tname, bname, x, splitSize)

    local parent = self.mPanels[name]
    self.mPanels[name] = nil

    local p1Height = parent.height * x
    local p2Height = parent.height * (1 - x)
    self.mPanels[tname] =
    {
        x = parent.x,
        y = parent.y + parent.height/2 - p1Height/2 + splitSize/2,
        width = parent.width,
        height = p1Height - splitSize,
    }


    self.mPanels[bname] =
    {
        x = parent.x,
        y = parent.y - parent.height/2 + p2Height/2 - splitSize/2,
        width = parent.width,
        height = p2Height - splitSize,
    }

end

function PanelLayout:SplitVert(name, lname, rname, y, splitSize)
    local parent = self.mPanels[name]
    self.mPanels[name] = nil

    local p1Width = parent.width * y
    local p2Width = parent.width * (1 - y)
    self.mPanels[rname] =
    {
        x = parent.x + parent.width/2 - p1Width/2 + splitSize/2,
        y = parent.y,
        width = p1Width - splitSize,
        height = parent.height,
    }
    self.mPanels[lname] =
    {
        x = parent.x - parent.width/2 + p2Width/2 - splitSize/2,
        y = parent.y,
        width = p2Width - splitSize,
        height = parent.height,
    }
end

function PanelLayout:CreatePanel(name)
    local panel = Panel:Create(self.mPanelDef)
    local layout = self.mPanels[name]
    panel:CenterPosition(layout.x, layout.y,
                         layout.width, layout.height)
    return panel
end

function PanelLayout:DebugRender(renderer)

    for k, v in pairs(self.mPanels) do
        local panel = self:CreatePanel(k)
        panel:Render(renderer)
    end
end

function PanelLayout:Top(name)
    local panel = self.mPanels[name]
    return panel.y + panel.height / 2
end

function PanelLayout:Bottom(name)
    local panel = self.mPanels[name]
    return panel.y - panel.height / 2
end

function PanelLayout:Left(name)
    local panel = self.mPanels[name]
    return panel.x - panel.width / 2
end

function PanelLayout:Right(name)
    local panel = self.mPanels[name]
    return panel.x + panel.width / 2
end

function PanelLayout:MidX(name)
    local panel = self.mPanels[name]
    return panel.x
end

function PanelLayout:MidY(name)
    local panel = self.mPanels[name]
    return panel.y
end