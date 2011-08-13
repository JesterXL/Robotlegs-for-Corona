--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

module (..., package.seeall)

require "robotlegs_globals"
require "robotlegs_MessageBus"

function new()
	local actor = {}
	actor.ID = globals.getID()
	
	function actor:dispatch(eventObj)
		MessageBus:dispatch(eventObj)
	end
	
	function actor:addListener(name, handler)
		MessageBus:addListener(name, handler)
	end
	
	function actor:removeListener(name, handler)
		MessageBus:removeListener(name, handler)
	end
	
	
	return actor
end