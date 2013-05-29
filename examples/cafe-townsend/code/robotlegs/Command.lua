--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

Command = {}

function Command:new()
	local command = {}
	command.context = nil -- this'll be the Context that created you
	
	function command:execute(event)
		-- extend this, or just make sure to implement a method in your
		-- own class like this
	end

	return command
end

return Command