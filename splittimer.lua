---@class SplitTimer
local SplitTimer = {}
local socket = require "socket"

function SplitTimer:init()
    local err
    self.connection, err = socket.connect("localhost", 16834)
    if err == "connection refused" then
        err = "Couldn't connect to LiveSplit! Do you have the TCP server running?"
    end
    assert(self.connection, err)
    self:sendCommand("switchto", "gametime")
end

function SplitTimer:deinit()
    self.connection:close()
end

function SplitTimer:sendCommand(...)
    self.connection:send(table.concat({...}, " ").."\n")
end

function SplitTimer:startTimer()
    return self:sendCommand "starttimer"
end

function SplitTimer:split()
    return self:sendCommand "split"
end

SplitTimer:init()
return SplitTimer
