Player = class('Player', GameComponent)

Player.static.canDraw = true
Player.static.canUpdate = true

function Player:initialize()
	GameComponent.initialize(self)
	--temporary
	self.tileMap = nil
	--todo: move visual code to another component
	self.sprite = nil
	self.quads = 
	{
		left = love.graphics.newQuad(0, 0, 32, 32, 64, 64),
		right = love.graphics.newQuad(32, 0, 32, 32, 64, 64)
	}


	self.activeq = "right"
	self.facingRight = true
	self.onGround = false
	self.goingUp = false
	self.canJump = true

	self.health = 100
	self.lives = 5
	
	self.vel = Vector:new()
	self.targetVel = Vector:new() 

	--constants
	self.MAXSPEED = 3
	self.THRESHOLD = .3
	self.ACCEL = .2
	self.TERMINAL = 6
	self.GRAV = .14

	print(self.health)
end

--Update various things related to player.

function Player:update()
	self:moveX(self.tileMap)
	self:moveY(self.tileMap)
end

function Player:moveX(tileMap)
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
	self.gameObject.AABB.pos.x = self.gameObject.AABB.pos.x + self.vel.x
	local colObs = tileMap:horizontalCheck(self.gameObject.AABB, self.facingRight)
	---for some reason reversing player position update order fixed error
	for _, other in pairs(colObs) do
	 	if self.facingRight then
			self.gameObject.AABB.pos.x = other.box.pos.x - self.gameObject.AABB.width
			self.vel.x = 0
			break
		else 
			self.gameObject.AABB.pos.x = other.box.pos.x + other.box.width
			self.vel.x = 0
			break
		end
	end
end

function Player:moveY(tileMap)
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
	self.gameObject.AABB.pos.y = self.gameObject.AABB.pos.y + self.vel.y
	local colObs = tileMap:verticalCheck(self.gameObject.AABB, self.goingUp)
	self.onGround = false

	for _, other in pairs(colObs) do
		if (not self.goingUp) then
			self.gameObject.AABB.pos.y = other.box.pos.y - self.gameObject.AABB.height
			self.onGround = true
			self.vel.y = 0
		break
		else
			self.gameObject.AABB.pos.y = other.box.pos.y + other.box.height 
			self.vel.y = 0
			--self.goingUp = false
		break
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
	love.graphics.draw(self.sprite, self.quads[self.activeq], self.gameObject.AABB.pos.x, self.gameObject.AABB.pos.y)
end
