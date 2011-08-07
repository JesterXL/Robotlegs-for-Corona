--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

MessageBus = {}

if(MessageBus.listeners == nil) then
	MessageBus.listeners = {}
	MessageBus.count = 0
end

function MessageBus:dispatch(eventObj)
	print("MessageBus::dispatch, name: ", eventObj.name)
	local i = 1
	-- TODO: there was a bug in ActionScript 1's version
	-- where this loop would screw up if a listener removed itself during
	-- an event dispatch; make sure we support that
	while MessageBus.listeners[i] do
		local obj = MessageBus.listeners[i]
		--print("obj.name: ", obj.name, ", eventObj.name: ", eventObj.name)
		if(obj.name == eventObj.name) then
			--print("a match, listener: ", obj.listener)
			if(type(obj.listener) == "function") then
				--print("calling function listener")
				obj.listener(obj, eventObj)
			elseif(type(obj.listener) == "table") then
				--print("calling method on table")
				obj.listener[obj.name](self, eventObj)
			end
		end
		i = i + 1
	end
	return true
end

function MessageBus:addListener(name, listener)
	print("MessageBus::addListener, name: ", name)
	-- NOTE: don't add a listener if we already have one for the exact same scope
	if(name == nil) then error("MessageBus::addListener, name is nil.") end
	if(listener == nil) then error("MessageBus::addListener, listener is nil.") end
	if(MessageBus:hasListener(name, listener) == false) then
		MessageBus.count = MessageBus.count + 1
		return table.insert(MessageBus.listeners, {listener=listener, name=name, count=MessageBus.count})
	else
		return false
	end
end

-- 
function MessageBus:removeListener(name, handler)
	local i = 1
	while MessageBus.listeners[i] do
		local obj = MessageBus.listeners[i]
		if(obj.name == name and obj.listener == handler) then
			MessageBus.count = MessageBus.count - 1
			table.remove(MessageBus.listeners, i)
		else
			i = i + 1
		end
		
	end
	return true
end

function MessageBus:hasListener(name, handler)
	print("MessageBus::hasListener, name: ", name, ", handler: ", handler)
	assert(name ~= nil, "MessageBus::hasListener, name is nil.")
	assert(handler ~= nil, "MessageBus::hasListener, handler is nil.")
	
	for i,obj in ipairs(MessageBus.listeners) do
		if(obj.name == name and obj.listener == handler) then
			return true, i
		end
	end
	
	return false
end

return MessageBus
