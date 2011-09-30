--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

require "org.robotlegs.Context"

BasicContext = {}

function BasicContext:new()
	local context = Context:new()
	context.superStartup = context.startup
	
	function context:startup()
		self:superStartup()
		
		self:mapCommand("healPlayer", "com.jessewarden.robotlegs.examples.basic.commands.HealPlayerCommand")
		
		self:mapMediator("Player", "com.jessewarden.robotlegs.examples.basic.mediators.PlayerMediator")
		self:mapMediator("HealthBar", "com.jessewarden.robotlegs.examples.basic.mediators.HealthBarMediator")
		self:mapMediator("HealButton", "com.jessewarden.robotlegs.examples.basic.mediators.HealButtonMediator")
		self:mapMediator("HealthText", "com.jessewarden.robotlegs.examples.basic.mediators.HealthTextMediator")
		
		self:dispatch({name="startThisMug", target=self})
	end

	return context
end

return BasicContext