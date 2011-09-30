--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]


require "org.robotlegs.globals"
require "org.robotlegs.MessageBus"

Context = {}

function Context:new()
	local context = {}
	context.ID = globals:getID()
	context.commands = {}
	context.mediators = {}
	context.mediatorInstances = {}
	
	function context:startup()
		-- abstract
	end
	
	function context:onHandleEvent(event)
		--print("Context::onHandleEvent, name: ", event.name)
		local commandClassName = context.commands[event.name]
		if(commandClassName ~= nil) then
			local command = require(commandClassName).new()
			command:execute(event)
		end
	end
	
	function context:mapCommand(eventName, commandClass)
		--print("Context::mapCommand, name: ", eventName, ", commandClass: ", commandClass)
		self.commands[eventName] = commandClass
		MessageBus:addListener(eventName, context.onHandleEvent)
	end
	
	function context:mapMediator(viewClass, mediatorClass)
		assert(viewClass ~= nil, "viewClass cannot be nil.")
		assert(mediatorClass ~= nil, "mediatorClass cannot be nil.")
		--print("Context::mapMediator, viewClass: ", viewClass, ", mediatorClass: ", mediatorClass)
		self.mediators[viewClass] = mediatorClass
		return true
	end
	
	function context:unmapMediator(viewClass)
		--print("Context::unmapMediator, viewClass: ", viewClass)
		assert(viewClass.classType ~= nil, "viewClass does not have a classType parameter.")
		self.mediators[viewClass.classType] = nil
		return true
	end
	
	function context:createMediator(viewInstance)
		--print("Context::createMediator, viewInstance: ", viewInstance)
		assert(viewInstance.classType ~= nil, "viewInstance does not have a classType parameter.")
		assert(self:hasCreatedMediator(viewInstance) == false, "viewInstance already has an instantiated Mediator.")
		local mediatorClassName = self.mediators[viewInstance.classType]
		assert(mediatorClassName ~= nil, "There is no Mediator class registered for this View class.")
		--print("mediatorClassName: ", mediatorClassName)
		if(mediatorClassName ~= nil) then
			local mediatorClass = require(mediatorClassName):new(viewInstance)
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
				table.remove(self.mediatorInstances, mediatorInstance)
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
	
	function context:dispatch(eventObj)
		--print("Context::dispatch, name: ", eventObj.name)
		MessageBus:dispatch(eventObj)
	end
	
	function context:init()
		self:startup()
	end

	return context
end

return Context