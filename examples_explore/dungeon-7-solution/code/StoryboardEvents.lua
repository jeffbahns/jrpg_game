

WaitEvent = {}
WaitEvent.__index = WaitEvent
function WaitEvent:Create(seconds)
    local this =
    {
        mSeconds = seconds,
    }
    setmetatable(this, self)
    return this
end

function WaitEvent:Update(dt)
    self.mSeconds = self.mSeconds - dt
end

function WaitEvent:IsBlocking()
    return true
end

function WaitEvent:IsFinished()
    return self.mSeconds <= 0
end

function WaitEvent:Render() end

TweenEvent = {}
TweenEvent.__index = TweenEvent
function TweenEvent:Create(tween, target, ApplyFunc)
    local this =
    {
        mTween = tween,
        mTarget = target,
        mApplyFunc = ApplyFunc
    }
    setmetatable(this, self)
    return this
end

function TweenEvent:Update(dt, storyboard)
    self.mTween:Update(dt)
    self.mApplyFunc(self.mTarget, self.mTween:Value())
end

function TweenEvent:Render() end
function TweenEvent:IsFinished()
    return self.mTween:IsFinished()
end
function TweenEvent:IsBlocking()
    return true
end

BlockUntilEvent = {}
BlockUntilEvent.__index = BlockUntilEvent
function BlockUntilEvent:Create(UntilFunc)
    local this =
    {
        mUntilFunc = UntilFunc,
    }
    setmetatable(this, self)
    return this
end

function BlockUntilEvent:Update(dt) end
function BlockUntilEvent:Render() end

function BlockUntilEvent:IsBlocking()
    return not self.mUntilFunc()
end

function BlockUntilEvent:IsFinished()
    return not self:IsBlocking()
end

TimedTextboxEvent = {}
TimedTextboxEvent.__index = TimedTextboxEvent
function TimedTextboxEvent:Create(box, time)
    local this =
    {
        mTextbox = box,
        mCountDown = time
    }
    setmetatable(this, self)
    return this
end

function TimedTextboxEvent:Update(dt, storyboard)
    self.mCountDown = self.mCountDown - dt
    if self.mCountDown <= 0 then
        self.mTextbox:OnClick()
    end
end
function TimedTextboxEvent:Render() end

function TimedTextboxEvent:IsBlocking()
    return self.mCountDown > 0
end

function TimedTextboxEvent:IsFinished()
    return not self:IsBlocking()
end






function Wait(seconds)
    return function()
        return WaitEvent:Create(seconds)
    end
end

EmptyEvent = WaitEvent:Create(0)

function BlackScreen(id)

    id = id or "blackscreen"

    return function(storyboard)
        local screen = ScreenState:Create(black)
        storyboard:PushState(id, screen)
        return EmptyEvent
    end
end

function Play(soundName, name, volume)
    name = name or soundName
    volume = volume or 1
    return function(storyboard)
        local id = Sound.Play(soundName)
        Sound.SetVolume(id, volume)
        storyboard:AddSound(name, id)
        return EmptyEvent
    end
end

function Stop(name)
    return function(storyboard)
        storyboard:StopSound(name)
        return EmptyEvent
    end
end

function FadeSound(name, start, finish, duration)
    return function(storyboard)

        local id = storyboard.mPlayingSounds[name]
        assert(id)
        return TweenEvent:Create(
            Tween:Create(start, finish, duration),
            id,
            function(target, value)
                Sound.SetVolume(target, value)
            end)
    end
end

function FadeScreen(id, duration, start, finish)

    local duration = duration or 3

    return function(storyboard)

        local target = storyboard.mSubStack:Top()
        if id then
            target = storyboard.mStates[id]
        end
        assert(target and target.mColor)

        return TweenEvent:Create(
            Tween:Create(start, finish, duration),
            target,
            function(target, value)
                target.mColor:SetW(value)
            end)
    end
end

function FadeInScreen(id, duration)
    return FadeScreen(id, duration, 0, 1)
end

function FadeOutScreen(id, duration)
    return FadeScreen(id, duration, 1, 0)
end

