local plugin = {}


function plugin:createSplitTimer()
    if SplitTimer ~= nil then
        SplitTimer:deinit()
    end
    ---@type SplitTimer
    SplitTimer = love.filesystem.load(Kristal.Mods.data.darksplits.path.."/splittimer.lua")()
    SplitTimer:init(Kristal.Config["plugins/darksplits"])
end

function plugin:init()
    ---@class DarkSplitsConfig
    ---@field category "DESS%" | "APM%"
    ---@field hostname string
    ---@field port number
    Kristal.Config["plugins/darksplits"] = Kristal.Config["plugins/darksplits"] or {
        category = "DESS%",
        hostname = "localhost",
        port = 16834,
    }
    if SplitTimer == nil or SplitTimer.connection == nil then
        self:createSplitTimer()
    end
end

function plugin:onDPDessTalk()
    if Kristal.Config["plugins/darksplits"].category == "DESS%" then
        SplitTimer:split()
    end
end

function plugin:onDPWarpBinUsed(code)
    if Kristal.Config["plugins/darksplits"].category == "DESS%" and code == "DESSHERE" then
        SplitTimer:split()
    end
end

function plugin:onDPUnlockPartyMember(id)
    if Kristal.Config["plugins/darksplits"].category == "APM%" then
        SplitTimer:split()
    elseif Kristal.Config["plugins/darksplits"].category == "DESS%" and id == "susie" then
        SplitTimer:split()
    end
end

function plugin:postInit(new_file)
    if new_file then
        SplitTimer:reset()
    else
        SplitTimer:unpause()
    end
end

function plugin:unload()
    SplitTimer:pause()
end

return plugin
