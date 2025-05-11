require('MainMenu/mainmenu')
require('Platformer/platformer')
require('TopDownShooter/topdownshooter')

game = 0

function love.load()
    if game == 0 then
        instantiateMainMenu()
        MainMenu:load()        
    elseif game == -2 then
        MainMenu:garbageCollect()
        TopDownShooter:load()
        game = game * -1
    elseif game == -3 then
        MainMenu:garbageCollect()
        instantiatePlatformer()
        Platformer:load()
        game = game * -1
    end
end

function love.update(dt)
    if game == 0 then
        MainMenu:update(dt)
    elseif game == 2 then
        TopDownShooter:update(dt)       
    elseif game == 3 then
        Platformer:update(dt)
    end
end

function love.draw()
    if game == 0 then
        MainMenu:draw()
    elseif game == 2 then
        TopDownShooter:draw()
    elseif game == 3 then
        Platformer:draw()
    end
end

function love.keypressed(key)
    if game == 0 then
        MainMenu:keypressed(key)
    elseif game == 2 then
        TopDownShooter:keypressed(key)
    elseif game == 3 then
        Platformer:keypressed(key)
    end
end

function love.mousepressed(x, y, button)
    if game == 2 then
        TopDownShooter:mousepressed(x, y, button)
    end
end