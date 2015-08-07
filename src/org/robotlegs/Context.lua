--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

local Context = {}

function Context:new()
	local context = {}
	context.commands = {}
	context.mediators = {}
	context.mediatorInstances = {}
	
	function context:init()
		Runtime:addEventListener("onRobotlegsViewCreated", self)
		Runtime:addEventListener("onRobotlegsViewDestroyed", self)
	end

	function context:onRobotlegsViewCreated(event)
		--print("Context::onRobotlegsViewCreated")
		local view = event.target
		if view == nil then
			error("ERROR: Robotlegs Context received a create event, but no view instance in the event object.")
		end
		self:createMediator(view)
	end

	function context:onRobotlegsViewDestroyed(event)
		--print("Context::onRobotlegsViewDestroyed")
		local view = event.target
		if view == nil then
			error("ERROR: Robotlegs Context received a destroyed event, but no view instance in the event object.")
		end
		self:removeMediator(view)
	end

	function context:onHandleEvent(event)
		--print("Context::onHandleEvent, name: ", event.name)
		local commandClassName = context.commands[event.name]
		--print("commandClassName: ", commandClassName)
		if(commandClassName ~= nil) then
			local command = assert(require(commandClassName):new(), "Failed to find command: ", commandClassName)
			--print("command: ", command)
			command.context = self
			command:execute(event)
		end
	end
	
	function context:mapCommand(eventName, commandClass)
		assert(eventName ~= nil, "eventName required.")
		assert(commandClass ~= nil, "commandClass required.")
		--print("Context::mapCommand, name: ", eventName, ", commandClass: ", commandClass)
		assert(require(commandClass), "Could not find commandClass")
		self.commands[eventName] = commandClass
		Runtime:addEventListener(eventName, function(e)context:onHandleEvent(e)end)
	end
	
	function context:mapMediator(viewClass, mediatorClass)
		assert(viewClass ~= nil, "viewClass cannot be nil.")
		assert(mediatorClass ~= nil, "mediatorClass cannot be nil.")
		assert(require(viewClass), "Could not find viewClass")
		assert(require(mediatorClass), "Could not find mediatorClass")
		--print("Context::mapMediator, viewClass: ", viewClass, ", mediatorClass: ", mediatorClass)
		-- NOTE: we're storing the actual class name, and discarding the package. This can lead to bugs,
		-- but until we have an easier way to get package information, we have zero clue what Lua/Corona
		-- does with our classes.
		local className = assert(self:getClassName(viewClass), "Couldn't parse class name")
		self.mediators[className] = mediatorClass
		return true
	end
	
	function context:unmapMediator(viewClass)
		assert(viewClass ~= nil, "viewClass cannot be nil.")
		--print("Context::unmapMediator, viewClass: ", viewClass)
		assert(viewClass.classType ~= nil, "viewClass does not have a classType parameter.")
		self.mediators[viewClass.classType] = nil
		return true
	end
	
	function context:createMediator(viewInstance)
		--print("Context::createMediator, viewInstance: ", viewInstance)
		assert(viewInstance.classType, "viewInstance does not have a classType parameter.")
		local className = assert(self:getClassName(viewInstance.classType), "Failed to get class name")
		assert(_G[className], "Cannot find viewInstance class")
		assert(self:hasCreatedMediator(viewInstance) == false, "viewInstance already has an instantiated Mediator.")
		local mediatorClassName = self.mediators[viewInstance.classType]
		assert(mediatorClassName, "There is no Mediator class registered for this View class.")
		if(mediatorClassName ~= nil) then
			local mediatorClass = require(mediatorClassName):new()
			mediatorClass.viewInstance = viewInstance
			table.insert(self.mediatorInstances, mediatorClass)
			mediatorClass:onRegister()
			return true
		else
			return false
		end
	end
	
	function context:removeMediator(viewInstance)
		--print("Context::removeMediator, viewInstance: ", viewInstance)
		-- find a mediator that matches the passed in viewInstance, otherwise, yuke
		local i = 1
		while self.mediatorInstances[i] do
			local mediatorInstance = self.mediatorInstances[i]
			if(mediatorInstance.viewInstance == viewInstance) then
				mediatorInstance:onRemove()
				mediatorInstance:destroy()
				local mediatorIndex = table.indexOf(self.mediatorInstances, mediatorInstance)
				table.remove(self.mediatorInstances, mediatorIndex)
				return true
			end
		end
		return false
	end
	
	function context:hasCreatedMediator(viewInstance)
		--print("Context::hasCreatedMediator, viewInstance: ", viewInstance)
		for i,mediatorInstance in ipairs(self.mediatorInstances) do
			if(mediatorInstance.viewInstance == viewInstance) then
				return true, i
			end
		end
		return false
	end
	
	-- take a package and get a clafdisss name
	function context:getClassName(classType)
		assert(classType ~= nil, "You cannot pass a null classType")
		local testStartIndex,testEndIndex = classType:find(".", 1, true)
		if testStartIndex == nil then
			return classType
		end
		local startIndex = 1
		local endIndex = 1
		local lastStartIndex = 1
		local lastEndIndex = 1
		while startIndex do
			startIndex,endIndex = classType:find(".", startIndex, true)
			if startIndex ~= nil and endIndex ~= nil then
				lastStartIndex = startIndex
				lastEndIndex = endIndex
				startIndex = startIndex + 1
				endIndex = endIndex + 1
			end
		end
		local className = classType:sub(lastStartIndex + 1)
		return className
	end

	context:init()

	return context
end

return Context