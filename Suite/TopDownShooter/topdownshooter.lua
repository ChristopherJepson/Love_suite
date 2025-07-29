-- TopDownShooter/topdownshooter.lua
local TopDownShooter = {}
TopDownShooter.__index = TopDownShooter

-- private helper for distance
local function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

-- Constructor
defaultModuleWidth = 895
function TopDownShooter.new()
    local self = setmetatable({}, TopDownShooter)
    -- player state
    self.player = {
        x = love.graphics.getWidth()  / 2,
        y = love.graphics.getHeight() / 2,
        speed        = 180,
        injured      = false,
        injuredSpeed = 270,
    }
    -- game entities
    self.zombies   = {}
    self.bullets   = {}
    -- game state vars
    self.gameState = 1 -- 1=waiting, 2=running
    self.score     = 0
    self.maxTime   = 2
    self.timer     = self.maxTime
    return self
end

-- Load assets & setup
function TopDownShooter:load()
    math.randomseed(os.time())
    love.window.setMode(defaultModuleWidth, defaultModuleWidth)

    -- sprite config
    local spriteConfig = require("TopDownShooter.config.sprite")
    self.sprites = {
        player     = love.graphics.newImage(spriteConfig.player[1]),
        zombie     = love.graphics.newImage(spriteConfig.zombie[1]),
        background = love.graphics.newImage(spriteConfig.background[1]),
        bullet     = love.graphics.newImage(spriteConfig.bullet[1]),
    }
    self.font = love.graphics.newFont(30)
end

function TopDownShooter:playerMouseAngle()
    return math.atan2(
        self.player.y - love.mouse.getY(),
        self.player.x - love.mouse.getX()
    ) + math.pi
end

function TopDownShooter:zombiePlayerAngle(z)
    return math.atan2(
        self.player.y - z.y,
        self.player.x - z.x
    )
end

function TopDownShooter:spawnZombie()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local z = { x = 0, y = 0, speed = 140, dead = false }
    local side = math.random(1, 4)
    if side == 1 then
        z.x, z.y = -30,             math.random(0, h)
    elseif side == 2 then
        z.x, z.y = w + 30,          math.random(0, h)
    elseif side == 3 then
        z.x, z.y = math.random(0, w), -30
    else
        z.x, z.y = math.random(0, w), h + 30
    end
    table.insert(self.zombies, z)
end

function TopDownShooter:spawnBullet()
    table.insert(self.bullets, {
        x         = self.player.x,
        y         = self.player.y,
        speed     = 500,
        dead      = false,
        direction = self:playerMouseAngle(),
    })
end

-- Update loop
function TopDownShooter:update(dt)
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local moveSpeed = self.player.injured and self.player.injuredSpeed or self.player.speed

    if self.gameState == 2 then
        if love.keyboard.isDown("d") and self.player.x < w then
            self.player.x = self.player.x + moveSpeed * dt
        end
        if love.keyboard.isDown("a") and self.player.x > 0 then
            self.player.x = self.player.x - moveSpeed * dt
        end
        if love.keyboard.isDown("w") and self.player.y > 0 then
            self.player.y = self.player.y - moveSpeed * dt
        end
        if love.keyboard.isDown("s") and self.player.y < h then
            self.player.y = self.player.y + moveSpeed * dt
        end
    end

    -- zombies movement and collisions
    for _, z in ipairs(self.zombies) do
        local ang = self:zombiePlayerAngle(z)
        z.x = z.x + math.cos(ang) * z.speed * dt
        z.y = z.y + math.sin(ang) * z.speed * dt
        if distanceBetween(z.x, z.y, self.player.x, self.player.y) < 30 then
            if not self.player.injured then
                self.player.injured = true
                z.dead = true
            else
                -- reset on second hit
                self.zombies = {}
                self.player.x, self.player.y = w/2, h/2
                self.player.injured = false
                self.gameState = 1
            end
        end
    end

    -- bullets movement
    for _, b in ipairs(self.bullets) do
        b.x = b.x + math.cos(b.direction) * b.speed * dt
        b.y = b.y + math.sin(b.direction) * b.speed * dt
    end

    -- remove off-screen bullets
    for i = #self.bullets, 1, -1 do
        local b = self.bullets[i]
        if b.x < 0 or b.y < 0 or b.x > w or b.y > h then
            table.remove(self.bullets, i)
        end
    end

    -- bullet-zombie collisions and cleanup
    for _, z in ipairs(self.zombies) do
        for _, b in ipairs(self.bullets) do
            if distanceBetween(z.x, z.y, b.x, b.y) < 20 then
                z.dead = true
                b.dead = true
                self.score = self.score + 1
            end
        end
    end
    for i = #self.zombies, 1, -1 do if self.zombies[i].dead then table.remove(self.zombies, i) end end
    for i = #self.bullets, 1, -1 do if self.bullets[i].dead then table.remove(self.bullets, i) end end

    -- spawn new zombies
    if self.gameState == 2 then
        self.timer = self.timer - dt
        if self.timer <= 0 then
            self:spawnZombie()
            self.maxTime = self.maxTime * 0.95
            self.timer   = self.maxTime
        end
    end
end

-- Draw loop
function TopDownShooter:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.draw(self.sprites.background, 0, 0)
    if self.gameState == 1 then
        love.graphics.setFont(self.font)
        love.graphics.printf("Click anywhere to begin!", 0, 50, w, "center")
    end
    love.graphics.printf("Score: "..self.score, 0, h - 100, w, "center")
    if self.player.injured then love.graphics.setColor(1, 0, 0) end
    love.graphics.draw(
        self.sprites.player,
        self.player.x, self.player.y,
        self:playerMouseAngle(), nil, nil,
        self.sprites.player:getWidth()/2,
        self.sprites.player:getHeight()/2
    )
    love.graphics.setColor(1,1,1)
    for _, z in ipairs(self.zombies) do
        love.graphics.draw(
            self.sprites.zombie, z.x, z.y,
            self:zombiePlayerAngle(z), nil, nil,
            self.sprites.zombie:getWidth()/2,
            self.sprites.zombie:getHeight()/2
        )
    end
    for _, b in ipairs(self.bullets) do
        love.graphics.draw(
            self.sprites.bullet,
            b.x, b.y, nil, 0.5, nil,
            self.sprites.bullet:getWidth()/2,
            self.sprites.bullet:getHeight()/2
        )
    end
end

-- Input handlers
function TopDownShooter:keypressed(key)
    if key == "space" then self:spawnZombie() end
end

function TopDownShooter:mousepressed(x, y, button)
    if button == 1 then
        if self.gameState == 2 then
            self:spawnBullet()
        else
            self.gameState = 2
            self.maxTime   = 2
            self.timer     = self.maxTime
            self.score     = 0
        end
    end
end

-- Cleanup for GC
function TopDownShooter:cleanup()
    for k in pairs(self) do self[k] = nil end
end

return TopDownShooter
