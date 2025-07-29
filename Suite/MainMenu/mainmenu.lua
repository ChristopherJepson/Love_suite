-- mainmenu.lua
local State    = require "State"        -- add this
local MainMenu = {}
MainMenu.__index = MainMenu

function MainMenu.new()
    local self = setmetatable({}, MainMenu)
    -- initialize your menu-specific fields here
    return self
end

function MainMenu:load()
    -- load assets, set up menu items, etc.
        love.window.setMode(500, 500)
        
        menu_sprites = {   
            ["menuBackground"] = {
                ['file'] = "MainMenu/sprites/castle.png";
            }; 
        }
        menu_sprites.background = love.graphics.newImage(menu_sprites.menuBackground.file)
        love.graphics.print('Choose a game: ')
end

function MainMenu:update(dt)
    -- animate menu, handle hover effects
end

function MainMenu:draw()
    -- draw menu
    love.graphics.draw(menu_sprites.background, 0, 0, null, 0.13, 0.231)
    love.graphics.printf('Choose a game: ', 0, 100, love.graphics.getWidth(), 'center')
    love.graphics.printf('1 - Shooting Gallery', 0, 150, love.graphics.getWidth(), 'center')
    love.graphics.printf('2 - Top Down Shooter', 0, 200, love.graphics.getWidth(), 'center')
    love.graphics.printf('3 - Platformer', 0, 250, love.graphics.getWidth(), 'center')
    love.graphics.printf('4 - Quit', 0, 300, love.graphics.getWidth(), 'center')
end

function MainMenu:keypressed(key)
    if love.keyboard.isDown("1") then
        self.manager:switch(State.SHOOTING_GALLERY)
    elseif love.keyboard.isDown("2") then
        self.manager:switch(State.SHOOTER)
    elseif love.keyboard.isDown("3") then
        self.manager:switch(State.PLATFORMER)
    elseif love.keyboard.isDown("4") then
        love.event.quit()
    end
    -- on enter, call something like:
    --   stateManager:switch(State.PLATFORMER)
end

function MainMenu:cleanup()
    -- nil out any large tables, stop sounds, etc.
end

return MainMenu
