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
require("camera")
require("tilemap")


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
	playerBox.pos = Vector:new(60,30)
	playerBox.width = 32
	playerBox.height = 32
	local playerScript = playerObject:addComponent(Player)
	--set values here should use initializer function
	playerScript.sprite = sprPlayer
	playerScript.tileMap = stage.tileMap --bad
	stage.camera:follow(playerBox.pos)
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

function love.draw()
	stage:draw()
end
