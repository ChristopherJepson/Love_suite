-- Platformer/enemy.lua
local EnemyManager = {}
EnemyManager.__index = EnemyManager

function EnemyManager.new(world, animations, sprites)
    local self = setmetatable({}, EnemyManager)
    self.world      = world
    self.animations = animations
    self.sprites    = sprites
    self.enemies    = {}
    return self
end

function EnemyManager:spawn(x,y)
    local e = self.world:newRectangleCollider(x,y,70,90,{collision_class='Danger'})
    e.direction = 1
    e.speed     = 200
    e.animation = self.animations.enemy
    table.insert(self.enemies, e)
end

function EnemyManager:update(dt)
    for _,e in ipairs(self.enemies) do
        e.animation:update(dt)
        local ex,ey = e:getPosition()
        local cols = self.world:queryRectangleArea(ex + 40*e.direction, ey+40,10,10,{'Platform'})
        if #cols==0 then e.direction = -e.direction end
        e:setX(ex + e.speed*dt*e.direction)
    end
end

function EnemyManager:draw()
    for _,e in ipairs(self.enemies) do
        local ex,ey = e:getPosition()
        e.animation:draw(self.sprites.enemySheet, ex, ey, nil, e.direction, 1, 50, 65)
    end
end

function EnemyManager:cleanup()
    for _,e in ipairs(self.enemies) do e:destroy() end
    self.enemies = {}
end

return EnemyManager
