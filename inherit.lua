function inheritsFrom(baseClass)
	local newClass = {}
	newClass.__index = newClass

	if baseClass then
		setmetatable(newClass, baseClass)
	end
	
	--gives a default "new" function
	function newClass.new()
		local instance = {}
		setmetatable(instance, newClass)
		return instance
	end
	
	return newClass
end
