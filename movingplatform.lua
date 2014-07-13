MovingPlatform = {}
MovingPlatform.__index = MovingPlatform

--[[
	How it's gonna move:
	Have an array of vertices. Do a linear interpolation in order
	to reach the endpoints. If there are no more, reverse direction.
	It is not responsible for player. The player determines collision on its
	own or with help of stage. 
]]--
function MovingPlatform.new(pos, sprite, cycleTime)
	local mp = {}
	mp.path = {pos, Vector:new(200, 350)}
	--for now only two points.
	mp.start = mp.path[1]
	mp.goal = mp.path[2]
	mp.cycleTime = cycleTime
	mp.startTime = 0
	mp.sprite = sprite
	mp.startedCycle = false
	
	mp.box = AABB:new(pos, sprite:getWidth(), sprite:getHeight())
	setmetatable(mp, MovingPlatform)
	return mp
end

function MovingPlatform:step(time)
	
	if(not self.startedCycle) then
		self.startTime = time;
		self.startedCycle = true;
	end

	local timeElapsed = time - self.startTime;

	if(timeElapsed >= self.cycleTime) then 
		self.startedCycle = false;
		--swap start and goal
		self.box.pos = self.goal
		local temp = self.start
		self.start = self.goal
		self.goal = temp
		return
	end

	local distanceToCover = self.goal - self.start;
	self.box.pos = distanceToCover * (time/self.cycleTime) + self.start

end

function MovingPlatform:draw()
	love.graphics.draw(self.sprite, self.box.pos.x, self.box.pos.y)
end

