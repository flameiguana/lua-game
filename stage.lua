Stage = {}
Stage.__index = Stage

function Stage.new(player)
	local stage = {}
	stage.tmap = nil
	stage.tileSize = 32
	stage.player = player
	stage.obs = {}
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
			local tile  = Tile.new(Vector.new((x-1)*self.tileSize,(y-1)*32), 32, map[y][x], map[y][x]) 
			self.spriteBatch:addq(Tile.quads[tile.graphic], (x-1)*self.tileSize, (y-1)*self.tileSize)  --should be addq in final version
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
local function addTile(self, x, y)
	table.insert(self.obs, self.tmap[y+1][x+1])
end


function Stage:horizontalCheck()
	local finished = false
	local rightEdge = math.floor((self.player.box.pos.x + self.player.box.width)/self.tileSize)
	local rightLimit  = rightEdge + 3
	local topRow = math.floor((self.player.box.pos.y)/self.tileSize)
	local botRow = topRow + math.floor(self.player.box.height-1/self.tileSize)
	if self.player.facingRight then
	--look right up to 3
		for col = rightEdge, rightLimit do 
			if finished then break end
			for row = topRow, botRow do
				if isSolid(self, col, row) then
					addTile(self, col, row)
					finished = true
				end
			end
		end
	else
		--We make it one less so that it doesn't treat block below player
		--as a collision block
		local leftEdge = math.floor((self.player.box.pos.x-1)/self.tileSize)
		local leftLimit = leftEdge - 3
		for col = leftEdge, leftLimit, -1 do
			if finished then break end
			for row = topRow, botRow do
				if isSolid(self, col, row) then
					addTile(self, col, row)
					finished = true
				end	
			end
		end
	end
	return self.obs
end

function Stage:verticalCheck()
	local finished = false
	local botEdge = math.floor((self.player.box.pos.y + self.player.box.height)/self.tileSize)
	local botLimit = botEdge + 3
	local leftEdge = math.floor((self.player.box.pos.x)/self.tileSize)
	local rightEdge = leftEdge + math.floor(self.player.box.width/self.tileSize)
	if (not self.player.goingUp) then
		for row = botEdge, botLimit do
			if finished then break end
			for col = leftEdge, rightEdge do
				if isSolid(self, col, row) then
					addTile(self, col, row)
					finished = true
				end
			end
		end
	else
	local topEdge = math.floor((self.player.box.pos.y)/self.tileSize)
	local topLimit = topEdge - 3
		for row = topEdge, topLimit, -1 do
			if finished then break end
			for col = leftEdge, rightEdge do
				if isSolid(self, col, row) then
					addTile(self, col, row)
					finished = true
				end
			end
		end
	end
	return self.obs
end


function Stage:load(map)
	--loads all tile graphics and makes tmap
	local block = love.graphics.newImage("block.png")
	self.spriteBatch = love.graphics.newSpriteBatch(block)
	--change to tmap:load()
	self.tmap = parseMap(self, map)
end

function Stage:update()
	self.player:moveX(self)
	for k,v in pairs(self.obs) do self.obs[k]= nil end
	self.player:moveY(self)
	for k,v in pairs(self.obs) do self.obs[k]= nil end
end

function Stage:draw()
	love.graphics.draw(self.spriteBatch,0,0)
	self.player:draw()
end
