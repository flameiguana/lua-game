TileMap = class("TileMap")

local function parseMap(self)
	local map = self.mapLayout
	local tiles = {}
	local rows = #map
	local columns = #map[1]
	self.spriteBatch:bind()
	for yIndex = 1, rows do
		tiles[yIndex] = {}
		for xIndex = 1, columns do 
			local tile  = Tile.new(map[yIndex][xIndex]) 
			self.spriteBatch:add(Tile.quads[map[yIndex][xIndex]], (xIndex-1)*self.tileSize, (yIndex-1)*self.tileSize)  --should be addq in final version
			tiles[yIndex][xIndex] = tile 
		end  
	end
	self.spriteBatch:unbind()
	return tiles
end


function TileMap:initialize(mapLayout, image, tileSize)
	self.mapLayout = mapLayout
	self.image = image
	self.tileSize = tileSize or 32
end

function TileMap:load()
	self.spriteBatch = love.graphics.newSpriteBatch(self.image)
	self.tiles = parseMap(self)
end


--to be called only on solid tiles, or else it will add an unnecessary AABB
--might want to move this to tile class to abstract that away
local function isColliding(self, tile, xIndex, yIndex, boundingBox)
	if not tile.solid then
		return false
	end

	if tile.box == nil then
		tile:addBoundingBox(Vector:new((xIndex - 1) * self.tileSize, (yIndex - 1) * self.tileSize), self.tileSize)
	end

	return boundingBox:isColliding(tile.box)
end

function TileMap:getTile(xIndex, yIndex)
	if self.tiles[yIndex] and self.tiles[yIndex][xIndex] then
		return self.tiles[yIndex][xIndex]
	else 
		return nil
	end
end

--TODO: make facingright not a bool (split function up)
function TileMap:horizontalCheck(boundingBox, facingRight)
	local finished = false
	local rightEdge = math.floor((boundingBox.pos.x + boundingBox.width)/self.tileSize) + 1
	local rightLimit  = rightEdge + 2
	local topRow = math.floor((boundingBox.pos.y)/self.tileSize) + 1
	local botRow = topRow + math.floor(boundingBox.height-1/self.tileSize)
	local collidingTiles = {}
	if facingRight then
	--look right up to 3
		for col = rightEdge, rightLimit do 
			if finished then break end
			for row = topRow, botRow do
				local tile = self:getTile(col, row)
				if tile and isColliding(self, tile, col, row, boundingBox) then
					table.insert(collidingTiles, tile)
					finished = true
				end
			end
		end
	else
		--We make it one less so that it doesn't treat block below player
		--as a collision block
		local leftEdge = math.floor((boundingBox.pos.x-1)/self.tileSize) + 1
		local leftLimit = leftEdge - 2
		for col = leftEdge, leftLimit, -1 do
			if finished then break end
			for row = topRow, botRow do
				local tile = self:getTile(col, row)
				if tile and isColliding(self, tile, col, row, boundingBox) then
					table.insert(collidingTiles, tile)
					finished = true
				end	
			end
		end
	end
	return collidingTiles
end

function TileMap:verticalCheck(boundingBox, goingUp)
	local finished = false
	local botEdge = math.floor((boundingBox.pos.y + boundingBox.height)/self.tileSize) + 1
	local botLimit = botEdge + 2
	local leftEdge = math.floor((boundingBox.pos.x)/self.tileSize) + 1
	local rightEdge = leftEdge + math.floor(boundingBox.width/self.tileSize)
	local collidingTiles = {}
	if (not goingUp) then
		for row = botEdge, botLimit do
			if finished then break end
			for col = leftEdge, rightEdge do
				local tile = self:getTile(col, row)
				if tile and isColliding(self, tile, col, row, boundingBox) then
					table.insert(collidingTiles, tile)
					finished = true
				end
			end
		end
	else
		local topEdge = math.floor((boundingBox.pos.y)/self.tileSize) + 1
		local topLimit = topEdge - 2
		for row = topEdge, topLimit, -1 do
			if finished then break end
			for col = leftEdge, rightEdge do
				local tile = self:getTile(col, row)
				if tile and isColliding(self, tile, col, row, boundingBox) then
					table.insert(collidingTiles, tile)
					finished = true
				end
			end
		end
	end
	return collidingTiles
end

function TileMap:draw()
	love.graphics.draw(self.spriteBatch)
end