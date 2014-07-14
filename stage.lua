require "tilemap"

Stage = class("Stage")

function Stage:initialize()
	self.tileMap = nil
	self.gameObjects = {}
end

function Stage:load()
	self.tileMap:load()
end

function Stage:addTileMap(mapLayout, image, tileSize)
	local tileMap = TileMap:new(mapLayout, image, tileSize)
	self.tileMap = tileMap
	return tileMap
end

function Stage:addGameObject()
	local gObject = GameObject:new()
	table.insert(self.gameObjects, gObject)
	return gObject
end

function Stage:update()
	for i, gameObject in pairs(self.gameObjects) do 
		gameObject:update()
	end
end

--todo draw layers
function Stage:draw()
	self.tileMap:draw()
	for i, gameObject in pairs(self.gameObjects) do 
		gameObject:draw()
	end
end
