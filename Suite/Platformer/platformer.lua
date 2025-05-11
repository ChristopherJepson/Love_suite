function instantiatePlatformer()

    Platformer = {}
    Platformer.__index = Platformer

    local flagX = 0
    local flagY = 0

    function Platformer:load()
        love.window.setMode(1000, 768)

        wf = require 'Platformer/libraries/windfield/windfield'
        sti = require 'Platformer/libraries/Simple-Tiled-Implementation/sti'
        cameraFile = require 'Platformer/libraries/hump/camera'
        anim8 = require 'Platformer/libraries/anim8/anim8'
        jumpAudio = love.audio.newSource('Platformer/audio/jump.wav', 'static')
        musicAudio = love.audio.newSource('Platformer/audio/music.mp3', 'stream')
        require('Platformer/config/sprite')
        require('Platformer/audio')
        require('Platformer/animations')
        require('Platformer/worlds')
        require('Platformer/player')
        require('Platformer/enemies')
        require('Platformer/libraries/show')

     
        instantiateWorlds()
        instantiatePlayers()
        instantiateEnemies()
        instantiateAnimations()

        cam = cameraFile()

        Platformer:loadSprites()

        Audio:init(jumpAudio, musicAudio)
        Animations:init(anim8)
        Worlds:init(wf)
        Players:init()

        Audio.sounds.music:play()

        dangerZone = Worlds.firstWorld:newRectangleCollider(-500, 800, 5000, 50, {collision_class = 'Danger'})
        dangerZone:setType('static')

        platforms = {}
        saveData = {}
        saveData.currentLevel = 'level1'

        if love.filesystem.getInfo('data.lua') then
            local data = love.filesystem.load('data.lua')
            data()
        end
        
        Platformer:loadMap(saveData.currentLevel)
    end

    function Platformer:update(dt)
        
        Worlds.firstWorld:update(dt)
        gameMap:update(dt)
        Players:playerUpdate(dt)
        updateEnemies(dt)

        local px, py = Players.player:getPosition()
        cam:lookAt(px, love.graphics.getHeight()/2)

        local colliders = Worlds.firstWorld:queryCircleArea(flagX, flagY, 10, {'Player'})
        if #colliders > 0 then
            if saveData.currentLevel == 'level1' then
                Platformer:loadMap('level2')
            elseif saveData.currentLevel == 'level2' then
                Platformer:loadMap('level1')
            end
        end
    end

    function Platformer:draw()
        love.graphics.draw(sprites.background, 0, 0)
        cam:attach()
            gameMap:drawLayer(gameMap.layers['Tile Layer 1'])
            Worlds.firstWorld:draw()
            Players:drawPlayer()
            drawEnemies()
        cam:detach()
    end

    function Platformer:keypressed(key)
        if key == 'up' then
            if Players.player.grounded then
                Players.player:applyLinearImpulse(0, -4000)
                Audio.sounds.jump:play()
            end
        end
        if key == 'r' then
            Platformer:loadMap('level2')
        end
    end

    function Platformer:loadMap(mapName)
        saveData.currentLevel = mapName
        love.filesystem.write('data.lua', table.show(saveData, 'saveData'))
        Worlds:destroyAll()
        Players.player:setPosition(Players:getStartX(), Players:getStartY())
        gameMap = sti('Platformer/maps/' .. mapName .. '.lua')
        for i, obj in pairs(gameMap.layers['Start'].objects) do
            playerStartX = obj.x
            playerStartY = obj.y
        end
        Players.player:setPosition(playerStartX, playerStartY)
        for i, obj in pairs(gameMap.layers['Platforms'].objects) do
            Worlds:spawnPlatform(obj.x, obj.y, obj.width, obj.height)
        end
        for i, obj in pairs(gameMap.layers['Enemies'].objects) do
            spawnEnemy(obj.x, obj.y)
        end
        for i, obj in pairs(gameMap.layers['Flag'].objects) do
            flagX = obj.x
            flagY = obj.y
        end
    end

    function Platformer:loadSprites()
        sprites = {}
        sprites.playerSheet = love.graphics.newImage(sprite.playerSheet.file)
        sprites.enemySheet = love.graphics.newImage(sprite.enemySheet.file)
        sprites.background = love.graphics.newImage(sprite.background.file)
    end

    function Platformer:garbageCollect()
        Audio.sounds.music:stop()
        Enemies:garbageCollect()
        Players:garbageCollect()
        Animations:garbageCollect()
        Worlds:garbageCollect()
        
        Platformer = nil
    end
end