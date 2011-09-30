--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

require "com.jessewarden.robotlegs.examples.basic.models.PlayerModel"

HealPlayerCommand = {}

function HealPlayerCommand:new()
	local command = {}
	
	function command:execute(event)
		PlayerModel.instance:heal()
		return true
	end

	return command
end

return HealPlayerCommand