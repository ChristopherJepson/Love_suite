-- Platformer/player.lua
local Player = {}
Player.__index = Player

function Player.new(world, animations, sprites)
    local self = setmetatable({}, Player)
    self.world      = world
    self.animations = animations
    self.sprites    = sprites
    self.startX, self.startY = 0, 0
    self.collider   = world:newRectangleCollider(0,0,40,100,{collision_class='Player'})
    self.collider:setFixedRotation(true)
    self.speed      = 240
    self.state      = { grounded=false, direction=1 }
    self.animation  = animations.idle
    return self
end

function Player:setPosition(x,y)
    self.startX, self.startY = x, y
    self.collider:setPosition(x,y)
end

function Player:getPosition()
    return self.collider:getPosition()
end

function Player:update(dt)
    local x,y = self.collider:getPosition()
    local cols = self.world:queryRectangleArea(x-20,y+50,40,2,{'Platform'})
    self.state.grounded = (#cols>0)
    local moving = false
    if love.keyboard.isDown('right') then
        self.collider:setX(x + self.speed*dt)
        moving = true; self.state.direction = 1
    elseif love.keyboard.isDown('left') then
        self.collider:setX(x - self.speed*dt)
        moving = true; self.state.direction = -1
    end
    if self.collider:enter('Danger') then
        self.collider:setPosition(self.startX,self.startY)
    end
    if self.state.grounded then
        self.animation = moving and self.animations.run or self.animations.idle
    else
        self.animation = self.animations.jump
    end
    self.animation:update(dt)
end

function Player:draw()
    local x,y = self.collider:getPosition()
    self.animation:draw(self.sprites.playerSheet, x, y, nil, 0.25*self.state.direction, 0.25, 130, 300)
end

function Player:jump(sounds)
    if self.state.grounded then
        self.collider:applyLinearImpulse(0,-4000)
        sounds.jump:play()
    end
end

function Player:cleanup()
    self.collider:destroy()
    for k in pairs(self) do self[k]=nil end
end

return Player