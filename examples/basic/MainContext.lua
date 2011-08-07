--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

module (..., package.seeall)

function new()
	local context = require("robotlegs.Context").new()
	context.superStartup = context.startup
	
	function context:startup()
		self:superStartup()
		
		self:mapCommand("startThisMug", "BootstrapCommand")
		self:mapCommand("healPlayer", "HealPlayerCommand")
		
		self:mapMediator("Player", "PlayerMediator")
		self:mapMediator("HealthBar", "HealthBarMediator")
		self:mapMediator("HealButton", "HealButtonMediator")
		
		self:dispatch({name="startThisMug", target=self})
	end

	return context
end
