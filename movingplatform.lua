MovingPlatform = {}
MovingPlatform.__index = MovingPlatform

--[[
How it's gonna move:
Have an array of vertices. Do a linear interpolation in order
to reach the endpoints. If there are no more, reverse direction.
It is not responsible for player. The player determines collision on its
own or with help of stage. 
]]--
function MovingPlatform.new(pos, sprite)
	mp = {}
	mp.path = {Vector.new(96,32), Vector.new(256, 32)}
	mp.start = mp.path[1]
	mp.goal = mp.path[2]
	mp.vel = Vector.new()
	mp.box = AABB.new(pos, 96, 32)
	setmetatable(mp, MovingPlatform)
	return mp
end

function MovingPlatform:step()
	if (self.box.pos == self.goal)
	then self.goal = path[#path - 1]
	
--if start + displacemen = goal then goal == next entry in path if it exists
--else make goal the previos point.
end

function MovingPlatform:draw()
	
end
