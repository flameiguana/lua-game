Player = {}
Player.__index = Player

Player.MAXSPEED = 3
Player.THRESHOLD = .3
Player.ACCEL = .2
Player.TERMINAL = 6
Player.GRAV = .14

Player.new = function (startingpos, sprite)
	local player = {}
	player.sprite = sprite
	player.quads = 
	{
		left = love.graphics.newQuad(0, 0, 32, 32, 64, 64),
		right = love.graphics.newQuad(32, 0, 32, 32, 64, 64)
	}
	player.box = AABB.new(startingpos, 32, 32)
	player.activeq = "right"
	player.facingRight = true
	player.onGround = false
	player.goingUp = false
	player.canJump = true

	player.health = 100
	player.lives = 5
	
	player.vel = Vector.new()
	player.targetVel = Vector.new() 
	setmetatable(player, Player)
	print(player.health)
	return player
end

--Update various things related to player. Need to call move functions from here.
function Player:update()

end

function Player:moveX(stage)
	self.targetVel.x = 0
	if love.keyboard.isDown("right") then
		self.targetVel.x = self.MAXSPEED
		self.activeq = "right"
		self.facingRight = true
	end
	if love.keyboard.isDown("left") then
		self.targetVel.x = -self.MAXSPEED
		self.activeq = "left"
		self.facingRight = false
	end

	--Weighted average interpolation. I still don't get it
	self.vel.x = self.ACCEL * self.targetVel.x + (1 - self.ACCEL) * self.vel.x
	if (math.abs(self.vel.x) < self.THRESHOLD) then self.vel.x = 0 end
	self.box.pos.x = self.box.pos.x + self.vel.x
	local colObs = stage:horizontalCheck()
	---for some reason reversing player position update order fixed error
	--eventually this will be calling a function in the tile itself.
	for i, other in pairs(colObs) do
		 if self.box:isColliding(other.box) then
			other.action(self)
	 		if self.facingRight then
				self.box.pos.x = other.box.pos.x - self.box.width
				self.vel.x = 0
				break
			else 
				self.box.pos.x = other.box.pos.x + other.box.width
				self.vel.x = 0
				break
			end
		end
	end
end

function Player:moveY(stage)
	if not love.keyboard.isDown(" ") then self.canJump = true end
	self.targetVel.y = self.TERMINAL

	if love.keyboard.isDown(" ") and self.canJump and self.onGround then
		self.vel.y = -18
		self.canJump = false
	end

	self.vel.y = self.GRAV * self.targetVel.y + (1 - self.GRAV) * self.vel.y
	if (math.abs(self.vel.y) < self.THRESHOLD) then self.vel.y = 0 end
	if self.vel.y >= 0 then self.goingUp = false else self.goingUp = true end 
	--Before moving player, look for obstacles above and below

	--Add velocity to position
	self.box.pos.y = self.box.pos.y + self.vel.y
			local colObs = stage:verticalCheck()
	self.onGround = false

	for i, other in pairs(colObs) do
		other.action(self)
		 if self.box:isColliding(other.box) then
			if (not self.goingUp) then
				self.box.pos.y = other.box.pos.y - self.box.height
				self.onGround = true
				self.vel.y = 0
			break
			else
				self.box.pos.y = other.box.pos.y + other.box.height 
				self.vel.y = 0
				--self.goingUp = false
			break
			end
		end
	end
end

function Player:takeDamage(amount)
	if self.health - amount < 0 then
		self.lives = self.lives - 1 
		self.health = 100
	else
		self.health = self.health - amount
	end
	--print("Health: " .. self.health)
	--print("Lives: " .. self.lives)
end

function Player:draw()
	love.graphics.draw(self.sprite, self.quads[self.activeq], self.box.pos.x, self.box.pos.y)
end
