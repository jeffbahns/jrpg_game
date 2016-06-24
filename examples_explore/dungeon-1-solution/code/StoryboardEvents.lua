

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


function Wait(seconds)
    return function(storyboard)
        return WaitEvent:Create(seconds)
    end
end