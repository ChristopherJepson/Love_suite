function instantiateAnimations()
    Animations = {
        animation = {
            idle = nil,
            jump = nil,
            run = nil,
            enemy = nil,
        }
    }
    Animations.__index = Animations

    function Animations:init(anim8)
        
        local playerGrid = anim8.newGrid(sprite.playerSheet.gridX, sprite.playerSheet.gridY, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())
        local enemyGrid = anim8.newGrid(sprite.enemySheet.gridX, sprite.enemySheet.gridY, sprites.enemySheet:getWidth(), sprites.enemySheet:getHeight())

        Animations.animation.idle = anim8.newAnimation(playerGrid(sprite.playerSheet.idle.range, sprite.playerSheet.idle.row), sprite.playerSheet.idle.frameSpeed)
        Animations.animation.jump = anim8.newAnimation(playerGrid(sprite.playerSheet.jump.range, sprite.playerSheet.jump.row), sprite.playerSheet.jump.frameSpeed)
        Animations.animation.run = anim8.newAnimation(playerGrid(sprite.playerSheet.run.range, sprite.playerSheet.run.row), sprite.playerSheet.run.frameSpeed)
        Animations.animation.enemyRun = anim8.newAnimation(enemyGrid(sprite.enemySheet.run.range, sprite.enemySheet.run.row), sprite.enemySheet.run.frameSpeed)
    end

    function Animations:garbageCollect()
        Animations.animation.idle = nil
        Animations.animation.jump = nil
        Animations.animation.run = nil
        Animations.animation.enemyRun = nil
        Animations.animation = nil
        Animations = nil
    end

    function Animations:addAnimationSounds(animation)
        table.insert(Animations.animation, animation)
    end

    function Animations:removeAnimation(animation)
        table.remove(Animations.animation, animation)
    end
end
