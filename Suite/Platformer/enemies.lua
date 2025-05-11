function instantiateEnemies()

    Enemies = {}
    Enemies.__index = Enemies

    function spawnEnemy(x, y)
        local enemy = Worlds.firstWorld:newRectangleCollider(x, y, 70, 90, {collision_class = 'Danger'})
        enemy.direction = 1
        enemy.speed = 200
        enemy.animation = Animations.animation.enemyRun
        table.insert(Enemies, enemy)
    end

    function updateEnemies(dt)
        for i,e in ipairs(Enemies) do
            e.animation:update(dt)
            local ex, ey = e:getPosition()

            local colliders = Worlds.firstWorld:queryRectangleArea(ex + (40 * e.direction), ey + 40, 10, 10, {'Platform'})
            if #colliders == 0 then
                e.direction = e.direction * -1
            end

            e:setX(ex + e.speed * dt * e.direction)
        end
    end

    function drawEnemies()
        for i,e in ipairs(Enemies) do
            local ex, ey = e:getPosition()
            e.animation:draw(sprites.enemySheet, ex, ey, nil, sprite.enemySheet.ratio * e.direction, sprite.enemySheet.ratio, sprite.enemySheet.x, sprite.enemySheet.y)
        end
    end

    function Enemies:garbageCollect()

        for i,e in ipairs(Enemies) do
            e.direction = nil
            e.speed = nil
            e.animation = nil
            e = nil
        end

        Enemies = nil
    end

end