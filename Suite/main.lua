-- main.lua
local State             = require "State"          -- your named constants
local StateMgr          = require "StateManager"
local MainMenu          = require "MainMenu/mainmenu"
local ShootingGallery   = require "ShootingGallery/shootinggallery"
local Platformer        = require "Platformer/platformer"
local TopdownShooter    = require "TopDownShooter/topdownshooter"
local lovetest          = require "libraries/lovetest"      -- optional, for testing

local stateManager = StateMgr.new()

function love.load()
    --lovetest.run()
    -- register each game state with a factory function
    stateManager:register(State.MENU,   function() 
        local inst = MainMenu.new() 
        inst.manager = stateManager 
        return inst 
    end)
    stateManager:register(State.SHOOTING_GALLERY, function() 
        local inst = ShootingGallery.new()
        inst.manager = stateManager
        return inst
    end)
    stateManager:register(State.PLATFORMER, function() 
        local inst = Platformer.new()
        inst.manager = stateManager
        return inst
    end)
    stateManager:register(State.TOPDOWN_SHOOTER,    function() 
        local inst = TopdownShooter.new() 
        inst.manager = stateManager 
        return inst 
    end)

    -- start in the main menu
    stateManager:switch(State.MENU)

end

function love.load(arg)
    
    --lovetest.run()
    -- register each game state with a factory function
    stateManager:register(State.MENU,   function() 
        local inst = MainMenu.new() 
        inst.manager = stateManager 
        return inst 
    end)
    stateManager:register(State.SHOOTING_GALLERY, function() 
        local inst = ShootingGallery.new()
        inst.manager = stateManager
        return inst
    end)
    stateManager:register(State.PLATFORMER, function() 
        local inst = Platformer.new()
        inst.manager = stateManager
        return inst
    end)
    stateManager:register(State.TOPDOWN_SHOOTER,    function() 
        local inst = TopdownShooter.new() 
        inst.manager = stateManager 
        return inst 
    end)

    -- start in the main menu
    stateManager:switch(State.MENU)

    -- Check for the testing command line flags
    if lovetest.detect(arg) then
        -- Run the tests
        lovetest.run()
    end
end

function love.update(dt)
    stateManager:update(dt)
end

function love.draw()
    stateManager:draw()
end

function love.keypressed(key)
    stateManager:keypressed(key)
end

function love.mousepressed(x, y, button)
    stateManager:mousepressed(x, y, button)
end
