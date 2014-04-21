AABB = {}
AABB.__index = AABB

--Note: Uses left edge as origin.
function AABB.new(pos, width, height)
	local aabb = {}
	aabb.pos = pos
	aabb.width = width
	aabb.height = height
	setmetatable(aabb, AABB)
	return aabb
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

