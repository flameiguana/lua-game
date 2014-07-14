
AABB = class('AABB', GameComponent)

--[[

AABB = {}
AABB.__index = AABB

]]

--Note: Uses left edge as origin.
--todo: collision masks
--if we ever allow passing of parameters, we would be ready to go.
--for now just sets default values when params are nil
function AABB:initialize(pos, width, height)
	self.pos = pos or Vector:new()
	self.width = width or 0
	self.height = height or 0
end

--Private functions
local function withinTopEdge(self, other) 
	return self.pos.y + self.height > other.pos.y
end

local function withinBotEdge(self, other)
	return self.pos.y < other.pos.y + other.height
end

local function withinRightEdge(self, other)
	return self.pos.x < other.pos.x + other.width
end

local function withinLeftEdge(self, other)
	return self.pos.x + self.width > other.pos.x
end

--Looks a little weird, but saves some cycles.
function AABB:isColliding(other)
	if not withinTopEdge(self, other)then return false end
	if not withinBotEdge(self, other)then return false end
	if not withinRightEdge(self, other)then return false end
	if not withinLeftEdge(self, other)then return false end
	return true
end

