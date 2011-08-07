--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

module (..., package.seeall)

function new()
	local command = require("robotlegs.Command").new()
	
	function command:execute(event)
		require("PlayerModel")
		-- usually bootstrap commands or startup commands are where you setup
		-- all your data, models, etc. As your application grows, you can offload some
		-- of the mediator & command wrapping stuff here too. For now, we just setup our PlayerModel
		return true
	end

	return command
end