function getImage(key)
    local key = key .. ".png"
    local img = love.graphics.newImage(key)
    return img
end
function getSparrow(key)
    local ip, xp = key, key .. ".xml"
    local i = getImage(ip)
    if love.filesystem.getInfo(xp) then
        local o = Sprite.getFramesFromSparrow(i, love.filesystem.read(xp))
        return o
    end
    print("No sparrow file found for " .. key)
    return nil
end

tweentags = {}

function doTweenX(tag, thing, pos, time, ease)
    if tweentags[tag] then
        Timer.cancel(tweentags[tag])
    end
    tweentags[tag] = Timer.tween(time, thing, {x = pos}, ease)
end

util = {
endsWith = function(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end,
startsWith = function(str, start)
    return str:sub(1, #start) == start
end,
}

function doCamStatic()
    if camstatictimer then
        Timer.cancel(camstatictimer)
    end
    static.alpha = 1
    camstatictimer = Timer.tween(0.5, static, {alpha=0.2}, "linear")
end

local camera = 1
local power = 101
local powerDrain = true
local bonniePos = 8
local chicaPos = 0
local foxyTime = 210
local origFoxyTime = 180
local foxyAttacking = false
local leftLight = false
local rightLight = false
local leftDoor = false
local rightDoor = false
local canUseLeftDoor = true
local canUseRightDoor = true
local canUseLeftLight = true
local canUseRightLight = true
local canUseCams = true
local canHonk = true
local inCams = false
local cam1Volume = 0.3
local cam2Volume = 0.3
local cam3Volume = 0.3
local cam4Volume = 0.3
local cam5Volume = 0.3
local cam6Volume = 0.3
local cam7Volume = 0.3
local cam8Volume = 0.3
local cam9Volume = 0.3
local cam10Volume = 0.3
local cam11Volume = 0.3
local officeMoving = false
local officeVolume = 1
local minBonTime = 30
local maxBonTime = 60
local minChicaTime = 45
local maxChicaTime = 70
local goldenChance = 100
local goldenSecret = false
local hasSeenGold = false
local kitchenVolume = 0
local time = 0
local globalUsage = 1
local leftDoorUsage = 0
local rightDoorUsage = 0
local leftLightUsage = 0
local rightLightUsage = 0
local camsUsage = 0
local canMute = false
local freddyMin = 30
local freddyMax = 75
local outOfPower = false
local phoneSecret = 0
local secretsPhone = false
local beenScared = false

local curcam = "stage"

function runTimer(tag, time)
    Timer.after(time, function()
        onTimerCompleted(tag, 1, 0)
    end)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'camsright' then
        -- tween em all to 0!!!!!!
        doTweenX('stagecam', stagecam, 0, 3, 'linear')
        doTweenX('diningroomcam', diningroomcam, 0, 3, 'linear')
        doTweenX('piratecovecam', piratecovecam, 0, 3, 'linear')
        doTweenX('lefthallcam', lefthallcam, 0, 3, 'linear')
        doTweenX('leftcornercam', leftcornercam, 0, 3, 'linear')
        doTweenX('closetcam', closetcam, 0, 3, 'linear')
        doTweenX('righthallcam', righthallcam, 0, 3, 'linear')
        doTweenX('rightcornercam', rightcornercam, 0, 3, 'linear')
        doTweenX('backstagecam', backstagecam, 0, 3, 'linear')
        doTweenX('bathroomcam', bathroomcam, 0, 3, 'linear')
        runTimer('camsleft', 5)
    elseif tag == 'camsleft' then
        -- tween em all to 300!!!!!!! 
        doTweenX('stagecam', stagecam, -300, 3, 'linear')
        doTweenX('diningroomcam', diningroomcam, -300, 3, 'linear')
        doTweenX('piratecovecam', piratecovecam, -300, 3, 'linear')
        doTweenX('lefthallcam', lefthallcam, -300, 3, 'linear')
        doTweenX('leftcornercam', leftcornercam, -300, 3, 'linear')
        doTweenX('closetcam', closetcam, -300, 3, 'linear')
        doTweenX('righthallcam', righthallcam, -300, 3, 'linear')
        doTweenX('rightcornercam', rightcornercam, -300, 3, 'linear')
        doTweenX('backstagecam', backstagecam, -300, 3, 'linear')
        doTweenX('bathroomcam', bathroomcam, -300, 3, 'linear')
        runTimer('camsright', 5)
    end

    if tag == 'camsuse' then
        showcamshit = true
        officeVolume = 0.5
        static:animate('static')
        doCamStatic()
    end

    if tag == "bonniemove" then
        bonniePos = bonniePos + 1

        if bonniePos == 5 or bonniePos == 6 or bonniePos == 7 then
            runTimer("bonniemove", love.math.random(minBonTime/3, maxBonTime/3))
        elseif bonniePos == 8 then
            runTimer("bonniemove", love.math.random(minBonTime/2, maxBonTime/2))
        else
            runTimer("bonniemove", love.math.random(minBonTime, maxBonTime))
        end

        if inCams then
            local bp = bonniePos
 -- first is xy, second is x2y2
            -- cam1 912, 321 - 960, 352 stage
            -- cam2 896, 385 - 944, 413 dining
            -- cam3 849, 460 - 899, 492 foxy
            -- cam4 908, 578 - 960, 617 lefthall
            -- cam5 909, 617 - 957, 654 leftcorner
            -- cam6 833, 551 - 882, 582 closet
            -- cam7 999, 585 - 1048, 616 righthall
            -- cam8 999, 624 - 1048, 655 rightcorner
            -- cam9 800, 410 - 850, 442 backroom
            -- cam10 1121, 536 - 1170, 567 kitchen
            -- cam11 1120, 399 - 1169, 430 bathroom
            if bp == 1 then
                if curcam == "stage" or curcam == "dining" then
                    doCamStatic()
                end
            elseif bp == 2 then
                if curcam == "dining" then
                    doCamStatic()
                end
            elseif bp == 3 then
                if curcam == "dining" or curcam == "lefthall" then
                    doCamStatic()
                end
            elseif bp == 4 then
                if curcam == "lefthall" or curcam == "closet" then
                    doCamStatic()
                end
            elseif bp == 5 then
                if curcam == "closet" or curcam == "leftcorner" then
                    doCamStatic()
                end
            elseif bp == 6 or bp == 7 or bp == 8 then
                if curcam == "leftcorner" then
                    doCamStatic()
                end
            end
        end
    elseif tag == "chicamove" then
        chicaPos = chicaPos + 1
        
        if chicaPos == 6 or chicaPos == 7 or chicaPos == 8 then
            runTimer("chicamove", love.math.random(minChicaTime/3, maxChicaTime/3))
        elseif chicaPos == 9 then
            runTimer("chicamove", love.math.random(minChicaTime/2, maxChicaTime/2))
        else
            runTimer("chicamove", love.math.random(minChicaTime, maxChicaTime))
        end
    elseif tag == "foxyadvance" then
    end

    if tag == 'gameover' then
        -- close the game
        love.event.quit()
    end
end

function love.load()
    -- load libs
    Object = require "lib.classic"
    Timer = require "lib.timer"
    xml = require "lib.xml".parse

    -- load modules
    Sprite = require "modules.Sprite"

    -- Sprites --

    -- office image stuffs
    office = Sprite()
    office:setFrames(getSparrow("assets/office/office"))
    office:addAnimByPrefix('default', "normal", 1, false)
    office:addAnimByPrefix('leftlight', "llight", 1, false)
    office:addAnimByPrefix('rightlight', "rlight", 1, false)
    office:addAnimByPrefix('leftbonnie', "bonishere", 1, false)
    office:addAnimByPrefix('rightchica', "chicishere", 1, false)
    office:addAnimByPrefix('powerdown', 'powerout', 1, false)
    office:addAnimByPrefix('freddysing', 'urdead', 1, false)

    leftpanel = Sprite()
    leftpanel:setFrames(getSparrow("assets/office/leftdoorpanel"))
    leftpanel:addAnimByPrefix('none', "none", 1, false)
    leftpanel:addAnimByPrefix('door', "door", 1, false)
    leftpanel:addAnimByPrefix('light', "light", 1, false)
    leftpanel:addAnimByPrefix('both', "both", 1, false)

    leftpanel.y = 300
    leftpanel:animate('none')

    rightpanel = Sprite()
    rightpanel:setFrames(getSparrow("assets/office/rightdoorpanel"))
    rightpanel:addAnimByPrefix('none', "none", 1, false)
    rightpanel:addAnimByPrefix('door', "door", 1, false)
    rightpanel:addAnimByPrefix('light', "light", 1, false)  
    rightpanel:addAnimByPrefix('both', "both", 1, false)

    rightpanel.y = 300
    rightpanel.x = 1500
    rightpanel:animate('none')

    leftdoors = Sprite()
    leftdoors:setFrames(getSparrow("assets/office/leftdoor"))
    leftdoors:addAnimByPrefix('close', 'door', 24, false)
    leftdoors:addAnimByIndices('open', 'door', {10, 9,8,7,6,5,4,3,2,1,0}, 24, false)
    leftdoors:addAnimByIndices('default', 'door', {0}, 1, false)

    leftdoors.x = 60
    leftdoors:animate('default')

    rightdoors = Sprite()
    rightdoors:setFrames(getSparrow("assets/office/rightdoor"))
    rightdoors:addAnimByPrefix('close', 'door', 24, false)
    rightdoors:addAnimByIndices('open', 'door', {13,12,11,10,9,8,7,6,5,4,3,2,1,0}, 24, false)
    rightdoors:addAnimByIndices('default', 'door', {0}, 1, false)

    rightdoors.x = 1275
    rightdoors:animate('default')

    bonniejump = Sprite()
    bonniejump:setFrames(getSparrow("assets/office/bonniejump"))
    bonniejump:addAnimByPrefix('jumpscare', "stubbingyourtoebelike", 36, true)

    -- cams image stuffs
    cambutton = Sprite()
    cambutton:load("assets/cams/cambutton.png")
    cambutton.x = 325
    cambutton.y = 670

    cameraflip = Sprite()
    cameraflip:setFrames(getSparrow("assets/cams/cameraflip"))
    cameraflip:addAnimByPrefix('flipup', "monitorflip", 24, false)
    cameraflip:addAnimByIndices('flipdown', "monitorflip", {9,8,7,6,5,4,3,2,1,0}, 24, false)
    cameraflip:addAnimByIndices('off', "monitorflip", {0}, 1, false)

    stagecam = Sprite()
    stagecam:setFrames(getSparrow("assets/cams/stagecam"))
    stagecam:addAnimByPrefix('normal', "theboys", 1, false)
    stagecam:addAnimByPrefix('secret1', "uhoh", 1, false)
    stagecam:addAnimByPrefix('chicaleave', "chicgone", 1, false)
    stagecam:addAnimByPrefix('bonnieleave', "bongone", 1, false)
    stagecam:addAnimByPrefix('bothleave', "bothgone", 1, false)
    stagecam:addAnimByPrefix('secret2', "feddysus", 1, false)
    stagecam:addAnimByPrefix('allgone', "allgone", 1, false)

    diningroomcam = Sprite()
    diningroomcam:setFrames(getSparrow("assets/cams/diningroomcam"))
    diningroomcam:addAnimByPrefix('normal', "normal", 1, false)
    diningroomcam:addAnimByPrefix('bonniefar', "bonfar", 1, false)
    diningroomcam:addAnimByPrefix('bonnieclose', "bonclose", 1, false)
    diningroomcam:addAnimByPrefix('chicafar', "chicafar", 1, false)
    diningroomcam:addAnimByPrefix('chicaclose', "chicclose", 1, false)
    diningroomcam:addAnimByPrefix('freddy', "feddy", 1, false)

    piratecovecam = Sprite()
    piratecovecam:setFrames(getSparrow("assets/cams/piratecovecam"))
    piratecovecam:addAnimByPrefix('normal', "foxchillin", 1, false)
    piratecovecam:addAnimByPrefix('stage1', "peekaboo", 1, false)
    piratecovecam:addAnimByPrefix('stage2', "almostout", 1, false)
    piratecovecam:addAnimByPrefix('gone', "foxygone", 1, false)

    lefthallcam = Sprite()
    lefthallcam:setFrames(getSparrow("assets/cams/lefthallcam"))
    lefthallcam:addAnimByPrefix('normal', "normal", 1, false)
    lefthallcam:addAnimByPrefix('bonnie', "yourpizzaishere", 1, false)
    lefthallcam:addAnimByPrefix('secret1', 'lightoff', 1, false)
    lefthallcam:addAnimByPrefix('foxyrun', 'foxycharge', 24, false)

    leftcornercam = Sprite()
    leftcornercam:setFrames(getSparrow("assets/cams/leftcornercam"))
    leftcornercam:addAnimByPrefix('normal', "normal", 1, false)
    leftcornercam:addAnimByPrefix('bonnie1', "2bon", 1, false)
    leftcornercam:addAnimByPrefix('bonnie2', "bon", 1, false)
    leftcornercam:addAnimByPrefix('bonnie3', "gonnageturassbon", 1, false)
    leftcornercam:addAnimByPrefix('secret1', 'gfeddy', 1, false)
    leftcornercam:addAnimByPrefix('secret2', 'ouchfeddy', 1, false)

    rightcornercam = Sprite()
    rightcornercam:setFrames(getSparrow("assets/cams/rightcornercam"))
    rightcornercam:addAnimByPrefix('normal', "normal", 1, false)
    rightcornercam:addAnimByPrefix('chica1', "chicken", 1, false)
    rightcornercam:addAnimByPrefix('chica2', "bruhchicken", 1, false)
    rightcornercam:addAnimByPrefix('chica3', "angychicken", 1, false)
    rightcornercam:addAnimByPrefix('freddy', "feddyfaber", 1, false)
    rightcornercam:addAnimByPrefix('secret1', "kidssecret", 1, false)
    rightcornercam:addAnimByPrefix('secret2', "shutdownsecret", 1, false)
    rightcornercam:addAnimByPrefix('secret3', "missingsecret", 1, false)
    rightcornercam:addAnimByPrefix('secret4', "closesecret", 1, false)

    closetcam = Sprite()
    closetcam:setFrames(getSparrow("assets/cams/closetcam"))
    closetcam:addAnimByPrefix('normal', "nobonnie", 1, false)
    closetcam:addAnimByPrefix('bonnie', "bonnie", 1, false)

    righthallcam = Sprite()
    righthallcam:setFrames(getSparrow("assets/cams/righthallcam"))
    righthallcam:addAnimByPrefix('normal', "normal", 1, false)
    righthallcam:addAnimByPrefix('chica1', "chickenfar", 1, false)
    righthallcam:addAnimByPrefix('chica2', "chicaclose", 1, false)
    righthallcam:addAnimByPrefix('freddy', "feddy", 1, false)
    righthallcam:addAnimByPrefix('secret1', "cryingkids", 1, false)
    righthallcam:addAnimByPrefix('secret2', "itsme", 1, false)

    backstagecam = Sprite()
    backstagecam:setFrames(getSparrow("assets/cams/backstagecam"))
    backstagecam:addAnimByPrefix('normal', "normal", 1, false)
    backstagecam:addAnimByPrefix('bonnie1', "bonnie", 1, false)
    backstagecam:addAnimByPrefix('bonnie2', "inmygrill", 1, false)
    backstagecam:addAnimByPrefix('secret1', "theystarin", 1, false)
    backstagecam:addAnimByPrefix('secret2', "dedfeddy", 1, false)

    bathroomcam = Sprite()
    bathroomcam:setFrames(getSparrow("assets/cams/bathroomcam"))
    bathroomcam:addAnimByPrefix('normal', "normal", 1, false)
    bathroomcam:addAnimByPrefix('chica1', "awildchicaappeared", 1, false)
    bathroomcam:addAnimByPrefix('chica2', "excuseme", 1, false)
    bathroomcam:addAnimByPrefix('freddy', "feddyinthegirlsroom", 1, false)

    map = Sprite()
    map:setFrames(getSparrow("assets/cams/map"))
    map:addAnimByPrefix('stage', "stage", 1, false)
    map:addAnimByPrefix('dining', "diningroom", 1, false)
    map:addAnimByPrefix('piratecove', "foxycove", 1, false)
    map:addAnimByPrefix('lefthall', "lefthall", 1, false)
    map:addAnimByPrefix('leftcorner', "leftcorner", 1, false)
    map:addAnimByPrefix('closet', "closet", 1, false)
    map:addAnimByPrefix('righthall', "righthall", 1, false)
    map:addAnimByPrefix('rightcorner', "rightcorner", 1, false)
    map:addAnimByPrefix('backroom', "backroom", 1, false)
    map:addAnimByPrefix('kitchen', "kitchen", 1, false)
    map:addAnimByPrefix('bathroom', "bathrooms", 1, false)

    map.x, map.y = 800, 300

    stagecam:animate('normal')
    diningroomcam:animate('normal')
    backstagecam:animate('normal')
    bathroomcam:animate('normal')
    lefthallcam:animate('normal')
    leftcornercam:animate('normal')
    rightcornercam:animate('normal')
    righthallcam:animate('normal')
    closetcam:animate('normal')
    piratecovecam:animate('normal')
    map:animate('cam1')

    cameraflip:animate('off')

    static = Sprite()
    static:setFrames(getSparrow("assets/cams/static"))
    static:addAnimByPrefix('static', "statik", 24, true)
    static:addAnimByPrefix('glitch', "glitchy", 24, true)
    static.alpha = 0

    secretSprite = Sprite()
    secretSprite:load("assets/secrets/secret" .. love.math.random(1,6) .. ".png")

    muteButton = Sprite()
    muteButton:load("assets/office/mutebutton.png")
    muteButton.x = 10
    muteButton.y = 10
    
    -- Audios --
    phonecall = love.audio.newSource("sounds/phonecall.ogg", "static")
    fan = love.audio.newSource("sounds/fan.ogg", "static")
    fan:setLooping(true)
    fan:setVolume(0.4 * officeVolume)

    light = love.audio.newSource("sounds/lights.ogg", "static")
    light:setLooping(true)
    door = love.audio.newSource("sounds/door.ogg", "static")

    ambience = love.audio.newSource("sounds/ambience" .. love.math.random(1,3) .. ".ogg", "static")
    ambience:setLooping(true)
    ambience:setVolume(0.8)

    camloop = love.audio.newSource("sounds/camloop.ogg", "static")
    camloop:setLooping(true)

    camenter = love.audio.newSource("sounds/camenter.ogg", "static")
    camleave = love.audio.newSource("sounds/camleave.ogg", "static")
    camselect = love.audio.newSource("sounds/camselect.ogg", "static")
    windowscare = love.audio.newSource("sounds/windowscare.ogg", "static")
    jumpscare = love.audio.newSource("sounds/jumpscare.ogg", "static")

    office:animate('default')

    warpshader = love.graphics.newShader [[
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
        {
            return Texel(texture, vec2(texture_coords.x, texture_coords.y));
        }
    ]]

    love.window.setMode(1280, 720)

    Timer.after(0.1, function()
        phonecall:play()
        canMute = true
    end)
    fan:play()
    ambience:play()

    runTimer('bonniemove', love.math.random(minBonTime, maxBonTime))
    runTimer('foxyadvance', 1, 0)
    runTimer('chicamove', love.math.random(minChicaTime, maxChicaTime))

    runTimer('clockupdate', 90, 0)
    runTimer('camsleft', 5)

    officeCanvas = love.graphics.newCanvas(1280, 720)
end

officeOffset = 0

function love.update(dt)
    Timer.update(dt)
    local mx, my = love.mouse.getPosition()

    -- update sprites
    office:update(dt)
    leftpanel:update(dt)
    rightpanel:update(dt)
    leftdoors:update(dt)
    rightdoors:update(dt)
    cameraflip:update(dt)
    cambutton:update(dt)
    muteButton:update(dt)
    static:update(dt)
    map:update(dt)
    bonniejump:update(dt)
    --chicajump:update(dt)

    if not inCams then
        if mx < 540 then
            officeOffset = officeOffset - 400 * dt
        elseif mx > 740 then
            officeOffset = officeOffset + 400 * dt
        end
    end

    if officeOffset < 0 then officeOffset = 0 end
    if officeOffset > 280 then officeOffset = 280 end
    office.offset.x = officeOffset
    leftpanel.offset.x = officeOffset
    rightpanel.offset.x = officeOffset
    leftdoors.offset.x = officeOffset
    rightdoors.offset.x = officeOffset

    if powerDrain then
        power = power - 0.001 * globalUsage * dt
    end

    -- left panel stuffs
    if leftdoor and not leftlight then
        leftpanel:animate('door')
    elseif leftlight and not leftdoor then
        leftpanel:animate('light')
    elseif leftdoor and leftlight then
        leftpanel:animate('both')
    else
        leftpanel:animate('none')
    end

    -- office light stuff
    if leftlight then
        if bonniePos < 8 then
            office:animate('leftlight')
        elseif bonniePos >= 8 then
            office:animate('leftbonnie')
        end
    elseif rightlight then
        if chicaPos < 9 then
            office:animate('rightlight')
        elseif chicaPos >= 9 then
            office:animate('rightchica')
        end
    else
        office:animate('default')
    end

    if leftlight or rightlight then
        if not light:isPlaying() then
            light:play()
        end
    else
        light:stop()
    end

    -- office door stuff
    if not leftdoor and leftdoors:getAnimName() ~= 'open' and leftdoors:getAnimName() ~= 'default' then
        leftdoors:animate('open')
    elseif leftdoor and leftdoors:getAnimName() ~= 'close' then
        leftdoors:animate('close')
    end

    -- right panel stuffs
    if rightdoor and not rightlight then
        rightpanel:animate('door')
    elseif rightlight and not rightdoor then
        rightpanel:animate('light')
    elseif rightdoor and rightlight then
        rightpanel:animate('both')
    else
        rightpanel:animate('none')
    end

    -- right door stuff
    if not rightdoor and rightdoors:getAnimName() ~= 'open' and rightdoors:getAnimName() ~= 'default' then
        rightdoors:animate('open')
    elseif rightdoor and rightdoors:getAnimName() ~= 'close' then
        rightdoors:animate('close')
        door:play()
    end

    fan:setVolume(0.4 * officeVolume)
    light:setVolume(1 * officeVolume)
    door:setVolume(1 * officeVolume)

    -- check if mouse is at camera button
    if mx > cambutton.x and mx < cambutton.x + 630 and my > cambutton.y and my < cambutton.y + 50 and not beenJumpscared then
        if canUseCams then
            if cameraflip:getAnimName() == 'flipdown' or cameraflip:getAnimName() == 'off' then
                cameraflip:animate('flipup')
                runTimer('camsuse', 0.35)
                camenter:stop()
                camenter:play()
                camloop:play()
            elseif cameraflip:getAnimName() == 'flipup' then
                cameraflip:animate('flipdown')
                camleave:play()
                camloop:stop()
            end
            canUseCams = false
            inCams = not inCams
            officeVolume = 0.5
        else
            showcamshit = false
            officeVolume = 1
        end
    else
        canUseCams = true
    end

    if cameraflip:getAnimName() == 'flipdown' and not cameraflip:isAnimated() then
        cameraflip:animate('off')
    end

    -- cam character moving stuffs
    local bp, cp = bonniePos, chicaPos

    if bp == 0 and cp == 0 then
        stagecam:animate("normal")
    elseif bp > 0 and cp == 0 then
        stagecam:animate("bonnieleave")
    elseif bp == 0 and cp > 0 then
        stagecam:animate("chicaleave")
    elseif bp > 0 and cp > 0 then
        stagecam:animate("bothleave")
    end

    if bp == 1 then
        diningroomcam:animate("bonniefar")
    elseif bp == 2 then
        diningroomcam:animate("bonnieclose")
    else
        diningroomcam:animate("normal")
    end

    if not foxyAttacking then
        if bp == 3 then
            lefthallcam:animate("bonnie")
        else
            lefthallcam:animate("normal")
        end
    end

    if bp == 4 then
        closetcam:animate("bonnie")
    else
        closetcam:animate("normal")
    end

    if bp == 5 then 
        leftcornercam:animate("bonnie1")
    elseif bp == 6 then
        leftcornercam:animate("bonnie2")
    elseif bp == 7 then
        leftcornercam:animate("bonnie3")
    else
        leftcornercam:animate("normal")
    end

    if cp == 1 then
        bathroomcam:animate("chica1")
    elseif cp == 2 then
        bathroomcam:animate("chica2")
    else
        bathroomcam:animate("normal")
    end

    if cp == 3 then
        kitchenVolume = 1
    else
        kitchenVolume = 0
    end

    if cp == 4 then
        righthallcam:animate('chica1')
    elseif cp == 5 then
        righthallcam:animate('chica2')
    else
        righthallcam:animate('normal')
    end

    if cp == 6 then
        rightcornercam:animate('chica1')
    elseif cp == 7 then
        rightcornercam:animate('chica2')
    elseif cp == 8 then
        rightcornercam:animate('chica3')
    else
        rightcornercam:animate('normal')
    end

    -- window scare stuffs

    if bonniePos == 8 and leftlight and not beenScared then
        beenScared = true
        windowscare:play()
    elseif chicaPos == 9 and rightlight and not beenScared then
        beenScared = true
        windowscare:play()
    end

    if bp == 9 then
        if not leftDoor then
            if not beenJumpscared then
                if inCams then
                    -- close cams and jumpscare
                    cameraflip:animate('flipdown')
                    camleave:play()
                    camloop:stop()
                    inCams = false
                    showcamshit = false
                end
                phonecall:stop()
                fan:stop()
                ambience:stop()
                light:stop()
                leftlight = false
                rightlight = false

                runTimer('gameover', 5)
                jumpscare:play()

                bonniejump:animate("jumpscare")

                beenJumpscared = true
            end
        else

        end
    end
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        -- mute button
        if canMute then
            if x > muteButton.x and x < muteButton.x + 121 and y > muteButton.y and y < muteButton.y + 31 then
                phonecall:stop()
                canMute = false
            end
        end

        ------ doors ------

        -- left door --
        -- light
        if leftpanel.x + leftpanel.offset.x + 12 < x and leftpanel.x + leftpanel.offset.x + 12 + 44 > x
            and leftpanel.y + 88 < y and leftpanel.y + 88 + 58 > y then
                leftlight = not leftlight
                rightlight = false
        end
        -- door
        if leftpanel.x + leftpanel.offset.x + 12 < x and leftpanel.x + leftpanel.offset.x + 12 + 44 > x
            and leftpanel.y + 12 < y and leftpanel.y + 12 + 58 > y 
            and not leftdoors:isAnimated() then
                leftdoor = not leftdoor
                door:stop()
                door:play()
        end

        -- right door --
        -- light
        if rightpanel.x - rightpanel.offset.x + 4 < x and rightpanel.x - rightpanel.offset.x + 4 + 44 > x
            and rightpanel.y + 88 < y and rightpanel.y + 88 + 58 > y then
                rightlight = not rightlight
                leftlight = false
        end
        -- door
        if rightpanel.x - rightpanel.offset.x + 4 < x and rightpanel.x - rightpanel.offset.x + 4 + 44 > x
            and rightpanel.y + 12 < y and rightpanel.y + 12 + 58 > y 
            and not rightdoors:isAnimated() then
                rightdoor = not rightdoor
                door:stop()
                door:play()
        end

        if inCams and showcamshit then
            -- first is xy, second is x2y2
            -- cam1 912, 321 - 960, 352 stage
            -- cam2 896, 385 - 944, 413 dining
            -- cam3 849, 460 - 899, 492 foxy
            -- cam4 908, 578 - 960, 617 lefthall
            -- cam5 909, 617 - 957, 654 leftcorner
            -- cam6 833, 551 - 882, 582 closet
            -- cam7 999, 585 - 1048, 616 righthall
            -- cam8 999, 624 - 1048, 655 rightcorner
            -- cam9 800, 410 - 850, 442 backroom
            -- cam10 1121, 536 - 1170, 567 kitchen
            -- cam11 1120, 399 - 1169, 430 bathroom
            
            if x > 912 and x < 960 and y > 321 and y < 352 then
                curcam = "stage"
                doCamStatic()
                camselect:stop()
                camselect:play()
            elseif x > 896 and x < 944 and y > 385 and y < 413 then
                curcam = "dining"
                doCamStatic()
                camselect:stop()
                camselect:play()
            elseif x > 849 and x < 899 and y > 460 and y < 492 then
                curcam = "piratecove"
                doCamStatic()
                camselect:stop()
                camselect:play()
            elseif x > 908 and x < 960 and y > 578 and y < 617 then
                curcam = "lefthall"
                doCamStatic()
                camselect:stop()
                camselect:play()
            elseif x > 909 and x < 957 and y > 617 and y < 654 then
                curcam = "leftcorner"
                doCamStatic()
                camselect:stop()
                camselect:play()
            elseif x > 833 and x < 882 and y > 551 and y < 582 then
                curcam = "closet"
                doCamStatic()
                camselect:stop()
                camselect:play()
            elseif x > 999 and x < 1048 and y > 585 and y < 616 then
                curcam = "righthall"
                doCamStatic()
                camselect:stop()
                camselect:play()
            elseif x > 999 and x < 1048 and y > 624 and y < 655 then
                curcam = "rightcorner"
                doCamStatic()
                camselect:stop()
                camselect:play()
            elseif x > 800 and x < 850 and y > 410 and y < 442 then
                curcam = "backroom"
                doCamStatic()
                camselect:stop()
                camselect:play()
            elseif x > 1121 and x < 1170 and y > 536 and y < 567 then
                curcam = "kitchen"
                doCamStatic()
                camselect:stop()
                camselect:play()
            elseif x > 1120 and x < 1169 and y > 399 and y < 430 then
                curcam = "bathroom"
                doCamStatic()
                camselect:stop()
                camselect:play()
            end

            map:animate(curcam)
        end
    end

    --print(x, y)
end

function love.draw()
    love.graphics.setCanvas(officeCanvas)
        office:draw()
    love.graphics.setCanvas()
    love.graphics.setShader(warpshader) 
        love.graphics.draw(officeCanvas, 0, 0, 0, 1, 1)
    love.graphics.setShader()
    leftdoors:draw()
    rightdoors:draw()
    leftpanel:draw()
    rightpanel:draw()
    if cameraflip:getAnimName() ~= "off" then cameraflip:draw() end
    if showcamshit and inCams then
        if curcam == "stage" then stagecam:draw()
        elseif curcam == "dining" then diningroomcam:draw()
        elseif curcam == "piratecove" then piratecovecam:draw()
        elseif curcam == "lefthall" then lefthallcam:draw()
        elseif curcam == "leftcorner" then leftcornercam:draw()
        elseif curcam == "closet" then closetcam:draw()
        elseif curcam == "righthall" then righthallcam:draw()
        elseif curcam == "rightcorner" then rightcornercam:draw()
        elseif curcam == "backroom" then backstagecam:draw()
        elseif curcam == "bathroom" then bathroomcam:draw()
        end

        static:draw()
        map:draw()
    end
    cambutton:draw()

    if canMute and phonecall:isPlaying() then muteButton:draw() end

    if beenJumpscared then
        if bonniejump:isAnimated() then bonniejump:draw() end
        --if chicajump:isAnimated() then chicajump:draw() end
    end
end
