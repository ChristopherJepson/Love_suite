function instantiatePlayers()
    Players = {
        player = {
            speed = {},
            animation = {},
            isMoving = {},
            direction = {},
            grounded = {}
        }
    }
    Players.__index = Players

    local startX = 320
    local startY = 100

    function Players:init()
        Players.player = Worlds.firstWorld:newRectangleCollider(Players:getStartX(), Players:getStartY(), 40, 100, {collision_class = 'Player'})
        Players.player:setFixedRotation(true)
        Players.player.speed = 240
        Players.player.animation = Animations.animation.idle
        Players.player.isMoving = false
        Players.player.direction = 1
        Players.player.grounded = true
    end
    
    function Players:clear()
        Players.player:destroy()
        Players.player.speed = {}
        Players.player.animation = {}
        Players.player.isMoving = {}
        Players.player.direction = {}
        Players.player.grounded = {}
    end
    
    function Players:garbageCollect()
        Players:clear()
        Players.player.speed = nil
        Players.player.animation = nil
        Players.player.isMoving = nil
        Players.player.direction = nil
        Players.player.grounded = nil
        Players.Player = nil
        Players = nil
    end
    
    function Players:playerUpdate(dt)
        if Players.player.body then
            local colliders = Worlds.firstWorld:queryRectangleArea(Players.player:getX() - 40, Players.player:getY() + 50, 40, 2, {'Platform'})
            if #colliders > 0 then
                Players.player.grounded = true
            else
                Players.player.grounded = false
            end
    
            Players.player.isMoving = false
            local px, py = Players.player:getPosition()
            if love.keyboard.isDown('right') then
                Players.player:setX(px + Players.player.speed*dt)
                Players.player.isMoving = true
                Players.player.direction = 1
            end
            if love.keyboard.isDown('left') then
                Players.player:setX(px - Players.player.speed*dt)
                Players.player.isMoving = true
                Players.player.direction = -1
            end
            if Players.player:enter('Danger') then
                Players.player:setPosition(Players:getStartX(), Players:getStartY())
            end
        end
        if Players.player.grounded then
            if Players.player.isMoving then
                Players.player.animation = Animations.animation.run
            else
                Players.player.animation = Animations.animation.idle
            end
            Players.player.animation:update(dt)
        else
            Players.player.animation = Animations.animation.jump
        end
    end
    
    function Players:drawPlayer()
        local px, py = Players.player:getPosition()
        Players.player.animation:draw(sprites.playerSheet, px, py, nil, sprite.playerSheet.ratio * Players.player.direction, sprite.playerSheet.ratio, sprite.playerSheet.x, sprite.playerSheet.y)
    end
    
    function Players:getStartX()
        return startX
    end
    
    function Players:getStartY()
        return startY
    end

end