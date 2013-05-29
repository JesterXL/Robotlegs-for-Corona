--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

Mediator = {}

function Mediator:new()

	local mediator = {}
	mediator.viewInstance = nil
	
	function mediator:onRegister()
	end
	
	function mediator:onRemove()
	end
	
	function mediator:destroy()
		self.viewInstance = nil
	end
	
	return mediator
end

return Mediator