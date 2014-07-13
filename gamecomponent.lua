
--Components can be attached to GameObjects.
GameComponent = class ('GameComponent')

--empty functions, in case we call them in subclasses
function GameComponent:initialize()
	self.gameObject = nil --no object attched to this script
end

function GameComponent:start()

end

function GameComponent:update()

end

function GameComponent:draw()

end

function GameComponent:disable()

end
--by default components don't update, unless the subclass says to do so
GameComponent.static.canUpdate = false
GameComponent.static.canDraw = false


--a test component that can be added to an object
Test = class('Test', GameComponent)

function Test:initialize()
	print("initialized")
end

function Test:update()
	print("hi")
end

Test.static.canUpdate = true
