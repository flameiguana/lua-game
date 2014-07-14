require ("tilemap")
require("camera")

Stage = class("Stage")
Stage.static.current = nil

--todo (maybe) make this class a singleton
function Stage:initialize()
	self.tileMap = nil
	self.gameObjects = {}
	self.camera = Camera:new()
	--Ideally call this when a stage is enabled (if i implement a game state stack)
	Stage.static.current = self
end

function Stage:load()
	self.tileMap:load()
end

--some factory methods
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
	for _, gameObject in pairs(self.gameObjects) do 
		gameObject:update()
	end
end

--todo draw layers
function Stage:draw()
	self.camera:apply()
	self.tileMap:draw()
	for _, gameObject in pairs(self.gameObjects) do 
		gameObject:draw()
	end
	self.camera:revert()
	--ui stuff (either a different camera or just default transformmation)
end
