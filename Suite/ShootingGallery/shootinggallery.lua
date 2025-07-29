-- ShootingGallery/shootinggallery.lua
local ShootingGallery = {}
ShootingGallery.__index = ShootingGallery

-- Helper for distance calculation
local function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

-- Constructor
function ShootingGallery.new()
    local self = setmetatable({}, ShootingGallery)
    return self
end

-- Load assets and initial state
function ShootingGallery:load()
    love.window.setMode(800, 600)
    math.randomseed(os.time())

    -- Game state
    self.target = { x = 300, y = 300, radius = 50 }
    self.score  = 0
    self.timer  = 0
    self.gameState = 1  -- 1 = start screen, 2 = playing

    -- Fonts and sprites
    self.gameFont = love.graphics.newFont(40)
    self.sprites = {
        sky        = love.graphics.newImage('ShootingGallery/sprites/sky.png'),
        target     = love.graphics.newImage('ShootingGallery/sprites/target.png'),
        crosshairs = love.graphics.newImage('ShootingGallery/sprites/crosshairs.png'),
    }

    love.mouse.setVisible(false)
end

-- Update timer
function ShootingGallery:update(dt)
    if self.timer > 0 then
        self.timer = self.timer - dt
        if self.timer <= 0 then
            self.timer = 0
            self.gameState = 1
        end
    end
end

-- Draw game elements
function ShootingGallery:draw()
    -- Background
    love.graphics.draw(self.sprites.sky, 0, 0)

    -- UI
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(self.gameFont)
    love.graphics.print("Score: " .. self.score, 5, 5)
    love.graphics.print("Time: " .. math.ceil(self.timer), 300, 5)

    -- Start screen
    if self.gameState == 1 then
        love.graphics.printf(
            "Click anywhere to begin!",
            0, 250,
            love.graphics.getWidth(),
            "center"
        )
    -- Target
    elseif self.gameState == 2 then
        local t = self.target
        love.graphics.draw(
            self.sprites.target,
            t.x - t.radius,
            t.y - t.radius
        )
    end

    -- Crosshairs follow mouse
    local mx, my = love.mouse.getPosition()
    love.graphics.draw(
        self.sprites.crosshairs,
        mx - 20,
        my - 20
    )
end

-- Handle mouse clicks
function ShootingGallery:mousepressed(x, y, button)
    if button ~= 1 then return end

    if self.gameState == 2 then
        if distanceBetween(x, y, self.target.x, self.target.y) < self.target.radius then
            self.score = self.score + 1
            local r = self.target.radius
            self.target.x = math.random(r, love.graphics.getWidth() - r)
            self.target.y = math.random(r, love.graphics.getHeight() - r)
        end
    elseif self.gameState == 1 then
        self.gameState = 2
        self.timer     = 10
        self.score     = 0
    end
end

-- Clean up for GC
function ShootingGallery:cleanup()
    for k in pairs(self) do
        self[k] = nil
    end
end

return ShootingGallery
