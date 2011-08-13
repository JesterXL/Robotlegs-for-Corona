--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

module (..., package.seeall)

require "robotlegs_globals"
require "robotlegs_MessageBus"

function new(viewInstance)
	assert(viewInstance ~= nil, "A Mediator class requires a viewInstance.")
	local mediator = require("robotlegs_Actor").new()
	mediator.ID = globals.getID()
	mediator.viewInstance = viewInstance
	
	function mediator:onRegister()
	end
	
	function mediator:onRemove()
	end
	
	function mediator:destroy()
		self.viewInstance = nil
	end
	
	return mediator
end