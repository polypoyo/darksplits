---@class SplitTimer
local SplitTimer = {}
local socket = require "socket"

---@param config DarkSplitsConfig
function SplitTimer:init(config)
    self.config = config
    local err
    self.connection, err = socket.connect(self.config.hostname, self.config.port)
    if err == "connection refused" then
        err = "Couldn't connect to LiveSplit! Do you have the TCP server running?"
    end
    assert(self.connection, err)
end

function SplitTimer:deinit()
    if self.connection then
        self.connection:close()
    end
end

function SplitTimer:sendCommand(...)
    self.connection:send(table.concat({...}, " ").."\n")
end

function SplitTimer:startTimer()
    -- TODO: find out how gametime works
    --self:sendCommand("switchto", "gametime")
    return self:sendCommand "starttimer"
end

function SplitTimer:syncGameTime()
    local s = Game.playtime
    local seconds_padding = s > 10 and "" or "0"
    local time = string.format( "%.2d:%.2d:%s%.7f", s/(60*60), s/60%60, seconds_padding, s%60 )
    self:sendCommand("setgametime", time)
end

function SplitTimer:split()
    self:syncGameTime()
    return self:sendCommand "split"
end

function SplitTimer:pause()
    self:syncGameTime()
    self:sendCommand "pausegametime"
end

function SplitTimer:unpause()
    self:syncGameTime()
    self:sendCommand "unpausegametime"
end

function SplitTimer:reset()
    self:sendCommand "reset"
    self:startTimer()
end

return SplitTimer
