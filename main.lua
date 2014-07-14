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


local framerate = 10
local stage

function love.load()

--[[
	For each tile, get its sprite property and put it in the spriteSheet
--]]

	love.window.setTitle("Demo")
	love.window.setMode(640, 480, {fullscreen = false})
	local mapData = {
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,1,1,0,1,0,0,0,0,0,0,0},
		{0,0,0,1,1,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,1,0,0,0,0,0,0,0},
		{1,1,1,0,0,1,1,1,0,0,1,0,0,0},
		{1,1,1,1,2,1,1,1,1,0,0,0,0,0},
		{1,1,1,1,0,0,1,1,1,1,1,1,1,1}
	}
	local blockSprite = love.graphics.newImage("block.png")
	stage = Stage:new()
	stage:addTileMap(mapData, blockSprite, 32)

	sprPlayer = love.graphics.newImage("player.png")

	local playerObject = stage:addGameObject()
	local playerBox = playerObject:addComponent(AABB)
	playerBox.position = Vector:new(30,30)
	playerBox.width = 32
	playerBox.height = 32
	local playerScript = playerObject:addComponent(Player)
	--set values here should use initializer function
	playerScript.sprite = sprPlayer
	playerScript.tileMap = stage.tileMap --bad

	stage:load()
end

function love.keypressed(key, unicode)
	if key == "escape" then
		love.event.quit()
	end
end

function love.update(dt)
	stage:update()
end

local translation = 0;
function love.draw()
	--translation = translation + .5
	love.graphics.translate(translation, 0)
	stage:draw()
end
