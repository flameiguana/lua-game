Stage = {}
Stage.__index = Stage

function Stage.new(platform)
	local stage = {}
	stage.tmap = nil
	stage.tileSize = 32
	stage.platform = platform
	stage.spriteBatch = nil
	setmetatable(stage, Stage)
	return stage
end

--[[
	1. Calculate motion, store in seperate vector
	2. Determine collisions using this position, checking solid tiles
		a. Scan up to 3 block to right or left of player. 
		b. Scan below player up to 3 blocks, starting at ceiling[foot of player-1] 
	3. Adjust position if necessary so that it never goes through object.
	4. Apply motion vector
	5. Draw player and tiles
--]]

-- IMPORTANT: Draw function should start at 32,32, since everything is one off

local function parseMap(self, map)
	local tmap = {}
	local rows = #map
	local columns = #map[1]
	self.spriteBatch:bind()
	for y = 1, rows do
		tmap[y] = {}
		for x = 1, columns do 
			local tile  = Tile.new(Vector:new((x-1)*self.tileSize,(y-1)*32), 32, map[y][x], map[y][x]) 
			self.spriteBatch:add(Tile.quads[tile.graphic], (x-1)*self.tileSize, (y-1)*self.tileSize)  --should be addq in final version
			tmap[y][x] = tile 
		end  
	end
	self.spriteBatch:unbind()
	return tmap
end



local function isSolid(self, x, y)
	if self.tmap[y+1] and self.tmap[y+1][x+1] and self.tmap[y+1][x+1].solid == true then
		return true
	else return false end
end
--todo make this private function with middleclass
local function addTile(self, objects, x, y)
	table.insert(objects, self.tmap[y+1][x+1])
end

--TODO: make facingright not a bool (split function up)
function Stage:horizontalCheck(boundingBox, facingRight)
	local finished = false
	local rightEdge = math.floor((boundingBox.pos.x + boundingBox.width)/self.tileSize)
	local rightLimit  = rightEdge + 3
	local topRow = math.floor((boundingBox.pos.y)/self.tileSize)
	local botRow = topRow + math.floor(boundingBox.height-1/self.tileSize)
	local collidingTiles = {}
	if facingRight then
	--look right up to 3
		for col = rightEdge, rightLimit do 
			if finished then break end
			for row = topRow, botRow do
				if isSolid(self, col, row) then
					addTile(self, collidingTiles, col, row)
					finished = true
				end
			end
		end
	else
		--We make it one less so that it doesn't treat block below player
		--as a collision block
		local leftEdge = math.floor((boundingBox.pos.x-1)/self.tileSize)
		local leftLimit = leftEdge - 3
		for col = leftEdge, leftLimit, -1 do
			if finished then break end
			for row = topRow, botRow do
				if isSolid(self, col, row) then
					addTile(self, collidingTiles, col, row)
					finished = true
				end	
			end
		end
	end
	return collidingTiles
end

function Stage:verticalCheck(boundingBox, goingUp)
	local finished = false
	local botEdge = math.floor((boundingBox.pos.y + boundingBox.height)/self.tileSize)
	local botLimit = botEdge + 3
	local leftEdge = math.floor((boundingBox.pos.x)/self.tileSize)
	local rightEdge = leftEdge + math.floor(boundingBox.width/self.tileSize)
	local collidingTiles = {}
	if (not goingUp) then
		for row = botEdge, botLimit do
			if finished then break end
			for col = leftEdge, rightEdge do
				if isSolid(self, col, row) then
					addTile(self, collidingTiles, col, row)
					finished = true
				end
			end
		end
	else
		local topEdge = math.floor((boundingBox.pos.y)/self.tileSize)
		local topLimit = topEdge - 3
		for row = topEdge, topLimit, -1 do
			if finished then break end
			for col = leftEdge, rightEdge do
				if isSolid(self, col, row) then
					addTile(self, collidingTiles, col, row)
					finished = true
				end
			end
		end
	end
	return collidingTiles
end

function Stage:load(map)
	--loads all tile graphics and makes tmap
	local block = love.graphics.newImage("block.png")
	self.spriteBatch = love.graphics.newSpriteBatch(block)
	--change to tmap:load()
	self.tmap = parseMap(self, map)
end

function Stage:setup()
end

function Stage:update()
	time = love.timer.getTime()
	--self.platform:step(time)
end

function Stage:draw()
	love.graphics.draw(self.spriteBatch,0,0)
	--self.platform:draw()
	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end
