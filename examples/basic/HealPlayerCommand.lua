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
		PlayerModel.instance:heal()
		return true
	end

	return command
end