function instantiateMainMenu()

    MainMenu = {}
    MainMenu.__index = MainMenu

    function MainMenu:load()
        love.window.setMode(500, 500)
        require('Platformer/config/sprite')
        menu_sprites = {}
        menu_sprites.background = love.graphics.newImage(sprite.menuBackground.file)
        love.graphics.print('Choose a game: ')

    end

    function MainMenu:update(dt)

        if love.keyboard.isDown("2") then
            game = -2
            love.load()
        elseif love.keyboard.isDown("3") then
            game = -3
            love.load()
        end
    end

    function MainMenu:draw()
        love.graphics.draw(menu_sprites.background, 0, 0, null, 0.13, 0.231)
        love.graphics.printf('Choose a game: ', 0, 100, love.graphics.getWidth(), 'center')
        love.graphics.printf('1 - Target Practice', 0, 150, love.graphics.getWidth(), 'center')
        love.graphics.printf('2 - Top Down Shooter', 0, 200, love.graphics.getWidth(), 'center')
        love.graphics.printf('3 - Platformer', 0, 250, love.graphics.getWidth(), 'center')
    end

    function MainMenu:garbageCollect()
        MainMenu = nil
    end
    
    function MainMenu:keypressed(key)

    end
end