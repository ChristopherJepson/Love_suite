-- StateManager.lua
local StateManager = {}
StateManager.__index = StateManager

function StateManager.new()
    return setmetatable({
        current = nil,
        modules = {},
    }, StateManager)
end

function StateManager:register(name, moduleFactory)
    -- moduleFactory is a function that returns a fresh module instance
    self.modules[name] = { factory = moduleFactory, instance = nil }
end

function StateManager:switch(name)
    -- tear down previous
    if self.current and self.modules[self.current].instance.cleanup then
        self.modules[self.current].instance:cleanup()
    end
    collectgarbage("collect")

    -- instantiate new
    local entry = self.modules[name]
    assert(entry, "No state registered: "..tostring(name))
    entry.instance = entry.factory()
    entry.instance:load()
    self.current = name
end

function StateManager:update(dt)
    if self.current then
        local inst = self.modules[self.current].instance
        if inst.update then inst:update(dt) end
    end
end

function StateManager:draw()
    if self.current then
        local inst = self.modules[self.current].instance
        if inst.draw then inst:draw() end
    end
end

function StateManager:keypressed(key)
    if self.current then
        local inst = self.modules[self.current].instance
        if inst.keypressed then inst:keypressed(key) end
    end
end

function StateManager:mousepressed(x,y,b)
    if self.current then
        local inst = self.modules[self.current].instance
        if inst.mousepressed then inst:mousepressed(x,y,b) end
    end
end

return StateManager
