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
    self.connection:close()
end

function SplitTimer:sendCommand(...)
    self.connection:send(table.concat({...}, " ").."\n")
end

function SplitTimer:startTimer()
    -- TODO: find out how gametime works
    --self:sendCommand("switchto", "gametime")
    return self:sendCommand "starttimer"
end

function SplitTimer:split()
    return self:sendCommand "split"
end

return SplitTimer
