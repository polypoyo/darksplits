local plugin = {}

local config = {category = "DESS%"}

function plugin:createSplitTimer()
    if SplitTimer ~= nil then
        SplitTimer:deinit()
    end
    ---@type SplitTimer
    SplitTimer = love.filesystem.load(Kristal.Mods.data.darksplits.path.."/splittimer.lua")()
end

function plugin:init()
    if SplitTimer == nil then
        self:createSplitTimer()
    end
end

function plugin:onDPDessTalk()
    if config.category == "DESS%" then
        SplitTimer:split()
    end
end

function plugin:onDPWarpBinUsed(code)
    if config.category == "DESS%" and code == "DESSHERE" then
        SplitTimer:split()
    end
end

function plugin:onDPUnlockPartyMember(id)
    if config.category == "APM%" then
        SplitTimer:split()
    elseif config.category == "DESS%" and id == "susie" then
        SplitTimer:split()
    end
end

function plugin:postInit(new_file)
    if new_file then
        SplitTimer:sendCommand "reset"
        SplitTimer:startTimer()
    else
        SplitTimer:sendCommand "unpausegametime"
    end
end

function plugin:unload()
    SplitTimer:sendCommand "pausegametime"
end

return plugin
