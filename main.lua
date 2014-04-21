class = require 'middleclass'


require("player")
require("aabb")
require("vector")
require("stage")
require("tile")
require("inherit")
require("movingplatform")
require("gamecomponent")


local player
local framerate = 10
local testObject

function love.load()

--[[
	For each tile, get its sprite property and put it in the spriteSheet
--]]

	love.window.setTitle("Demo")


	love.window.setMode(640, 480, {fullscreen = false})
	map = {
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,1,1,0,1,0,0,0,0,0,0,0},
		{0,0,0,1,1,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,1,0,0,0,0,0,0,0},
		{1,1,1,0,0,1,1,1,0,0,1,0,0,0},
		{1,1,1,1,2,1,1,1,1,0,0,0,0,0},
		{1,1,1,1,0,0,1,1,1,1,1,1,1,1}
	}
	sprPlayer = love.graphics.newImage("player.png")
	sprPlatform = love.graphics.newImage("mvplatform.png")

	platform = MovingPlatform.new(Vector.new(10, 350), sprPlatform, 5.0)
	player = Player.new(Vector.new(30,30), sprPlayer)
	stage = Stage.new(player, platform)
	stage:load(map)
	stage:setup()
	
	--test component system
	testObject = GameObject:new()
	testObject:addComponent(Test)
end

function love.keypressed(key, unicode)
	if key == "escape" then
		love.event.quit()
	end
end

function love.update(dt)
	stage:update()
	testObject:update()
end

local translation = 0;
function love.draw()
	--translation = translation + .5
	love.graphics.translate(translation, 0)
	stage:draw()

end
