-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local options = {
	width = 50,
	height = 60,
	numFrames = 2
}

local sequenceData = {
    { name = "health0", start=1, count=1, time=0,   loopCount=1 },
    { name = "health1", start=1, count=2, time=100, loopCount=1 },
    { name = "health2", start=1, count=3, time=200, loopCount=1 },
    { name = "health3", start=1, count=4, time=300, loopCount=1 },
    { name = "health4", start=1, count=5, time=400, loopCount=1 },
    { name = "health5", start=1, count=6, time=500, loopCount=1 }
	}

-- sequences table
local sequences_healthSheet = {
    -- consecutive frames sequence
    {
        name = "healthSprite",
        start = 1,
        count = 5,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    }
}


-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()
physics.setGravity(0,6)

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

local imgsheetSetup= 
{
width = 100,
height = 100,
numFrames = 3
}

local spriteSheet = graphics.newImageSheet("monsterSpriteSheet.png", imgsheetSetup);

--Now we create a table that holds the sequence data for our animations

local sequenceData = 
{
{ name = "running", start = 1, count = 6, time = 600, loopCount = 0},
{ name = "jumping", start = 7, count = 7, time = 1, loopCount = 1 }
}

--And assign it to the object hero using the display.newSprite function



-- Implementation for BUTTONS
local upButton = display.newImage("up.png")
upButton:scale(0.5,0.5)
upButton.x = display.contentWidth * .175
upButton.y = display.contentHeight * .8

local downButton = display.newImage("down.png")
downButton:scale(0.5,0.5)
downButton.x = display.contentWidth * .175
downButton.y = display.contentHeight * .9


local leftButton = display.newImage("left.png")
leftButton:scale(0.5,0.5)
leftButton.x = display.contentWidth * .1
leftButton.y = display.contentHeight * .9


local rightButton = display.newImage("right.png")
rightButton:scale(0.5,0.5)
rightButton.x = display.contentWidth * .25
rightButton.y = display.contentHeight * .9

local motionx = 0
local motiony = 0
local speed = 10


local function stop (event)
	if event.phase == "ended" then

	motionx = 0
	motiony = 0
	end
end

Runtime:addEventListener("touch",stop)





function upButton:touch()
	motionx = 0
	motiony = -speed * 2
end

upButton:addEventListener("touch",upButton)

function downButton:touch()
	motionx = 0
	motiony = speed
end
downButton:addEventListener("touch",downButton)

function leftButton:touch()
	motionx = -speed
	motiony = 0
end
leftButton:addEventListener("touch",leftButton)

function rightButton:touch()
	motionx = speed
	motiony = 0
end
rightButton:addEventListener("touch",rightButton)


function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view
	
	--takes away the display bar at the top of the screen
display.setStatusBar(display.HiddenStatusBar)

--adds an image to our game centered at x and y coordinates
local backbackground = display.newImage("background.jpg")
backbackground.x = 240
backbackground.y = 160

local backgroundfar = display.newImage("bgfar1.png")
backgroundfar.x = 480
backgroundfar.y = 160

local backgroundnear1 = display.newImage("bgnear2.png")
backgroundnear1.x = 240
backgroundnear1.y = 160

local backgroundnear2 = display.newImage("bgnear2.png")
backgroundnear2.x = 760
backgroundnear2.y = 160

--create a new group to hold all of our blocks
local blocks = display.newGroup()

--setup some variables that we will use to position the ground
local groundMin = 420
local groundMax = 340
local groundLevel = groundMin
local speed = 3;

--this for loop will generate all of your ground pieces, we are going to
--make 8 in all.
for a = 1, 8, 1 do
	isDone = false

	--get a random number between 1 and 2, this is what we will use to decide which
	--texture to use for our ground sprites. Doing this will give us random ground
	--pieces so it seems like the ground goes on forever. You can have as many different
	--textures as you want. The more you have the more random it will be, just remember to
	--up the number in math.random(x) to however many textures you have.
	numGen = math.random(2)

	local blockShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	
	print (numGen)
	if(numGen == 1 and isDone == false) then
		newBlock = display.newImage("rocks.jpg")
		
		isDone = true
	end

	if(numGen == 2 and isDone == false) then
		newBlock = display.newImage("rocks.jpg")

		isDone = true
	end

	--now that we have the right image for the block we are going
	--to give it some member variables that will help us keep track
	--of each block as well as position them where we want them.
	newBlock.name = ("block" .. a)
	newBlock.id = a

	--because a is a variable that is being changed each run we can assign
	--values to the block based on a. In this case we want the x position to
	--be positioned the width of a block apart.
	newBlock.x = (a * 79) - 79
	newBlock.y = groundLevel
	blocks:insert(newBlock)
end

local bgShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
--the update function will control most everything that happens in our game
--this will be called every frame(30 frames per second in our case, which is the Corona SDK default)
local function update( event )
	--updateBackgrounds will call a function made specifically to handle the background movement
	updateBackgrounds()
	updateBlocks()
	speed = speed
end



function updateBlocks()
	for a = 1, blocks.numChildren, 1 do
	
		if(a > 1) then
			newX = (blocks[a - 1]).x + 79

		else
			newX = (blocks[8]).x + 79 - speed
		end

		if((blocks[a]).x < -40) then
			(blocks[a]).x, (blocks[a]).y = newX, (blocks[a]).y
		else
			(blocks[a]):translate(speed * -1, 0)
		end
	end
end

function updateBackgrounds()
	--far background movement
	backgroundfar.x = backgroundfar.x - (speed/55)

	--near background movement
	backgroundnear1.x = backgroundnear1.x - (speed/5)
	if(backgroundnear1.x < -239) then
		backgroundnear1.x = 760
	end

	backgroundnear2.x = backgroundnear2.x - (speed/5)
	if(backgroundnear2.x < -239) then
		backgroundnear2.x = 760
	end
end

--this is how we call the update function, make sure that this line comes after the
--actual function or it will not be able to find it
--timer.performWithDelay(how often it will run in milliseconds, function to call,
--how many times to call(-1 means forever))
timer.performWithDelay(1, update, -1)
local hero = display.newSprite(spriteSheet, sequenceData);

x = display.contentWidth/2;
y = display.contentHeight/2;
right = true;
hero.x = x;
hero.y = y;

--Then, instead of using the prepare method, we use setSequence
hero:setSequence("running");
physics.addBody(hero)
hero:play();

--the rest of the code remains the same
function update()

if (right) then
hero.x = hero.x + 1;
else
hero.x = hero.x - 1;
end
if (hero.x > 480) then
right = false;
hero.xScale = -1;
end
if (hero.x < 0) then
right = true;
hero.xScale = 1;
end
end

timer.performWithDelay(1, update, -1);




	
	-- all display objects must be inserted into group
	
	sceneGroup:insert(upButton)
	sceneGroup:insert(downButton)
	sceneGroup:insert(leftButton)
	sceneGroup:insert(rightButton)
	sceneGroup:insert(backgroundnear2)
	sceneGroup:insert(backgroundnear1)
	sceneGroup:insert(backbackground)
	sceneGroup:insert(backgroundfar)
	sceneGroup:insert(hero)


end



function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
