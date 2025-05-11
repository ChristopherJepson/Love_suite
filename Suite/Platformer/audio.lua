Audio = {}
Audio.__index = Audio

function Audio:init(jumpAudio, musicAudio)
    Audio.sounds = {}
    Audio.sounds.jump = jumpAudio
    Audio.sounds.music = musicAudio
    Audio.sounds.music:setLooping(true)
    Audio.sounds.music:setVolume(0.5)
end

function Audio:clear()
    for i in pairs(Audio.sounds) do
        Audio.sounds[i] = nil
    end
    for i in pairs(Audio) do
        Audio[1] = nil
    end
end

function Audio:addSounds(sounds)
    table.insert(Audio.sounds, sounds)
end

function Audio:removeSounds(sounds)
    table.remove(Audio.sounds, sounds)
end

