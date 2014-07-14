--A gameobject is an object that lets you use built-in and custom components inheriting from the GameComponent  class,
--which a stage will update and draw for you.

GameObject = class('GameObject')

function GameObject:initialize()
	self.updatingComponents = nil
	self.drawingComponents = nil
end

--TODO, maybe let user initialize object instead of callng default constructor (would imply player is owner though)
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

	if Type.canDraw then
		self.drawingComponents = {next = self.drawingComponents, value = instanceOfType}
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

function GameObject:draw()
	local drawingComponents = self.drawingComponents
	-- traverse list
	while drawingComponents do
		drawingComponents.value:draw()
		drawingComponents = drawingComponents.next
	end
end
--todo. creates a clean copy of the current object with all scripts re initialized
function GameObject:clone()

end