

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