--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

local Context = require "org.robotlegs.Context"

local BasicContext = {}

function BasicContext:new()
	local context = Context:new()
	
	function context:startup()
		
		self:mapCommand("healPlayer", "com.jessewarden.robotlegs.examples.basic.commands.HealPlayerCommand")
		
		self:mapMediator("com.jessewarden.robotlegs.examples.basic.views.Player", 
							"com.jessewarden.robotlegs.examples.basic.mediators.PlayerMediator")

		self:mapMediator("com.jessewarden.robotlegs.examples.basic.views.HealthBar", 
							"com.jessewarden.robotlegs.examples.basic.mediators.HealthBarMediator")

		self:mapMediator("com.jessewarden.robotlegs.examples.basic.views.HealButton", 
							"com.jessewarden.robotlegs.examples.basic.mediators.HealButtonMediator")
		
		self:mapMediator("com.jessewarden.robotlegs.examples.basic.views.HealthText", 
							"com.jessewarden.robotlegs.examples.basic.mediators.HealthTextMediator")
		
		-- optional; you can dispatch whatever you want, but the point is, nothing in your
		-- app should really accept user input, etc. until this event has dispatched and everything
		-- everything is all wired up and ready to go.
		--Runtime:dispatch({name="startThisMug", target=self})
	end

	return context
end

return BasicContext