LoadLibrary('Asset')
Asset.Run('Dependencies.lua')

gRenderer = Renderer.Create()
gWorld = World:Create()

local itemList = Selection:Create
{
    data = gWorld.mItems,
    spacingY = 32,
    rows = 5,
    RenderItem = function(menu, renderer, x, y, item)
        if item then
            local itemDef = ItemDB[item.id]
            local label = string.format("%s (%d)",
                                        itemDef.name,
                                        item.count)
            renderer:DrawText2d(x, y, label)
        else
            renderer:DrawText2d(x, y, "--")
        end
    end
}

local keyItemList = Selection:Create
{
    data = gWorld.mKeyItems,
    spacingY = 32,
    rows = 5,
    RenderItem = function(menu, renderer, x, y, item)
        if item then
            local itemDef = ItemDB[item.id]
            renderer:DrawText2d(x, y, itemDef.name )
        else
            renderer:DrawText2d(x, y, "--")
        end
    end
}
keyItemList:HideCursor()

function update()
    local dt = GetDeltaTime()
    gWorld:Update(dt)


    local x = -200
    local y = 50
    gRenderer:AlignText("center", "center")
    gRenderer:DrawText2d(x + itemList:GetWidth()/2, y + 32, "ITEMS")
    gRenderer:AlignText("left", "center")
    itemList:SetPosition(x, y)
    itemList:Render(gRenderer)
    itemList:HandleInput()

    x = 100

    gRenderer:AlignText("center", "center")
    gRenderer:DrawText2d(x + itemList:GetWidth()/2, y + 32, "KEY ITEMS")
    keyItemList:SetPosition(x, y)
    keyItemList:Render(gRenderer)

    local timeText = string.format("TIME:%s", gWorld:TimeAsString())
    local goldText = string.format("GOLD:%s", gWorld:GoldAsString())
    gRenderer:DrawText2d(0,150, timeText)
    gRenderer:DrawText2d(0,120, goldText)

    if Keyboard.JustPressed(KEY_A) then
        gWorld:AddItem(1)
    end

    if Keyboard.JustPressed(KEY_R) then
        local item = itemList:SelectedItem()
        if item then
            gWorld:RemoveItem(item.id)
        end
    end

    if Keyboard.JustPressed(KEY_K) then
        if not gWorld:HasKey(4) then
            gWorld:AddKey(4)
        end
    end

    if Keyboard.JustPressed(KEY_U) then
       if gWorld:HasKey(4) then
            gWorld:RemoveKey(4)
        end
    end

    if Keyboard.JustPressed(KEY_G) then
        gWorld.mGold = gWorld.mGold + math.random(100)
    end

    local tip = "A - Add Item, R - Remove Item," ..
                "K - Add Key, U - Use Key, G - Add Gold"
    gRenderer:DrawText2d(0, -150, tip, 300)
end