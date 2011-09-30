--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

require "org.robotlegs.Actor"

Command = {}

function Command:new()
	local command = Command:new()
	
	function command:execute(event)
		-- extend this, or just make sure to implement a method in your
		-- own class like this
	end

	return command
end

return Command