function Caption(id, style, text)

    return function(storyboard)
        local style = ShallowClone(CaptionStyles[style])
        local caption = CaptionState:Create(style, text)
        storyboard:PushState(id, caption)

        return TweenEvent:Create(
                Tween:Create(0, 1, style.duration),
                style,
                style.ApplyFunc)

    end

end

function FadeOutCaption(id, duration)
    return function(storyboard)
        local target = storyboard.mSubStack:Top()
        if id then
            target = storyboard.mStates[id]
        end
        print(id, target)
        local style = target.mStyle
        duration = duration or style.duration

        return TweenEvent:Create(
            Tween:Create(1, 0, duration),
            style,
            style.ApplyFunc
        )
    end
end

function NoBlock(f)
    return function(...)
        local event = f(...)
        event.IsBlocking = function()
            return false
        end
        return event
    end
end

function KillState(id)
    return function(storyboard)
        storyboard:RemoveState(id)
        return EmptyEvent
    end
end

function Scene(params)
    return function(storyboard)
        local id = params.name or params.map
        local map = MapDB[params.map]()
        local focus = Vector.Create(params.focusX or 1,
                                    params.focusY or 1,
                                    params.focusZ or 1)
        local state = ExploreState:Create(nil, map, focus)
        if params.hideHero then
            state:HideHero()
        end
        storyboard:PushState(id, state)

        -- Allows the following instruction to be carried out
        -- on the same frame.
        return NoBlock(Wait(0.1))()
    end
end


function GetMapRef(storyboard, stateId)
    local exploreState = storyboard.mStates[stateId]
    assert(exploreState and exploreState.mMap)
    return exploreState.mMap
end

function ReplaceScene(name, params)
    return function(storyboard)
        local state = storyboard.mStates[name]

        -- Give the state an updated name
        local id = params.name or params.map
        storyboard.mStates[name] = nil
        storyboard.mStates[id] = state

        local mapDef = MapDB[params.map]()
        state.mMap =  Map:Create(mapDef)

        state.mMap:GotoTile(params.focusX, params.focusY)
        state.mHero = Character:Create(gCharacters.hero, state.mMap)
        state.mHero.mEntity:SetTilePos(
            params.focusX,
            params.focusY,
            params.focusZ or 1,
            state.mMap)

        if params.hideHero then
            state:HideHero()
        else
            state:ShowHero()
        end

        return NoBlock(Wait(0.1))()
    end
end

function Say(mapId, npcId, text, time, params)

    time = time or 1
    params = params or {textScale = 0.8}

    return function(storyboard)
        local map = GetMapRef(storyboard, mapId)
        local npc = map.mNPCbyId[npcId]
        if npcId == "hero" then
           npc = storyboard.mStates[mapId].mHero
        end
        local pos = npc.mEntity.mSprite:GetPosition()
        storyboard.mStack:PushFit(
            gRenderer,
            -map.mCamX + pos:X(), -map.mCamY + pos:Y() + 32,
            text, -1, params)
        local box = storyboard.mStack:Top()
        return TimedTextboxEvent:Create(box, time)
    end
end

function RunAction(actionId, actionParams, paramOps)

    local action = Actions[actionId]
    assert(action)

    return function(storyboard)

        --
        --  Look up refences required by action.
        --
        paramOps = paramOps or {}

        for k, op in pairs(paramOps) do
            if op then
                print(k, op)
                actionParams[k] = op(storyboard, actionParams[k])
            end
        end

        local actionFunc = action(unpack(actionParams))
        actionFunc()

        return EmptyEvent
    end
end

function MoveNPC(id, mapId, path)
    return function(storyboard)
        local map = GetMapRef(storyboard, mapId)
        local npc = map.mNPCbyId[id]
        npc:FollowPath(path)
        return BlockUntilEvent:Create(
            function()
                return npc.mPathIndex > #npc.mPath
            end)
    end
end

function HandOff(mapId)
    return function(storyboard)
        local exploreState = storyboard.mStates[mapId]
        storyboard.mStack:Pop() -- remove storyboard from the top of the stack
        storyboard.mStack:Push(exploreState)
        return EmptyEvent
    end
end