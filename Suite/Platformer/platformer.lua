-- Platformer/platformer.lua
local State = require "State"
local Platformer = {}
Platformer.__index = Platformer

function Platformer.new()
    local self = setmetatable({}, Platformer)
    return self
end

function Platformer:load()
    -- window & libs
    love.window.setMode(1000, 768)
    self.anim8 = require 'Platformer.libraries.anim8.anim8'
    self.sti   = require 'Platformer.libraries.Simple-Tiled-Implementation.sti'
    local Camera = require 'Platformer.libraries.hump.camera'
    self.cam   = Camera()

    -- audio setup
    self.sounds = {
        jump  = love.audio.newSource('Platformer/audio/jump.wav','static'),
        music = love.audio.newSource('Platformer/audio/music.mp3','stream'),
    }
    self.sounds.music:setLooping(true)
    self.sounds.music:setVolume(0.5)
    self.sounds.music:play()

    -- sprites
    self.sprites = {
        playerSheet = love.graphics.newImage('Platformer/sprites/playerSheet.png'),
        enemySheet  = love.graphics.newImage('Platformer/sprites/enemySheet.png'),
        background  = love.graphics.newImage('Platformer/sprites/background.png'),
    }

    -- animations
    local grid      = self.anim8.newGrid(614, 564, self.sprites.playerSheet:getWidth(), self.sprites.playerSheet:getHeight())
    local enemyGrid = self.anim8.newGrid(100,  79,  self.sprites.enemySheet:getWidth(),  self.sprites.enemySheet:getHeight())
    self.animations = {
        idle  = self.anim8.newAnimation(grid('1-15',1), 0.05),
        jump  = self.anim8.newAnimation(grid('1-7',2),  0.05),
        run   = self.anim8.newAnimation(grid('1-15',3), 0.05),
        enemy = self.anim8.newAnimation(enemyGrid('1-2',1),0.03),
    }

    -- physics world
    local wf = require 'Platformer.libraries.windfield.windfield'
    self.world = wf.newWorld(0, 800, false)
    self.world:setQueryDebugDrawing(true)
    self.world:addCollisionClass('Platform')
    self.world:addCollisionClass('Player')
    self.world:addCollisionClass('Danger')

    -- show serializer
    self.show = require 'Platformer.libraries.show'

    -- modules: player and enemies
    local Player = require 'Platformer.player'
    self.player = Player.new(self.world, self.animations, self.sprites)
    local EnemyManager = require 'Platformer.enemy'
    self.enemies = EnemyManager.new(self.world, self.animations, self.sprites)

    -- static danger zone
    self.dangerZone = self.world:newRectangleCollider(-500, 800, 5000, 50, {collision_class = 'Danger'})
    self.dangerZone:setType('static')

    -- platform list
    self.platforms = {}
    -- flag and save data
    self.flagX, self.flagY = 0, 0
    self.saveData = { currentLevel = 'level1' }
    if love.filesystem.getInfo('data.lua') then
        local loader = love.filesystem.load('data.lua')
        local data = loader()
        if type(data)=='table' then self.saveData = data end
    end

    -- initial map load
    self:loadMap(self.saveData.currentLevel)
end

function Platformer:loadMap(mapName)
    self.saveData.currentLevel = mapName
    love.filesystem.write('data.lua', self.show(self.saveData,'saveData'))
    -- clear previous
    self:destroyAll()
    -- load Tiled map
    self.gameMap = self.sti('Platformer/maps/'..mapName..'.lua')
    -- place player
    for _, obj in ipairs(self.gameMap.layers['Start'].objects) do
        self.player:setPosition(obj.x, obj.y)
    end
    -- spawn platforms
    for _, obj in ipairs(self.gameMap.layers['Platforms'].objects) do
        self:spawnPlatform(obj.x, obj.y, obj.width, obj.height)
    end
    -- spawn enemies
    for _, obj in ipairs(self.gameMap.layers['Enemies'].objects) do
        self.enemies:spawn(obj.x, obj.y)
    end
    -- setup flag
    for _, obj in ipairs(self.gameMap.layers['Flag'].objects) do
        self.flagX, self.flagY = obj.x, obj.y
    end
end

function Platformer:spawnPlatform(x,y,w,h)
    local plat = self.world:newRectangleCollider(x,y,w,h,{collision_class='Platform'})
    plat:setType('static')
    table.insert(self.platforms, plat)
end

function Platformer:destroyAll()
    for _, p in ipairs(self.platforms) do p:destroy() end
    self.platforms = {}
    self.enemies:cleanup()
end

function Platformer:update(dt)
    self.world:update(dt)
    self.gameMap:update(dt)
    self.player:update(dt)
    self.enemies:update(dt)
    local px, _ = self.player:getPosition()
    self.cam:lookAt(px, love.graphics.getHeight()/2)
    local colliders = self.world:queryCircleArea(self.flagX, self.flagY, 10, {'Player'})
    if #colliders>0 then
        local next = self.saveData.currentLevel=='level1' and 'level2' or 'level1'
        self:loadMap(next)
    end
end

function Platformer:draw()
    love.graphics.draw(self.sprites.background,0,0)
    self.cam:attach()
    self.gameMap:drawLayer(self.gameMap.layers['Tile Layer 1'])
    self.player:draw()
    self.enemies:draw()
    self.cam:detach()
end

function Platformer:keypressed(key)
    if key=='up' then self.player:jump(self.sounds) end
    if key=='r'  then self:loadMap('level2') end
end

function Platformer:mousepressed(x,y,b)
    if b==1 then
        for _,c in ipairs(self.world:queryCircleArea(x,y,200,{'Platform','Danger'})) do c:destroy() end
    end
end

function Platformer:cleanup()
    for _, p in ipairs(self.platforms) do p:destroy() end
    self.player:cleanup()
    self.enemies:cleanup()
    self.world = nil
    self.cam = nil
    for k in pairs(self) do self[k]=nil end
end

return Platformer