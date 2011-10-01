--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

require "org.robotlegs.Context"

BasicContext = {}

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
		
		self:dispatch({name="startThisMug", target=self})
	end

	return context
end

return BasicContext