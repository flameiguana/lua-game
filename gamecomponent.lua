
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

function GameComponent:disable()

end
--by default components don't update, unless the subclass says to do so
GameComponent.static.canUpdate = false


--The game object class supports adding components and retrieving them
GameObject = class('GameObject')

function GameObject:initialize()
	self.updatingComponents = nil
end

function GameObject:addComponent(Type)
	local instanceOfType = Type:new()

	instanceOfType.gameObject = self

	--add publicly accesible variable. TODO: make fist letter lowercase
	--you can access like this: gameObject.Type (eg. player.boundingBox)
	self[Type.name] = instanceOfType

	--if this is a component that updates, add to list
	if Type.canUpdate then
		self.updatingComponents = {next = self.updatingComponents, value = instanceOfType}
	end

	return instanceOfType
end

--updates all attached components
function GameObject:update()
	--create a local pointer to traverse list
	local updatingComponents = self.updatingComponents
	-- traverse list
	while updatingComponents do
		updatingComponents.value:update()
		updatingComponents = updatingComponents.next
	end
end


--a test component that can be added to an object
Test = class('Test', GameComponent)

function Test:initialize()
	print("initialized")
end

function Test:update()
	print("hi")
end

Test.static.canUpdate = true