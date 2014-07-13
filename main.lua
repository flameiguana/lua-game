class = require("middleclass")
require("player")
require("aabb")
require("vector")
require("stage")
require("tile")
require("inherit")
require("movingplatform")
require("gamecomponent")
require("gameobject")


local player
local framerate = 10
local testObject
local stage

function love.load()

--[[
	For each tile, get its sprite property and put it in the spriteSheet
--]]

	love.window.setTitle("Demo")


	love.window.setMode(640, 480, {fullscreen = false})
	local map = {
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,1,1,0,1,0,0,0,0,0,0,0},
		{0,0,0,1,1,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,1,0,0,0,0,0,0,0},
		{1,1,1,0,0,1,1,1,0,0,1,0,0,0},
		{1,1,1,1,2,1,1,1,1,0,0,0,0,0},
		{1,1,1,1,0,0,1,1,1,1,1,1,1,1}
	}
	sprPlatform = love.graphics.newImage("mvplatform.png")
	platform = MovingPlatform.new(Vector:new(10, 350), sprPlatform, 5.0)

	stage = Stage.new(platform)
	stage:load(map)
	stage:setup()

	sprPlayer = love.graphics.newImage("player.png")


	
	--player = Player.new(Vector:new(30,30), sprPlayer)
	player = GameObject:new()
	local playerBox = player:addComponent(AABB)
	playerBox.position = Vector:new(30,30)
	playerBox.width = 32
	playerBox.height = 32

	player:addComponent(Player)
	--set values here
	player.Player.sprite = sprPlayer
	player.Player.stage = stage
	--test component system
	testObject = GameObject:new()
	--testObject:addComponent(Test)
end

function love.keypressed(key, unicode)
	if key == "escape" then
		love.event.quit()
	end
end

function love.update(dt)
	stage:update()
	player:update()
	testObject:update()
end

local translation = 0;
function love.draw()
	--translation = translation + .5
	love.graphics.translate(translation, 0)
	stage:draw()
	player:draw()
end
