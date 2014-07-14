Tile = {}
Tile.__index = Tile

--eventually come up with a way to automatically do this, without a need for names
Tile.quads = {}
Tile.quads[0] = love.graphics.newQuad(0,32,32,32,64,64)
Tile.quads[1] = love.graphics.newQuad(0,0,32,32,64,64)
Tile.quads[2] = love.graphics.newQuad(32,0,32,32,64,64)
--todo move callbacks to specific tile type
--needs to have access to player data. A delegate would allow you to avoid
--having to pass player, since the function will be in scope
function Tile:damagePlayer(player)
	player:takeDamage(50)
end

function Tile:removeTile(object)
	
end

function Tile:doNothing(object)

end

--a convenience function that allows for collisioin resolution
--should be added while the game is running when a player is near the tile
local count = 0
function Tile:addBoundingBox(pos, tileSize)
	self.box = AABB:new(pos, tileSize, tileSize)
	count = count + 1
	print(count)
end


Tile.types = 
{
	plain =  function(x) Tile:doNothing(x) end,
	damage = function(x) Tile:damagePlayer(x) end,
	removable = function(x) Tile:removeTile(x) end
}

function Tile.new(tileType)
	--dont need pos since t map can take care of that
	local tile = {}
	--this is temporary
	tile.solid = (tileType ~= 0) or false
	
	if tileType == 2 then
		tileType = "damage" 
	else
		tileType = "plain" 
	end

	tile.tileType = tileType
	tile.action = Tile.types[tileType]
	setmetatable(tile, Tile)
	return tile
end
