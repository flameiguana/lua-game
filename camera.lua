Camera = class("Camera")

--todo, make this a special gamecomponent or gameobject
-- to allow player to attach scripts to camera

function Camera:initialize()
	self.position = Vector:new(0, 0)
	self.target = nil
	self.width = love.window.getWidth()
	print(self.width)
	self.height = love.window.getHeight()
	--setmetatable({}, {__mode = "k"}) if we want target to be set to nil automatically, then use a weak referenec
end

function Camera:setPosition(x, y)
	self.position.x = x
	self.position.y = y
end

--pass in nil to disable
function Camera:follow(point)
	self.target = point
end

--call this before drawing any objects whose screen position you 
--want to be affected by camera
function Camera:apply()
	love.graphics.push()
	
	if self.target ~= nil then 
		self.position:copy(self.target)
	end

	--center camera. there might be a cleaner way
	self:setPosition(self.position.x - self.width/2, self.position.y - self.height/2)
	--Moving camera to right moves everything left and vice versa. remember to avoid floating point
	love.graphics.translate(math.ceil(-self.position.x), math.ceil(-self.position.y))
end

--call this after drawing objects
function Camera:revert()
	love.graphics.pop()
end

