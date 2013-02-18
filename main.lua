require("player")
require("aabb")
require("vector")
require("stage")
require("tile")
require("inherit")

local player

function love.load()
--[[
	For each tile, get its sprite property and put it in the spriteSheet
--]]
	love.graphics.setCaption("Demo")
	love.graphics.setMode(640, 480, false, true, 0)
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
	player = Player.new(Vector.new(30,30), sprPlayer)
	stage = Stage.new(player)
	stage:load(map)
	
end
function love.keypressed(key, unicode)
	if key == "escape" then
		love.event.quit()
	end
end

function love.update()
	stage:update()
end

function love.draw()
	stage:draw()
end


