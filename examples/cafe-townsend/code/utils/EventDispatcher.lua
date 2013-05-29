EventDispatcher = {}

function EventDispatcher:initialize(table)
	table.dispatchEvent = EventDispatcher.dispatchEvent
	table.addEventListener = EventDispatcher.addEventListener
	table.dispatchEvent = EventDispatcher.dispatchEvent
	table.hasEventListener = EventDispatcher.hasEventListener
	table._listeners = {}
	table._count = 0
end

function EventDispatcher:dispatchEvent(eventObj)
	--print("EventDispatcher::dispatchEvent, name: ", eventObj.name)
	local i = 1
	-- TODO: there was a bug in ActionScript 1's version
	-- where this loop would screw up if a listener removed itself during
	-- an event dispatchEvent; make sure we support that
	while self._listeners[i] do
		local obj = self._listeners[i]
		--print("obj.name: ", obj.name, ", eventObj.name: ", eventObj.name)
		if(obj.name == eventObj.name) then
			--print("a match, listener: ", obj.listener)
			if(type(obj.listener) == "function") then
				--print("calling function listener")
				obj.listener(eventObj)
			elseif(type(obj.listener) == "table") then
				--print("calling method on table")
				obj.listener[obj.name](obj.listener, eventObj)
			end
		end
		i = i + 1
	end
	return true
end

function EventDispatcher:addEventListener(name, listener)
	-- print("EventDispatcher::addEventListener, name: ", name)
	-- NOTE: don't add a listener if we already have one for the exact same scope
	if(name == nil) then error("EventDispatcher::addEventListener, name is nil.") end
	if(listener == nil) then error("EventDispatcher::addEventListener, listener is nil.") end
	if(self:hasEventListener(name, listener) == false) then
		self._count = self._count + 1
		return table.insert(self._listeners, {listener=listener, name=name, count=self._count})
	else
		return false
	end
end

-- 
function EventDispatcher:removeEventListener(name, handler)
	local i = 1
	while self._listeners[i] do
		local obj = self._listeners[i]
		if(obj.name == name and obj.listener == handler) then
			self._count = self._count - 1
			table.remove(self._listeners, i)
		else
			i = i + 1
		end
		
	end
	return true
end

function EventDispatcher:hasEventListener(name, handler)
	-- print("EventDispatcher::hasEventListener, name: ", name, ", handler: ", handler)
	assert(name ~= nil, "EventDispatcher::hasEventListener, name is nil.")
	assert(handler ~= nil, "EventDispatcher::hasEventListener, handler is nil.")
	
	for i,obj in ipairs(self._listeners) do
		if(obj.name == name and obj.listener == handler) then
			return true, i
		end
	end
	
	return false
end

return EventDispatcher
