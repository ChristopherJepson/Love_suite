function instantiateWorlds()

    Worlds = {
        firstWorld = {}
    }
    Worlds.__index = Worlds

    function Worlds:init(wf)
        local wf = wf
        Worlds.firstWorld = wf.newWorld(0, 800, false)
        Worlds.firstWorld:setQueryDebugDrawing(true)
        Worlds.firstWorld:addCollisionClass('Platform')
        Worlds.firstWorld:addCollisionClass('Player')
        Worlds.firstWorld:addCollisionClass('Danger')
    end

    function Worlds:clear()
        Worlds:destroyAll()
        Worlds.firstWorld = {}
    end

    function Worlds:garbageCollect()
        Worlds.firstWorld = nil
        Worlds = nil
    end

    function Worlds:addWorld(world)
        table.insert(Worlds.world, world)
    end

    function Worlds:destroyAll()
        local i = #platforms
        while i > -1 do
            if platforms[i] ~= nil then
                platforms[i]:destroy()
            end
            table.remove(platforms, i)
            i = i - 1
        end
        local i = #Enemies
        while i > -1 do
            if Enemies[i] ~= nil then
                Enemies[i]:destroy()
            end
            table.remove(Enemies, i)
            i = i - 1
        end
    end

    function Worlds:spawnPlatform(x, y, width, height)
        if width > 0 and height > 0 then
            local platform = Worlds.firstWorld:newRectangleCollider(x, y, width, height, {collision_class = 'Platform'})
            platform:setType('static')
            table.insert(platforms, platform)
        end
    end
end